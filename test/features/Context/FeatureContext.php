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

    private $previous_nodes;

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
        $url = '/modules/tech/render?'.time();
        $this->getRestContext()->iAddHeaderEqualTo('Authorization', 'Bearer '.$this->user_token);
        $this->getRestContext()->iAddHeaderEqualTo('Content-type', 'application/json');

        $string = $this->parseRequestBody($string);
        $dataObject = json_decode($string);

        if (null == $dataObject) {
            throw new \Exception('Request body have to be a json');
        }

        $module_configuration = new \stdClass();
        $module_configuration->admin_controller = $this->adminController;
        $module_configuration->admin_template = $this->adminTemplate;
        $module_configuration->game_controller = $this->gameController;
        $module_configuration->game_template = $this->gameTemplate;
        $dataObject->module_configuration = $module_configuration;

        $string = new PyStringNode(explode("\n", json_encode($dataObject, true)), 0);

        $request = $this->getRestContext()->iSendARequestToWithBody($arg1, $url, $string);
        $this->previous_nodes = json_decode($this->getRestContext()->getMinkContext()->getMink()->getSession()->getPage()->getContent());

        return $request;
    }

    private function parseRequestBody($requestBody)
    {
        if (!$this->previous_nodes) {
            return $requestBody;
        }

        preg_match_all('%\{previous_nodes\.(.+)\.(.+)\}%', $requestBody, $matches);
        var_dump($matches);
        unset($matches[0]);
        foreach ($matches as $match) {
            foreach ($this->previous_nodes as $k => $v) {
                if ($k == $match[1]) {
                    //$match = str_replace('{previous_nodes.'.$match[1].'.'.$match2[1].'}');
                }
            }
        }
    }
}
