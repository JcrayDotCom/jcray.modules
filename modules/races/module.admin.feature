@module
@races
Feature:
  In a game, you have races.

  Background:
    Given I use the "races" module

Scenario: Successfully create a Race
  When I send a "POST" request with:
  """
  {
      "newRace": {
          "name": "Sample Race",
          "properties": {
              "quantity": 1000,
              "picture": "blah"
          }
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | races[0].name                | Sample Race   |
      | races[0].properties.picture  | blah  |
      | races[0].properties.quantity | 1000   |
      | races[0].properties.type     | Race      |

Scenario: Successfully create another Race
  When I send a "POST" request with:
  """
  {
      "newRace": {
          "name": "An other Race",
          "properties": {
              "quantity": 10,
              "picture": "foo"
          }
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | races[0].name                | Sample Race   |
      | races[0].properties.picture  | blah  |
      | races[0].properties.quantity | 1000   |
      | races[0].properties.type     | Race      |
      | races[1].name                | An other Race   |
      | races[1].properties.picture | foo       |
      | races[1].properties.quantity | 10        |
      | races[1].properties.type  | Race      |

Scenario: Successfully edit a Race
  When I send a "POST" request with:
  """
  {
      "races": [
          {
              "id": {previous_nodes.races[0].id},
              "name": "A new Race",
              "properties": {
                  "picture": "blah2",
                  "quantity": 2
              }

          }
      ]
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | races[0].name                  | A new Race   |
      | races[0].properties.picture    | blah2                 |
      | races[0].properties.quantity   | 2                     |
      | races[0].properties.type       | Race         |

Scenario: Successfully remove a Race
  When I send a "POST" request with:
  """
  {
      "removeRace": "{previous_nodes.races[1].name}"
  }
  """
  Then the response status code should be 200
  And the JSON node "races" should have 1 element
