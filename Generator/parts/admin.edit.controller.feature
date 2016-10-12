Scenario: Successfully edit a %elementName%
  When I send a "POST" request with:
  """
  {
      "%elementsName%": [
          {
              "id": {previous_nodes.%elementsName%[0].id},
              "name": "A new %elementName%",
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
      | %elementsName%[0].name                  | A new %elementName%   |
      | %elementsName%[0].properties.picture    | blah2                 |
      | %elementsName%[0].properties.quantity   | 2                     |
      | %elementsName%[0].properties.type       | %elementName%         |
