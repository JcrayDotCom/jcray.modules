@module
@moneys
Feature:
  In a game, you can buy and sell elements.
  To pay or buy these elements you should have moneys.
  As an administrator, you should can create moneys, and as a gamer you should have several types of money.

  Background:
    Given I use the "moneys" module

  Scenario: Successfully create a money
    When I send a "POST" request with:
    """
    {
        "newMoney": {
            "name": "A money",
            "quantity": 1000,
            "picture": "blah"
        }
    }
    """
    Then the response status code should be 200
    Then the JSON nodes should be equal to:
        | moneys[0].name                | A money   |
        | moneys[0].properties[0].name  | quantity  |
        | moneys[0].properties[0].value | 1000      |
        | moneys[0].properties[1].name  | picture   |
        | moneys[0].properties[1].value | blah      |
        | moneys[0].properties[2].name  | type      |
        | moneys[0].properties[2].value | Money     |

    Scenario: Successfully remove a money
      When I send a "POST" request with:
      """
      {
          "newMoney": {
              "name": "A money bis",
              "quantity": 1000,
              "picture": "blah"
          },
          "removeMoney": "{previous_nodes.moneys[0].name}"
      }
      """
      Then the response status code should be 200
      And the JSON nodes should be equal to:
        | moneys[0].name                | A money bis   |
        | moneys[0].properties[0].name  | quantity      |
        | moneys[0].properties[0].value | 1000          |
        | moneys[0].properties[1].name  | picture       |
        | moneys[0].properties[1].value | blah          |
        | moneys[0].properties[2].name  | type          |
        | moneys[0].properties[2].value | Money         |

      Scenario: Successfully edit a money
        When I send a "POST" request with:
        """
        {
            "moneys": [
                {
                    "id": {previous_nodes.moneys[0].id},
                    "name": "A new money name",
                    "properties": [{
                        "name": "picture",
                        "value": "blah2"
                    },{
                        "name": "quantity",
                        "value": 1500
                    }]

                }
            ]
        }
        """
        Then the response status code should be 200
        And the JSON nodes should be equal to:
            | moneys[0].name                | A new money name  |
            | moneys[0].properties[0].name  | quantity          |
            | moneys[0].properties[0].value | 1500              |
            | moneys[0].properties[1].name  | picture           |
            | moneys[0].properties[1].value | blah2             |
            | moneys[0].properties[2].name  | type              |
            | moneys[0].properties[2].value | Money             |
