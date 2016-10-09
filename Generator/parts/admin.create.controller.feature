Scenario: Successfully create a %elementName%
  When I send a "POST" request with:
  """
  {
      "new%elementName%": {
          "name": "Sample %elementName%",
          "quantity": 1000,
          "picture": "blah"
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | %elementsName%[0].name                | Sample %elementName%   |
      | %elementsName%[0].properties[0].name  | quantity  |
      | %elementsName%[0].properties[0].value | 1000      |
      | %elementsName%[0].properties[1].name  | picture   |
      | %elementsName%[0].properties[1].value | blah      |
      | %elementsName%[0].properties[2].name  | type      |
      | %elementsName%[0].properties[2].value | %elementName%     |

Scenario: Successfully create another %elementName%
  When I send a "POST" request with:
  """
  {
      "new%elementName%": {
          "name": "An other %elementName%",
          "quantity": 10,
          "picture": "foo"
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | %elementsName%[0].name                | Sample %elementName%   |
      | %elementsName%[0].properties[0].name  | quantity  |
      | %elementsName%[0].properties[0].value | 1000      |
      | %elementsName%[0].properties[1].name  | picture   |
      | %elementsName%[0].properties[1].value | blah      |
      | %elementsName%[0].properties[2].name  | type      |
      | %elementsName%[0].properties[2].value | %elementName%     |
      | %elementsName%[1].name                | An other %elementName%   |
      | %elementsName%[1].properties[0].name  | quantity  |
      | %elementsName%[1].properties[0].value | 10        |
      | %elementsName%[1].properties[1].name  | picture   |
      | %elementsName%[1].properties[1].value | foo       |
      | %elementsName%[1].properties[2].name  | type      |
      | %elementsName%[1].properties[2].value | %elementName%     |
