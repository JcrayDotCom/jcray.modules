<?php

use Behat\Behat\Context\Context;
use Sanpi\Behatch\Context\RestContext;
use Behat\Gherkin\Node\PyStringNode;

class FeatureContext extends RestContext implements Context
{
    /**
     * @When I send a :arg1 request with:
     */
    public function iSendARequestWith($arg1, PyStringNode $string)
    {
        $url = '/modules/{current_module}/render?game={last_created_game}';

        return $this->iSendARequestToWithBody($arg1, $url, $string);
    }
}
