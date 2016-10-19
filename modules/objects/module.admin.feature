@module
@objects
Feature:
  In a game, you have objects.

  Background:
    Given I use the "objects" module

Scenario: Successfully create a Object
  When I send a "POST" request with:
  """
  {
      "newObject": {
          "name": "Sample Object",
          "properties": {
              "quantity": 1000,
              "picture": "blah"
          }
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | objects[0].name                | Sample Object   |
      | objects[0].properties.picture  | blah  |
      | objects[0].properties.quantity | 1000   |
      | objects[0].properties.type     | Object      |

Scenario: Successfully create another Object
  When I send a "POST" request with:
  """
  {
      "newObject": {
          "name": "An other Object",
          "properties": {
              "quantity": 10,
              "picture": "foo"
          }
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | objects[0].name                | Sample Object   |
      | objects[0].properties.picture  | blah  |
      | objects[0].properties.quantity | 1000   |
      | objects[0].properties.type     | Object      |
      | objects[1].name                | An other Object   |
      | objects[1].properties.picture | foo       |
      | objects[1].properties.quantity | 10        |
      | objects[1].properties.type  | Object      |

Scenario: Successfully edit a Object
  When I send a "POST" request with:
  """
  {
      "objects": [
          {
              "id": {previous_nodes.objects[0].id},
              "name": "A new Object",
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
      | objects[0].name                  | A new Object   |
      | objects[0].properties.picture    | blah2                 |
      | objects[0].properties.quantity   | 2                     |
      | objects[0].properties.type       | Object         |

Scenario: Successfully remove a Object
  When I send a "POST" request with:
  """
  {
      "removeObject": "{previous_nodes.objects[1].name}"
  }
  """
  Then the response status code should be 200
  And the JSON node "objects" should have 1 element
