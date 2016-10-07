@module
Feature:
  As an administrator, you can create, edit and remove objects.

  Background:
    Given I use the "objects" module

  Scenario: Successfully create a money
    When I send a "POST" request with:
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
      When I send a "POST" request with:
      """
      {
          "removeObject": "An object"
      }
      """
      When I send the request
      Then I should receive a 200 response
      Then it should be 0 element for this game
