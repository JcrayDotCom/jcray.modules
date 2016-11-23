@module
@
Feature:
  In a game, you have .

  Background:
    Given I use the "" module

Scenario: Successfully create a 
  When I send a "POST" request with:
  """
  {
      "new": {
          "name": "Sample ",
          "properties": {
              "quantity": 1000,
              "picture": "blah"
          }
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | [0].name                | Sample    |
      | [0].properties.picture  | blah  |
      | [0].properties.quantity | 1000   |
      | [0].properties.type     |       |

Scenario: Successfully create another 
  When I send a "POST" request with:
  """
  {
      "new": {
          "name": "An other ",
          "properties": {
              "quantity": 10,
              "picture": "foo"
          }
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | [0].name                | Sample    |
      | [0].properties.picture  | blah  |
      | [0].properties.quantity | 1000   |
      | [0].properties.type     |       |
      | [1].name                | An other    |
      | [1].properties.picture | foo       |
      | [1].properties.quantity | 10        |
      | [1].properties.type  |       |

Scenario: Successfully create a  requirement
    When I send a "POST" request with:
    """
    {
        "requirementsElement": {
                "id": {previous_nodes.[0].id},
                "requirements": [{
                    "required_element": "{previous_nodes.[1].id}",
                    "ratio": 10
                }]
        }
    }
    """
    Then the response status code should be 200
    Then the JSON nodes should be equal to:
        | [0].requirements[0]['ratio']    | 10   |

Scenario: Successfully edit a  requirement
      """
      {
          "requirementsElement": {
                  "id": {previous_nodes.[0].id},
                  "requirements": [{
                      "required_element": "{previous_nodes.[1].id}",
                      "ratio": 20
                  }]
          }
      }
      """
      Then the response status code should be 200
      Then the JSON nodes should be equal to:
          | [0].requirements[0]['ratio']    | 20   |

Scenario: Successfully edit a 
  When I send a "POST" request with:
  """
  {
      "": [
          {
              "id": {previous_nodes.[0].id},
              "name": "A new ",
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
      | [0].name                  | A new    |
      | [0].properties.picture    | blah2                 |
      | [0].properties.quantity   | 2                     |
      | [0].properties.type       |          |

Scenario: Successfully remove a 
  When I send a "POST" request with:
  """
  {
      "remove": "{previous_nodes.[1].name}"
  }
  """
  Then the response status code should be 200
  And the JSON node "" should have 1 element
