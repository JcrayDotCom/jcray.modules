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

    private $adminControleer;

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
     * @Given I use the :folderName module
     */
    public function iUseTheModule($folderName)
    {
        $file = __DIR__.'/../../../modules/'.$folderName.'/';
        $this->adminController = file_get_contents($file.'admin.php');
        $this->adminTemplate = file_get_contents($file.'admin.tpl');
        $this->gameController = file_get_contents($file.'game.php');
        $this->gameTemplate = file_get_contents($file.'game.tpl');
    }

    /**
     * @When I send a :arg1 request with:
     */
    public function iSendARequestWith($arg1, PyStringNode $string)
    {
        $url = '/modules/tech/render';
        $this->getRestContext()->iAddHeaderEqualTo('Authorization', 'Bearer '.$this->user_token);
        $dataObject = json_decode($string);

        if (null == $dataObject) {
            throw new \Exception('Request body can\'t be non-json value');
        }

        $dataObject->adminController = $this->adminController;
        $dataObject->adminTemplate = $this->adminTemplate;
        $dataObject->gameController = $this->gameController;
        $dataObject->gameTemplate = $this->gameTemplate;

        $string = new PyStringNode([json_encode($dataObject)], 0);

        return $this->getRestContext()->iSendARequestToWithBody($arg1, $url, $string);
    }
}
