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

Scenario: Successfully remove a stat
  When I send a "POST" request with:
  """
  {
      "remove%elementName%Stat": {
          "name": "Another sample stat"
      }
  }
  """
  Then the response status code should be 200
  And the JSON node "%elementsName%Stats" should have 1 element


Scenario: Successfully edit a stat
  When I send a "POST" request with:
  """
  {
      "%elementsName%Stats": [
          {
              "name": "A stat",
              "quantity": 11
          }
      ]
  }
  """
  Then the response status code should be 200
  Then the JSON nodes should be equal to:
    | %elementsName%Stats[0].name                | A stat   |
    | %elementsName%Stats[0].quantity            | 11       |
