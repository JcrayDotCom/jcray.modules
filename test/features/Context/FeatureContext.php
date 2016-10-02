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

    private function createGame()
    {
        if ($this->gameSlug) {
            return;
        }

        $url = '/me/games';
        $this->gameSlug = md5($this->user_id);

        $gameInfo = json_encode([
            'name' => $this->user_id,
            'slug' => $this->gameSlug,
        ]);
        $gameInfo = new PyStringNode([$gameInfo], 0);

        $this->getRestContext()->iAddHeaderEqualTo('Authorization', 'Bearer '.$this->user_token);
    }

    /**
     * @return RestContext
     */
    private function getRestContext()
    {
        return $this->restContext;
    }

    public function __construct($user_token, $user_id)
    {
        $this->user_token = $user_token;
        $this->user_id = $user_id;
    }

    /**
     * @When I send a :arg1 request with:
     */
    public function iSendARequestWith($arg1, PyStringNode $string)
    {
        $this->createGame();
        $url = '/modules/tech/render?game='.$this->gameSlug;
        $this->getRestContext()->iAddHeaderEqualTo('Authorization', 'Bearer '.$this->user_token);

        return $this->getRestContext()->iSendARequestToWithBody($arg1, $url, $string);
    }
}
