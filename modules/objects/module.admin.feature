@module
Feature:
  As an administrator, you can create, edit and remove objects.

  Background:
    Given I have signed up
    Given there is a game
    Given the game's slug is game1
    Given I load the module "objects"
    Given I prepare a POST request on "/modules/{last_created_module}/render?game={last_created_game}"
    And the following headers:
      | Authorization | Bearer {my_api_token}             |
      | Content-Type  | application/x-www-form-urlencoded |

  Scenario: Successfully create a money
    Given I send the following body:
    """
    {
        "newObject": {
            "name": "An object",
            "quantity": 0,
            "picture": "blah"
        }
    }
    """
    When I send the request
    Then I should receive a 200 response
    Then it should be 1 element for this game
    And this element should have a property "isObject" equal to "1"
    And this element should have a property "quantity" equal to 0
    And this element should have a property "picture" equal to "blah"

    Scenario: Successfully remove an object
      Given this game has 1 element
      Given this element name is "An object"
      Given this element has a property named "isObject" with value "1";
      Given I send the following body:
      """
      {
          "removeObject": "An object"
      }
      """
      When I send the request
      Then I should receive a 200 response
      Then it should be 0 element for this game
