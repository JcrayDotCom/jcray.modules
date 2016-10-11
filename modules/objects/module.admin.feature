@module
@objects
@skip

Feature:
  As an administrator, you can create, edit and remove objects.

  Background:
    Given I use the "objects" module

  Scenario: Successfully create an object
    When I send a "POST" request with:
    """
    {
        "newObject": {
            "name": "An object",
            "properties": {
                "quantity": 0,
                "picture": "blah"
            }
        }
    }
    """
    Then print last response
    Then the response status code should be 200
    Then the JSON nodes should be equal to:
        | objects[0].name                | An object    |
        | objects[0].properties.quantity  | 0     |
        | objects[0].properties.picture | blah         |
        | objects[0].properties.type | Object       |

    Scenario: Successfully remove an object
      When I send a "POST" request with:
      """
      {
          "removeObject": "An object"
      }
      """
      Then the response status code should be 200
      And the JSON node "objects" should have 0 element
