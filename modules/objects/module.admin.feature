@module
@objects
Feature:
  In a game, you have objects.

  Background:
    Given I use the "objects" module

Scenario: Successfully create a Object with requirable property
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
      | objects[0].name                      | Sample Object   |
      | objects[0].properties.picture        | blah                   |
      | objects[0].properties.quantity       | 1000                   |
      | objects[0].properties.type           | Object          |
      | objects[0].properties.requirable     | 1                      |

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

Scenario: Successfully list all Object
  When I send a "POST" request with:
  """
  {}
  """
  Then the response status code should be 200

Scenario: Successfully create a Object requirement
    When I send a "POST" request with:
    """
    {
        "requirementsElementObject": {
                "id": {previous_nodes.objects[0].id},
                "requirements": [{
                    "required_element": {
                        "id": {previous_nodes.objects[1].id}
                    },
                    "ratio": 10
                }]
        }
    }
    """
    Then the response status code should be 200

Scenario: Successfully list all Object
  When I send a "POST" request with:
  """
  {}
  """
  Then the response status code should be 200


Scenario: Successfully edit a Object requirement
    When I send a "POST" request with:
    """
    {
        "requirementsElementObject": {
                "id": {previous_nodes.objects[0].id},
                "requirements": [{
                    "required_element": {
                        "id": {previous_nodes.objects[0].requirements[1].required_element.id}
                    },
                    "ratio": 20
                }]
        }
    }
    """
    Then the response status code should be 200
    Then the JSON nodes should be equal to:
      | objects[0].requirements[1].ratio    | 20   |

Scenario: Successfully retrieve objects
  When I send a "POST" request with:
  """
  {

  }
  """
  Then the response status code should be 200

Scenario: Successfully create an effect on an Object
  When I send a "POST" request with:
  """
  {
      "effectsElementObject": {
          "id": {previous_nodes.objects[0].id}
      },
      "newEffect": {
          "propertyName": "testProperty",
          "quantity": "3",
          "type": "global"
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | objects[0].effects[0].property_name  | testProperty   |
      | objects[0].effects[0].quantity       | 3            |


Scenario: Successfully create an other effect on an Object
  When I send a "POST" request with:
  """
    {
        "effectsElementObject": {
            "id": {previous_nodes.objects[0].id}
        },
        "newEffect": {
            "propertyName": "testProperty2",
            "quantity": "3",
            "type": "global"
        }
    }
  """
  Then the response status code should be 200
  And the JSON nodes should be equal to:
      | objects[0].effects[0].property_name  | testProperty   |
      | objects[0].effects[0].quantity       | 3            |
      | objects[0].effects[1].property_name  | testProperty2   |
      | objects[0].effects[1].quantity       | 3               |
  And the JSON node "objects[0].effects" should have 2 elements


Scenario: Successfully remove an effect on an Object
  When I send a "POST" request with:
  """
    {
        "effectsElementObject": {
            "id": {previous_nodes.objects[0].id}
        },
        "removeEffectObject": {
            "id": {previous_nodes.created_effects[0].id}
        }
    }
  """
  Then the response status code should be 200
  And the JSON node "objects[0].effects" should have 1 element

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
