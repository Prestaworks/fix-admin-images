# ./vendor/bin/behat -c tests/Integration/Behaviour/behat.yml -s product --tags delete-multi-shop-combination
@restore-products-before-feature
@clear-cache-before-feature
@restore-shops-after-feature
@clear-cache-after-feature
@product-combination
@delete-combination
@product-multi-shop
@delete-multi-shop-combination
Feature: Delete combination from Back Office (BO) in multiple shops
  As a BO user
  I need to be able to delete product combinations from BO in multiple shops

  Background:
    Given language with iso code "en" is the default one
    And attribute group "Size" named "Size" in en language exists
    And attribute group "Color" named "Color" in en language exists
    And attribute "S" named "S" in en language exists
    And attribute "M" named "M" in en language exists
    And attribute "White" named "White" in en language exists
    And attribute "Black" named "Black" in en language exists
    And attribute "Blue" named "Blue" in en language exists
    And shop "shop1" with name "test_shop" exists
    And multistore feature is enabled
    And shop group "default_shop_group" with name "Default" exists
    And I add a shop "shop2" with name "default_shop_group" and color "red" for the group "default_shop_group"
    And I add a shop group "test_second_shop_group" with name "Test second shop group" and color "green"
    And I add a shop "shop3" with name "test_third_shop" and color "blue" for the group "test_second_shop_group"
    And I add a shop "shop4" with name "test_shop_without_url" and color "blue" for the group "test_second_shop_group"
    And single shop context is loaded
    Given I add product "product1" with following information:
      | name[en-US] | universal T-shirt |
      | type        | combinations      |
    And product product1 type should be combinations
    And I copy product product1 from shop shop1 to shop shop2
    And I generate combinations in shop "shop1" for product product1 using following attributes:
      | Size  | [S,M]              |
      | Color | [White,Black,Blue] |
    Then product "product1" should have the following combinations for shops "shop1":
      | id reference   | combination name        | reference | attributes           | impact on price | quantity | is default |
      | product1SWhite | Size - S, Color - White |           | [Size:S,Color:White] | 0               | 0        | true       |
      | product1SBlack | Size - S, Color - Black |           | [Size:S,Color:Black] | 0               | 0        | false      |
      | product1SBlue  | Size - S, Color - Blue  |           | [Size:S,Color:Blue]  | 0               | 0        | false      |
      | product1MWhite | Size - M, Color - White |           | [Size:M,Color:White] | 0               | 0        | false      |
      | product1MBlack | Size - M, Color - Black |           | [Size:M,Color:Black] | 0               | 0        | false      |
      | product1MBlue  | Size - M, Color - Blue  |           | [Size:M,Color:Blue]  | 0               | 0        | false      |
    And product "product1" default combination for shop "shop1" should be "product1SWhite"
    And product "product1" should have no combinations for shops "shop2"
    When I generate combinations in shop "shop2" for product product1 using following attributes:
      | Size  | [S,M]              |
      | Color | [White,Black,Blue] |
    Then product "product1" should have the following combinations for shops "shop2":
      | id reference        | combination name        | reference | attributes           | impact on price | quantity | is default |
      | product1SWhiteShop2 | Size - S, Color - White |           | [Size:S,Color:White] | 0               | 0        | true       |
      | product1SBlackShop2 | Size - S, Color - Black |           | [Size:S,Color:Black] | 0               | 0        | false      |
      | product1SBlueShop2  | Size - S, Color - Blue  |           | [Size:S,Color:Blue]  | 0               | 0        | false      |
      | product1MWhiteShop2 | Size - M, Color - White |           | [Size:M,Color:White] | 0               | 0        | false      |
      | product1MBlackShop2 | Size - M, Color - Black |           | [Size:M,Color:Black] | 0               | 0        | false      |
      | product1MBlueShop2  | Size - M, Color - Blue  |           | [Size:M,Color:Blue]  | 0               | 0        | false      |
    And product "product1" default combination for shop "shop2" should be "product1SWhiteShop2"

  Scenario: Delete one non-default combination from the default shop
    When I delete combination "product1SBlack" from shops "shop1"
    Then product "product1" should have the following combinations for shops "shop1":
      | id reference   | combination name        | reference | attributes           | impact on price | quantity | is default |
      | product1SWhite | Size - S, Color - White |           | [Size:S,Color:White] | 0               | 0        | true       |
      | product1SBlue  | Size - S, Color - Blue  |           | [Size:S,Color:Blue]  | 0               | 0        | false      |
      | product1MWhite | Size - M, Color - White |           | [Size:M,Color:White] | 0               | 0        | false      |
      | product1MBlack | Size - M, Color - Black |           | [Size:M,Color:Black] | 0               | 0        | false      |
      | product1MBlue  | Size - M, Color - Blue  |           | [Size:M,Color:Blue]  | 0               | 0        | false      |
    And product "product1" should have the following combinations for shops "shop2":
      | id reference        | combination name        | reference | attributes           | impact on price | quantity | is default |
      | product1SWhiteShop2 | Size - S, Color - White |           | [Size:S,Color:White] | 0               | 0        | true       |
      | product1SBlackShop2 | Size - S, Color - Black |           | [Size:S,Color:Black] | 0               | 0        | false      |
      | product1SBlueShop2  | Size - S, Color - Blue  |           | [Size:S,Color:Blue]  | 0               | 0        | false      |
      | product1MWhiteShop2 | Size - M, Color - White |           | [Size:M,Color:White] | 0               | 0        | false      |
      | product1MBlackShop2 | Size - M, Color - Black |           | [Size:M,Color:Black] | 0               | 0        | false      |
      | product1MBlueShop2  | Size - M, Color - Blue  |           | [Size:M,Color:Blue]  | 0               | 0        | false      |
    And product "product1" default combination for shop "shop1" should be "product1SWhite"
    And product "product1" default combination for shop "shop2" should be "product1SWhiteShop2"

  Scenario: Delete one default combination from the default shop
    When I delete combination "product1SWhite" from shops "shop1"
    Then product "product1" should have the following combinations for shops "shop1":
      | id reference   | combination name        | reference | attributes           | impact on price | quantity | is default |
      | product1SBlack | Size - S, Color - Black |           | [Size:S,Color:Black] | 0               | 0        | true       |
      | product1SBlue  | Size - S, Color - Blue  |           | [Size:S,Color:Blue]  | 0               | 0        | false      |
      | product1MWhite | Size - M, Color - White |           | [Size:M,Color:White] | 0               | 0        | false      |
      | product1MBlack | Size - M, Color - Black |           | [Size:M,Color:Black] | 0               | 0        | false      |
      | product1MBlue  | Size - M, Color - Blue  |           | [Size:M,Color:Blue]  | 0               | 0        | false      |
    And product "product1" should have the following combinations for shops "shop2":
      | id reference        | combination name        | reference | attributes           | impact on price | quantity | is default |
      | product1SWhiteShop2 | Size - S, Color - White |           | [Size:S,Color:White] | 0               | 0        | true       |
      | product1SBlackShop2 | Size - S, Color - Black |           | [Size:S,Color:Black] | 0               | 0        | false      |
      | product1SBlueShop2  | Size - S, Color - Blue  |           | [Size:S,Color:Blue]  | 0               | 0        | false      |
      | product1MWhiteShop2 | Size - M, Color - White |           | [Size:M,Color:White] | 0               | 0        | false      |
      | product1MBlackShop2 | Size - M, Color - Black |           | [Size:M,Color:Black] | 0               | 0        | false      |
      | product1MBlueShop2  | Size - M, Color - Blue  |           | [Size:M,Color:Blue]  | 0               | 0        | false      |
    And product "product1" default combination for shop "shop1" should be "product1SBlack"
    And product "product1" default combination for shop "shop2" should be "product1SWhiteShop2"

  Scenario: Delete one default combination from the non-default shop
    When I delete combination "product1SWhiteShop2" from shops "shop2"
    Then product "product1" should have the following combinations for shops "shop1":
      | id reference   | combination name        | reference | attributes           | impact on price | quantity | is default |
      | product1SWhite | Size - S, Color - White |           | [Size:S,Color:White] | 0               | 0        | true       |
      | product1SBlack | Size - S, Color - Black |           | [Size:S,Color:Black] | 0               | 0        | false      |
      | product1SBlue  | Size - S, Color - Blue  |           | [Size:S,Color:Blue]  | 0               | 0        | false      |
      | product1MWhite | Size - M, Color - White |           | [Size:M,Color:White] | 0               | 0        | false      |
      | product1MBlack | Size - M, Color - Black |           | [Size:M,Color:Black] | 0               | 0        | false      |
      | product1MBlue  | Size - M, Color - Blue  |           | [Size:M,Color:Blue]  | 0               | 0        | false      |
    Then product "product1" should have the following combinations for shops "shop2":
      | id reference        | combination name        | reference | attributes           | impact on price | quantity | is default |
      | product1SBlackShop2 | Size - S, Color - Black |           | [Size:S,Color:Black] | 0               | 0        | true       |
      | product1SBlueShop2  | Size - S, Color - Blue  |           | [Size:S,Color:Blue]  | 0               | 0        | false      |
      | product1MWhiteShop2 | Size - M, Color - White |           | [Size:M,Color:White] | 0               | 0        | false      |
      | product1MBlackShop2 | Size - M, Color - Black |           | [Size:M,Color:Black] | 0               | 0        | false      |
      | product1MBlueShop2  | Size - M, Color - Blue  |           | [Size:M,Color:Blue]  | 0               | 0        | false      |
    And product "product1" default combination for shop "shop1" should be "product1SWhite"
    And product "product1" default combination for shop "shop2" should be "product1SBlackShop2"

  Scenario: Delete one non-default combination from the non-default shop
    When I delete combination "product1SBlueShop2" from shops "shop2"
    Then product "product1" should have the following combinations for shops "shop1":
      | id reference   | combination name        | reference | attributes           | impact on price | quantity | is default |
      | product1SWhite | Size - S, Color - White |           | [Size:S,Color:White] | 0               | 0        | true       |
      | product1SBlack | Size - S, Color - Black |           | [Size:S,Color:Black] | 0               | 0        | false      |
      | product1SBlue  | Size - S, Color - Blue  |           | [Size:S,Color:Blue]  | 0               | 0        | false      |
      | product1MWhite | Size - M, Color - White |           | [Size:M,Color:White] | 0               | 0        | false      |
      | product1MBlack | Size - M, Color - Black |           | [Size:M,Color:Black] | 0               | 0        | false      |
      | product1MBlue  | Size - M, Color - Blue  |           | [Size:M,Color:Blue]  | 0               | 0        | false      |
    Then product "product1" should have the following combinations for shops "shop2":
      | id reference        | combination name        | reference | attributes           | impact on price | quantity | is default |
      | product1SWhiteShop2 | Size - S, Color - White |           | [Size:S,Color:White] | 0               | 0        | true       |
      | product1SBlackShop2 | Size - S, Color - Black |           | [Size:S,Color:Black] | 0               | 0        | false      |
      | product1MWhiteShop2 | Size - M, Color - White |           | [Size:M,Color:White] | 0               | 0        | false      |
      | product1MBlackShop2 | Size - M, Color - Black |           | [Size:M,Color:Black] | 0               | 0        | false      |
      | product1MBlueShop2  | Size - M, Color - Blue  |           | [Size:M,Color:Blue]  | 0               | 0        | false      |
    And product "product1" default combination for shop "shop1" should be "product1SWhite"
    And product "product1" default combination for shop "shop2" should be "product1SWhiteShop2"

  Scenario: Delete all combinations one by one from the default shop
    When I delete combination "product1SWhite" from shops "shop1"
    And I delete combination "product1SBlack" from shops "shop1"
    And I delete combination "product1SBlue" from shops "shop1"
    And I delete combination "product1MWhite" from shops "shop1"
    And I delete combination "product1MBlack" from shops "shop1"
    And I delete combination "product1MBlue" from shops "shop1"
    And product "product1" should have no combinations for shops "shop1"
    And product "product1" should have the following combinations for shops "shop2":
      | id reference        | combination name        | reference | attributes           | impact on price | quantity | is default |
      | product1SWhiteShop2 | Size - S, Color - White |           | [Size:S,Color:White] | 0               | 0        | true       |
      | product1SBlackShop2 | Size - S, Color - Black |           | [Size:S,Color:Black] | 0               | 0        | false      |
      | product1SBlueShop2  | Size - S, Color - Blue  |           | [Size:S,Color:Blue]  | 0               | 0        | false      |
      | product1MWhiteShop2 | Size - M, Color - White |           | [Size:M,Color:White] | 0               | 0        | false      |
      | product1MBlackShop2 | Size - M, Color - Black |           | [Size:M,Color:Black] | 0               | 0        | false      |
      | product1MBlueShop2  | Size - M, Color - Blue  |           | [Size:M,Color:Blue]  | 0               | 0        | false      |
    And product "product1" should not have a default combination for shop "shop1"
    And product "product1" default combination for shop "shop2" should be "product1SWhiteShop2"

  Scenario: Delete all combinations one by one from all shops
    When I delete combination "product1SWhite" from shops "shop1"
    And I delete combination "product1SBlack" from shops "shop1"
    And I delete combination "product1SBlue" from shops "shop1"
    And I delete combination "product1MWhite" from shops "shop1"
    And I delete combination "product1MBlack" from shops "shop1"
    And I delete combination "product1MBlue" from shops "shop1"
    And I delete combination "product1SWhiteShop2" from shops "shop2"
    And I delete combination "product1SBlackShop2" from shops "shop2"
    And I delete combination "product1SBlueShop2" from shops "shop2"
    And I delete combination "product1MWhiteShop2" from shops "shop2"
    And I delete combination "product1MBlackShop2" from shops "shop2"
    And I delete combination "product1MBlueShop2" from shops "shop2"
    Then product "product1" should have no combinations for shops "shop1"
    And product "product1" should have no combinations for shops "shop2"
    And product "product1" should not have a default combination for shop "shop1"
    And product "product1" should not have a default combination for shop "shop2"

  Scenario: Delete bulk delete combinations from specified shop
    When I delete following combinations of product product1 from shop "shop1":
      | id reference   |
      | product1SWhite |
      | product1SBlack |
      | product1SBlue  |
    Then product "product1" should have the following combinations for shops "shop1":
      | id reference   | combination name        | reference | attributes           | impact on price | quantity | is default |
      | product1MWhite | Size - M, Color - White |           | [Size:M,Color:White] | 0               | 0        | true       |
      | product1MBlack | Size - M, Color - Black |           | [Size:M,Color:Black] | 0               | 0        | false      |
      | product1MBlue  | Size - M, Color - Blue  |           | [Size:M,Color:Blue]  | 0               | 0        | false      |
    And product "product1" default combination for shop "shop1" should be "product1MWhite"
    And product "product1" should have the following combinations for shops "shop2":
      | id reference        | combination name        | reference | attributes           | impact on price | quantity | is default |
      | product1SWhiteShop2 | Size - S, Color - White |           | [Size:S,Color:White] | 0               | 0        | true       |
      | product1SBlackShop2 | Size - S, Color - Black |           | [Size:S,Color:Black] | 0               | 0        | false      |
      | product1SBlueShop2  | Size - S, Color - Blue  |           | [Size:S,Color:Blue]  | 0               | 0        | false      |
      | product1MWhiteShop2 | Size - M, Color - White |           | [Size:M,Color:White] | 0               | 0        | false      |
      | product1MBlackShop2 | Size - M, Color - Black |           | [Size:M,Color:Black] | 0               | 0        | false      |
      | product1MBlueShop2  | Size - M, Color - Blue  |           | [Size:M,Color:Blue]  | 0               | 0        | false      |
    And product "product1" default combination for shop "shop2" should be "product1SWhiteShop2"
    When I delete following combinations of product product1 from shop "shop2":
      | id reference        |
      | product1MBlueShop2  |
      | product1MBlackShop2 |
      | product1MWhiteShop2 |
    Then product "product1" should have the following combinations for shops "shop2":
      | id reference        | combination name        | reference | attributes           | impact on price | quantity | is default |
      | product1SWhiteShop2 | Size - S, Color - White |           | [Size:S,Color:White] | 0               | 0        | true       |
      | product1SBlackShop2 | Size - S, Color - Black |           | [Size:S,Color:Black] | 0               | 0        | false      |
      | product1SBlueShop2  | Size - S, Color - Blue  |           | [Size:S,Color:Blue]  | 0               | 0        | false      |
    And product "product1" default combination for shop "shop2" should be "product1SWhiteShop2"
    And product "product1" should have the following combinations for shops "shop1":
      | id reference   | combination name        | reference | attributes           | impact on price | quantity | is default |
      | product1MWhite | Size - M, Color - White |           | [Size:M,Color:White] | 0               | 0        | true       |
      | product1MBlack | Size - M, Color - Black |           | [Size:M,Color:Black] | 0               | 0        | false      |
      | product1MBlue  | Size - M, Color - Blue  |           | [Size:M,Color:Blue]  | 0               | 0        | false      |
    And product "product1" default combination for shop "shop1" should be "product1MWhite"
    When I delete following combinations of product product1 from shop "shop1":
      | id reference   |
      | product1MWhite |
      | product1MBlack |
      | product1MBlue  |
    And I delete following combinations of product product1 from shop "shop2":
      | id reference        |
      | product1SWhiteShop2 |
      | product1SBlackShop2 |
      | product1SBlueShop2  |
    Then product "product1" should have no combinations for shops "shop1"
    And product "product1" should not have a default combination for shop "shop1"
    Then product "product1" should have no combinations for shops "shop2"
    And product "product1" should not have a default combination for shop "shop2"

  Scenario: Remove all the combinations for a specific shop and generate the same combinations again for the same shop
    When I delete following combinations of product product1 from shop "shop1":
      | id reference   |
      | product1SWhite |
      | product1SBlack |
      | product1SBlue  |
      | product1MWhite |
      | product1MBlack |
      | product1MBlue  |
    Then product "product1" should have no combinations for shops "shop1"
    And product "product1" should not have a default combination for shop "shop1"
    And I generate combinations in shop "shop1" for product product1 using following attributes:
      | Size  | [S,M]              |
      | Color | [White,Black,Blue] |
    Then product "product1" should have the following combinations for shops "shop1":
      | id reference   | combination name        | reference | attributes           | impact on price | quantity | is default |
      | product1SWhite | Size - S, Color - White |           | [Size:S,Color:White] | 0               | 0        | true       |
      | product1SBlack | Size - S, Color - Black |           | [Size:S,Color:Black] | 0               | 0        | false      |
      | product1SBlue  | Size - S, Color - Blue  |           | [Size:S,Color:Blue]  | 0               | 0        | false      |
      | product1MWhite | Size - M, Color - White |           | [Size:M,Color:White] | 0               | 0        | false      |
      | product1MBlack | Size - M, Color - Black |           | [Size:M,Color:Black] | 0               | 0        | false      |
      | product1MBlue  | Size - M, Color - Blue  |           | [Size:M,Color:Blue]  | 0               | 0        | false      |
    And product "product1" default combination for shop "shop1" should be "product1SWhite"
    And product "product1" should have the following combinations for shops "shop2":
      | id reference        | combination name        | reference | attributes           | impact on price | quantity | is default |
      | product1SWhiteShop2 | Size - S, Color - White |           | [Size:S,Color:White] | 0               | 0        | true       |
      | product1SBlackShop2 | Size - S, Color - Black |           | [Size:S,Color:Black] | 0               | 0        | false      |
      | product1SBlueShop2  | Size - S, Color - Blue  |           | [Size:S,Color:Blue]  | 0               | 0        | false      |
      | product1MWhiteShop2 | Size - M, Color - White |           | [Size:M,Color:White] | 0               | 0        | false      |
      | product1MBlackShop2 | Size - M, Color - Black |           | [Size:M,Color:Black] | 0               | 0        | false      |
      | product1MBlueShop2  | Size - M, Color - Blue  |           | [Size:M,Color:Blue]  | 0               | 0        | false      |
    And product "product1" default combination for shop "shop2" should be "product1SWhiteShop2"
    And following combination ids should match:
      | product1SWhite      |
      | product1SWhiteShop2 |
    And following combination ids should match:
      | product1SBlack      |
      | product1SBlackShop2 |
    And following combination ids should match:
      | product1SBlue      |
      | product1SBlueShop2 |
    And following combination ids should match:
      | product1MWhite      |
      | product1MWhiteShop2 |
    And following combination ids should match:
      | product1MBlack      |
      | product1MBlackShop2 |
    And following combination ids should match:
      | product1MBlue      |
      | product1MBlueShop2 |
