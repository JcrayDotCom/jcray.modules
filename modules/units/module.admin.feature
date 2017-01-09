@module
@units
Feature:
  In a game, you have units.

  Background:
    Given I use the "units" module

Scenario: Successfully create a Unit with requirable property
  When I send a "POST" request with:
  """
  {
      "newUnit": {
          "name": "Sample Unit",
          "properties": {
              "quantity": 1000,
              "picture": "blah"
          }
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | units[0].name                      | Sample Unit   |
      | units[0].properties.picture        | blah                   |
      | units[0].properties.quantity       | 1000                   |
      | units[0].properties.type           | Unit          |
      | units[0].properties.requirable     | 1                      |

Scenario: Successfully create a Unit
  When I send a "POST" request with:
  """
  {
      "newUnit": {
          "name": "Sample Unit",
          "properties": {
              "quantity": 1000,
              "picture": "blah"
          }
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | units[0].name                | Sample Unit   |
      | units[0].properties.picture  | blah  |
      | units[0].properties.quantity | 1000   |
      | units[0].properties.type     | Unit      |

Scenario: Successfully create another Unit
  When I send a "POST" request with:
  """
  {
      "newUnit": {
          "name": "An other Unit",
          "properties": {
              "quantity": 10,
              "picture": "foo"
          }
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | units[0].name                | Sample Unit   |
      | units[0].properties.picture  | blah  |
      | units[0].properties.quantity | 1000   |
      | units[0].properties.type     | Unit      |
      | units[1].name                | An other Unit   |
      | units[1].properties.picture | foo       |
      | units[1].properties.quantity | 10        |
      | units[1].properties.type  | Unit      |

Scenario: Successfully create a stat
  When I send a "POST" request with:
  """
  {
      "newStat": {
          "name": "Sample stat",
          "quantity": 10
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | unitsStats[0].name                | Sample stat   |
      | unitsStats[0].quantity            | 10            |


Scenario: Successfully create an other stat
  When I send a "POST" request with:
  """
  {
      "newStat": {
          "name": "Another sample stat",
          "quantity": 5
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | unitsStats[0].name                | Sample stat            |
      | unitsStats[0].quantity            | 10                     |
      | unitsStats[1].name                | Another sample stat    |
      | unitsStats[1].quantity            | 5                      |

Scenario: Successfully remove a stat
  When I send a "POST" request with:
  """
  {
      "removeUnitStat": {
          "name": "Another sample stat"
      }
  }
  """
  Then the response status code should be 200
  And the JSON node "unitsStats" should have 1 element


Scenario: Successfully edit a stat
  When I send a "POST" request with:
  """
  {
      "unitsStats": [
          {
              "name": "A stat",
              "quantity": 11
          }
      ]
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
    | unitsStats[0].name                | A stat   |
    | unitsStats[0].quantity            | 11       |

Scenario: Successfully list all Unit
  When I send a "POST" request with:
  """
  {}
  """
  Then the response status code should be 200

Scenario: Successfully create a Unit requirement
    When I send a "POST" request with:
    """
    {
        "requirementsElementUnit": {
                "id": {previous_nodes.units[0].id},
                "requirements": [{
                    "required_element": {
                        "id": {previous_nodes.units[1].id}
                    },
                    "ratio": 10
                }]
        }
    }
    """
    Then the response status code should be 200

Scenario: Successfully list all Unit
  When I send a "POST" request with:
  """
  {}
  """
  Then the response status code should be 200


Scenario: Successfully edit a Unit requirement
    When I send a "POST" request with:
    """
    {
        "requirementsElementUnit": {
                "id": {previous_nodes.units[0].id},
                "requirements": [{
                    "required_element": {
                        "id": {previous_nodes.units[0].requirements[1].required_element.id}
                    },
                    "ratio": 20
                }]
        }
    }
    """
    Then the response status code should be 200
    Then the JSON nodes should be equal to:
      | units[0].requirements[1].ratio    | 20   |

Scenario: Successfully edit a Unit
  When I send a "POST" request with:
  """
  {
      "units": [
          {
              "id": {previous_nodes.units[0].id},
              "name": "A new Unit",
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
      | units[0].name                  | A new Unit   |
      | units[0].properties.picture    | blah2                 |
      | units[0].properties.quantity   | 2                     |
      | units[0].properties.type       | Unit         |

Scenario: Successfully remove a Unit
  When I send a "POST" request with:
  """
  {
      "removeUnit": "{previous_nodes.units[1].name}"
  }
  """
  Then the response status code should be 200
  And the JSON node "units" should have 1 element
