@module
@buildings
Feature:
  In a game, you have buildings.

  Background:
    Given I use the "buildings" module

Scenario: Successfully create a Building with requirable property
  When I send a "POST" request with:
  """
  {
      "newBuilding": {
          "name": "Sample Building",
          "properties": {
              "quantity": 1000,
              "picture": "blah"
          }
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | buildings[0].name                      | Sample Building   |
      | buildings[0].properties.picture        | blah                   |
      | buildings[0].properties.quantity       | 1000                   |
      | buildings[0].properties.type           | Building          |
      | buildings[0].properties.requirable     | 1                      |

Scenario: Successfully create a Building
  When I send a "POST" request with:
  """
  {
      "newBuilding": {
          "name": "Sample Building",
          "properties": {
              "quantity": 1000,
              "picture": "blah"
          }
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | buildings[0].name                | Sample Building   |
      | buildings[0].properties.picture  | blah  |
      | buildings[0].properties.quantity | 1000   |
      | buildings[0].properties.type     | Building      |

Scenario: Successfully create another Building
  When I send a "POST" request with:
  """
  {
      "newBuilding": {
          "name": "An other Building",
          "properties": {
              "quantity": 10,
              "picture": "foo"
          }
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | buildings[0].name                | Sample Building   |
      | buildings[0].properties.picture  | blah  |
      | buildings[0].properties.quantity | 1000   |
      | buildings[0].properties.type     | Building      |
      | buildings[1].name                | An other Building   |
      | buildings[1].properties.picture | foo       |
      | buildings[1].properties.quantity | 10        |
      | buildings[1].properties.type  | Building      |

Scenario: Successfully list all Building
  When I send a "POST" request with:
  """
  {}
  """
  Then the response status code should be 200

Scenario: Successfully create a Building requirement
    When I send a "POST" request with:
    """
    {
        "requirementsElementBuilding": {
                "id": {previous_nodes.buildings[0].id},
                "requirements": [{
                    "required_element": {
                        "id": {previous_nodes.buildings[1].id}
                    },
                    "ratio": 10
                }]
        }
    }
    """
    Then the response status code should be 200
    Then the JSON nodes should be equal to:
        | buildings[0].requirements[1].ratio    | 10   |

Scenario: Successfully list all Building
  When I send a "POST" request with:
  """
  {}
  """
  Then the response status code should be 200


Scenario: Successfully edit a Building requirement
    When I send a "POST" request with:
    """
    {
        "requirementsElementBuilding": {
                "id": {previous_nodes.buildings[0].id},
                "requirements": [{
                    "required_element": {
                        "id": {previous_nodes.buildings[0].requirements[1].required_element.id}
                    },
                    "ratio": 20
                }]
        }
    }
    """
    Then the response status code should be 200
    Then the JSON nodes should be equal to:
      | buildings[0].requirements[1].ratio    | 20   |

Scenario: Successfully edit a Building
  When I send a "POST" request with:
  """
  {
      "buildings": [
          {
              "id": {previous_nodes.buildings[0].id},
              "name": "A new Building",
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
      | buildings[0].name                  | A new Building   |
      | buildings[0].properties.picture    | blah2                 |
      | buildings[0].properties.quantity   | 2                     |
      | buildings[0].properties.type       | Building         |

Scenario: Successfully remove a Building
  When I send a "POST" request with:
  """
  {
      "removeBuilding": "{previous_nodes.buildings[1].name}"
  }
  """
  Then the response status code should be 200
  And the JSON node "buildings" should have 1 element
