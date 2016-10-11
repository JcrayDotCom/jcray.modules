@module
@resources
Feature:
  In a game, you have resources.

  Background:
    Given I use the "resources" module

Scenario: Successfully create a Resource
  When I send a "POST" request with:
  """
  {
      "newResource": {
          "name": "Sample Resource",
          "properties": {
              "quantity": 1000,
              "picture": "blah"
          }
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | resources[0].name                | Sample Resource   |
      | resources[0].properties.picture  | blah  |
      | resources[0].properties.quantity | 1000   |
      | resources[0].properties.type     | Resource      |

Scenario: Successfully create another Resource
  When I send a "POST" request with:
  """
  {
      "newResource": {
          "name": "An other Resource",
          "properties": {
              "quantity": 10,
              "picture": "foo"
          }
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | resources[0].name                | Sample Resource   |
      | resources[0].properties.picture  | blah  |
      | resources[0].properties.quantity | 1000   |
      | resources[0].properties.type     | Resource      |
      | resources[1].name                | An other Resource   |
      | resources[1].properties.picture | foo       |
      | resources[1].properties.quantity | 10        |
      | resources[1].properties.type  | Resource      |

Scenario: Successfully edit a Resource
  When I send a "POST" request with:
  """
  {
      "resources": [
          {
              "id": {previous_nodes.resources[0].id},
              "name": "A new Resource",
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
      | resources[0].name                  | A new Resource   |
      | resources[0].properties.picture    | blah2                 |
      | resources[0].properties.quantity   | 2                     |
      | resources[0].properties.type       | Resource         |

Scenario: Successfully remove a Resource
  When I send a "POST" request with:
  """
  {
      "removeResource": "{previous_nodes.resources[1].name}"
  }
  """
  Then the response status code should be 200
  And the JSON node "resources" should have 1 element
