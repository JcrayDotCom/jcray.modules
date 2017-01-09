Scenario: Successfully create a %elementName% with requirable property
  When I send a "POST" request with:
  """
  {
      "new%elementName%": {
          "name": "Sample %elementName%",
          "properties": {
              "quantity": 1000,
              "picture": "blah"
          }
      }
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
      | %elementsName%[0].name                      | Sample %elementName%   |
      | %elementsName%[0].properties.picture        | blah                   |
      | %elementsName%[0].properties.quantity       | 1000                   |
      | %elementsName%[0].properties.type           | %elementName%          |
      | %elementsName%[0].properties.requirable     | 1                      |
