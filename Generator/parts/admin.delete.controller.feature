Scenario: Successfully remove a %elementName%
  When I send a "POST" request with:
  """
  {
      "remove%elementName%": "{previous_nodes.%elementsName%[1].name}"
  }
  """
  Then the response status code should be 200
  And the JSON node "%elementsName%" should have 1 element
