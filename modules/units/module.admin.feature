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
    Then the response status code should be 200
    Then the JSON nodes should be equal to:
        | units[0].name                | An unit   |
        | units[0].properties[0].name  | quantity  |
        | units[0].properties[0].value | 1         |
        | units[0].properties[1].name  | picture   |
        | units[0].properties[1].value | blah      |
        | units[0].properties[2].name  | isUnit    |
        | units[0].properties[2].value | 1         |

      Scenario: Successfully edit an unit
        When I send a "POST" request with:
        """
        {
            "units": [
                {
                    "id": {previous_nodes.units[0].id},
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
        Then the response status code should be 200
        Then the JSON nodes should be equal to:
            | units[0].name                | A new unit   |
            | units[0].properties[0].name  | quantity  |
            | units[0].properties[0].value | 2         |
            | units[0].properties[1].name  | picture   |
            | units[0].properties[1].value | blah2     |
            | units[0].properties[2].name  | isUnit    |
            | units[0].properties[2].value | 1         |

    Scenario: Successfully remove an unit
      When I send a "POST" request with:
      """
      {
          "removeUnit": "A new unit"
      }
      """
      Then the response status code should be 200
      And the JSON node "units" should have 0 element
