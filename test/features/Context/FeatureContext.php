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

    private $adminController;
    private $adminTemplate;
    private $gameController;
    private $gameTemplate;
    private $launched = [];

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
        $lockFile = 'module.lock';

        if (!is_file($lockFile) || file_get_contents($lockFile) != $folderName) {
            file_put_contents($lockFile, $folderName);
            $resetTemplate = new \stdClass();
            $resetTemplate->admin_controller =
            $resetTemplate->admin_template =
            $resetTemplate->game_controller =
            $resetTemplate->game_template = '__reset__';

            $dataObject = new \stdClass();
            $dataObject->module_configuration = $resetTemplate;
            $string = new PyStringNode(explode("\n", json_encode($dataObject, true)), 0);

            $this->getRestContext()->iAddHeaderEqualTo('Authorization', 'Bearer '.$this->user_token);
            $this->getRestContext()->iAddHeaderEqualTo('Content-type', 'application/json');
            $url = '/modules/tech/render?'.time();

            $request = $this->getRestContext()->iSendARequestToWithBody('POST', $url, $string);
        }

        $file = __DIR__.'/../../../modules/'.$folderName.'/';
        $this->adminController = file_get_contents($file.'admin.php');
        $this->adminTemplate = file_get_contents($file.'admin.tpl');
        $this->gameController = file_get_contents($file.'game.php');
        $this->gameTemplate = file_get_contents($file.'game.tpl');
    }

     /**
      * @BeforeSuite
      */
     public static function prepareModule($event)
     {
         if (is_file('module.lock')) {
             unlink('module.lock');
         }
         if (is_file('last_nodes')) {
             unlink('last_nodes');
         }
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
        file_put_contents('last_nodes', $this->getRestContext()->getMinkContext()->getMink()->getSession()->getPage()->getContent());

        return $request;
    }

    private function parseRequestBody($requestBody)
    {
        if (!is_file('last_nodes')) {
            return $requestBody;
        }

        $this->previous_nodes = json_decode(file_get_contents('last_nodes'));
        preg_match_all('%\{previous_nodes\.(.+)\[(.+)\]\.(.+)\}%', $requestBody, $matches);
        for ($i = 0; $i < count($matches[0]); ++$i) {
            foreach ($this->previous_nodes as $k => $v) {
                if ($k == $matches[1][$i]) {
                    $property = $matches[3][$i];
                    $requestBody = str_replace($matches[0][$i], $v[(int) $matches[2][$i]]->$property, $requestBody);
                }
            }
        }

        return $requestBody;
    }
}
