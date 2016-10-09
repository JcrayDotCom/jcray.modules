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
      | %elementsName%Stats[0].name                | Sample stat   |
      | %elementsName%Stats[0].quantity            | 10            |


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
      | %elementsName%Stats[0].name                | Sample stat            |
      | %elementsName%Stats[0].quantity            | 10                     |
      | %elementsName%Stats[1].name                | Another sample stat    |
      | %elementsName%Stats[1].quantity            | 5                      |
