@module
Feature:
  In a game, you can recruit units.
  As an administrator, you should can create unitss, and as a gamer you can recruit units.

  Background:
    Given I use the "units" module

  Scenario: Successfully create an unit
    When I send a "POST" request with:
    """
    {
        "newUnit": {
            "name": "An unit",
            "quantity": 1,
            "picture": "blah"
        }
    }
    """
    When I send the request
    Then I should receive a 200 response
    Then it should be 1 element for this game
    And this element should have a property "isUnit" equal to "1"
    And this element should have a property "quantity" equal to 1
    And this element should have a property "picture" equal to "blah"
    And this game should have 1 "ElementAction"

    Scenario: Successfully remove an unit
      Given this game has 1 element
      Given this element name is "An unit"
      Given this element has a property named "isUnit" with value "1";
      When I send a "POST" request with:
      """
      {
          "removeUnit": "An unit"
      }
      """
      When I send the request
      Then I should receive a 200 response
      Then it should be 0 element for this game

      Scenario: Successfully edit an unit
        Given this game has 1 element
        Given this element name is "An unit"
        Given this element has a property named "isUnit" with value "1";
        When I send a "POST" request with:
        """
        {
            "units": [
                {
                    "id": {last_created_element.id},
                    "name": "A new unit",
                    "properties": [{
                        "name": "picture",
                        "value": "blah2"
                    },{
                        "name": "quantity",
                        "value": 2
                    }]

                }
            ]
        }
        """
        When I send the request
        Then I should receive a 200 response
        Then it should be 1 element for this game
        And this element should have a property "isUnit" equal to "1"
        And this element should have "A new unit" as "name"
        And this element should have a property "quantity" equal to 2
        And this element should have a property "picture" equal to "blah2"
        And this game should have 1 "ElementAction" with "name" equal to "booster"
