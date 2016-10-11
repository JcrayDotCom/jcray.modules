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
          "quantity": 1000,
          "picture": "blah"
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | resources[0].name                | Sample Resource   |
      | resources[0].properties[0].name  | quantity  |
      | resources[0].properties[0].value | 1000      |
      | resources[0].properties[1].name  | picture   |
      | resources[0].properties[1].value | blah      |
      | resources[0].properties[2].name  | type      |
      | resources[0].properties[2].value | Resource     |

Scenario: Successfully create another Resource
  When I send a "POST" request with:
  """
  {
      "newResource": {
          "name": "An other Resource",
          "quantity": 10,
          "picture": "foo"
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | resources[0].name                | Sample Resource   |
      | resources[0].properties[0].name  | quantity  |
      | resources[0].properties[0].value | 1000      |
      | resources[0].properties[1].name  | picture   |
      | resources[0].properties[1].value | blah      |
      | resources[0].properties[2].name  | type      |
      | resources[0].properties[2].value | Resource     |
      | resources[1].name                | An other Resource   |
      | resources[1].properties[0].name  | quantity  |
      | resources[1].properties[0].value | 10        |
      | resources[1].properties[1].name  | picture   |
      | resources[1].properties[1].value | foo       |
      | resources[1].properties[2].name  | type      |
      | resources[1].properties[2].value | Resource     |

Scenario: Successfully edit a Resource
  When I send a "POST" request with:
  """
  {
      "resources": [
          {
              "id": {previous_nodes.resources[0].id},
              "name": "A new Resource",
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
      | resources[0].name                | A new Resource   |
      | resources[0].properties[0].name  | quantity    |
      | resources[0].properties[0].value | 2           |
      | resources[0].properties[1].name  | picture     |
      | resources[0].properties[1].value | blah2       |
      | resources[0].properties[2].name  | type        |
      | resources[0].properties[2].value | Resource     |

Scenario: Successfully remove a Resource
  When I send a "POST" request with:
  """
  {
      "removeResource": "{previous_nodes.resources[1].name}"
  }
  """
  Then the response status code should be 200
  And the JSON node "resources" should have 1 element
