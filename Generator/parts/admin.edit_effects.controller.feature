Scenario: Successfully retrieve %elementsName%
  When I send a "POST" request with:
  """
  {

  }
  """
  Then the response status code should be 200

Scenario: Successfully create an effect on an %elementName%
  When I send a "POST" request with:
  """
  {
      "effectsElement%elementName%": {
          "id": {previous_nodes.%elementsName%[0].id}
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
      | %elementsName%[0].effects[0].property_name  | testProperty   |
      | %elementsName%[0].effects[0].quantity       | 3            |


Scenario: Successfully create an other effect on an %elementName%
  When I send a "POST" request with:
  """
    {
        "effectsElement%elementName%": {
            "id": {previous_nodes.%elementsName%[0].id}
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
      | %elementsName%[0].effects[0].property_name  | testProperty   |
      | %elementsName%[0].effects[0].quantity       | 3            |
      | %elementsName%[0].effects[1].property_name  | testProperty2   |
      | %elementsName%[0].effects[1].quantity       | 3               |
  And the JSON node "%elementsName%[0].effects" should have 2 elements


Scenario: Successfully remove an effect on an %elementName%
  When I send a "POST" request with:
  """
    {
        "effectsElement%elementName%": {
            "id": {previous_nodes.%elementsName%[0].id}
        },
        "removeEffect%elementName%": {
            "id": {previous_nodes.created_effects[0].id}
        }
    }
  """
  Then the response status code should be 200
  And the JSON node "%elementsName%[0].effects" should have 1 element
