<?php

namespace Context;

use Behat\Behat\Context\Context;
use Behat\Gherkin\Node\PyStringNode;
use Sanpi\Behatch\Context\BaseContext;
use Sanpi\Behatch\Context\RestContext;
use Behat\Behat\Hook\Scope\BeforeScenarioScope;

class FeatureContext extends BaseContext implements Context
{
    private $restContext;

    private $gameSlug;

    /**
     * @BeforeScenario
     *
     * @return RestContext
     */
    public function gatherContexts(BeforeScenarioScope $scope)
    {
        $environment = $scope->getEnvironment();
        $this->restContext = $environment->getContext('Context\CustomRestContext');
    }

    /**
     * @return RestContext
     */
    private function getRestContext()
    {
        return $this->restContext;
    }

    public function __construct($developement_token)
    {
        $this->user_token = $developement_token;
    }

    /**
     * @When I send a :arg1 request with:
     */
    public function iSendARequestWith($arg1, PyStringNode $string)
    {
        $url = '/modules/tech/render';
        $this->getRestContext()->iAddHeaderEqualTo('Authorization', 'Bearer '.$this->user_token);

        return $this->getRestContext()->iSendARequestToWithBody($arg1, $url, $string);
    }
}
