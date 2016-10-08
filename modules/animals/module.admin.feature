@module
@animals
Feature:
  In a game, you have animals.

  Background:
    Given I use the "animals" module

Scenario: Successfully create a Animal
  When I send a "POST" request with:
  """
  {
      "newAnimal": {
          "name": "A Animal",
          "quantity": 1000,
          "picture": "blah"
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | animals[0].name                | A Animal   |
      | animals[0].properties[0].name  | quantity  |
      | animals[0].properties[0].value | 1000      |
      | animals[0].properties[1].name  | picture   |
      | animals[0].properties[1].value | blah      |
      | animals[0].properties[2].name  | type      |
      | animals[0].properties[2].value | Animal     |

Scenario: Successfully edit a Animal
  When I send a "POST" request with:
  """
  {
      "animals": [
          {
              "id": {previous_nodes.animals[0].id},
              "name": "A new Animal",
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
      | animals[0].name                | A new Animal   |
      | animals[0].properties[0].name  | quantity    |
      | animals[0].properties[0].value | 2           |
      | animals[0].properties[1].name  | picture     |
      | animals[0].properties[1].value | blah2       |
      | animals[0].properties[2].name  | type        |
      | animals[0].properties[2].value | Animal     |

Scenario: Successfully remove a Animal
  When I send a "POST" request with:
  """
  {
      "removeAnimal": "{previous_nodes.animals[0].name}"
  }
  """
  Then the response status code should be 200
  And the JSON node "animals" should have 0 element
