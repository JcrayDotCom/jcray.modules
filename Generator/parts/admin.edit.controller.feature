Scenario: Successfully edit a %elementName%
  When I send a "POST" request with:
  """
  {
      "%elementsName%": [
          {
              "id": {previous_nodes.%elementsName%[0].id},
              "name": "A new %elementName%",
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
      | %elementsName%[0].name                | A new %elementName%   |
      | %elementsName%[0].properties[0].name  | quantity    |
      | %elementsName%[0].properties[0].value | 2           |
      | %elementsName%[0].properties[1].name  | picture     |
      | %elementsName%[0].properties[1].value | blah2       |
      | %elementsName%[0].properties[2].name  | type        |
      | %elementsName%[0].properties[2].value | %elementName%     |
