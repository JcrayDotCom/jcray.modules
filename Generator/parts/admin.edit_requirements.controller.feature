Scenario: Successfully create a %elementName% requirement
    When I send a "POST" request with:
    """
    {
        "requirementsElement%elementName%": {
                "id": {previous_nodes.%elementsName%[0].id},
                "requirements": [{
                    "required_element": "{previous_nodes.%elementsName%[1].id}",
                    "ratio": 10
                }]
        }
    }
    """
    Then the response status code should be 200
    Then the JSON nodes should be equal to:
        | %elementsName%[0].requirements[0]['ratio']    | 10   |

Scenario: Successfully edit a %elementName% requirement
      """
      {
          "requirementsElement%elementName%": {
                  "id": {previous_nodes.%elementsName%[0].id},
                  "requirements": [{
                      "required_element": "{previous_nodes.%elementsName%[1].id}",
                      "ratio": 20
                  }]
          }
      }
      """
      Then the response status code should be 200
      Then the JSON nodes should be equal to:
          | %elementsName%[0].requirements[0]['ratio']    | 20   |
