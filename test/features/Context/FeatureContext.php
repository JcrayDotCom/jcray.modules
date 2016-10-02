<?php

namespace Context;

use Behat\Behat\Context\Context;
use Behat\Gherkin\Node\PyStringNode;
use Sanpi\Behatch\Context\BaseContext;

class FeatureContext extends BaseContext implements Context
{
    private function getRestContext()
    {
        return $this->getMinkContext();
    }

    public function __construct($user_token, $game_url)
    {
        $this->user_token = $user_token;
        $this->game_url = $game_url;
    }

    /**
     * @When I send a :arg1 request with:
     */
    public function iSendARequestWith($arg1, PyStringNode $string)
    {
        $url = '/tech/modules/render?game='.$this->game_url;
        $this->getRestContext()->iAddHeaderEqualTo('Authorization', 'Bearer '.$this->user_token);

        return $this->getRestContext()->iSendARequestToWithBody($arg1, $url, $string);
    }
}
