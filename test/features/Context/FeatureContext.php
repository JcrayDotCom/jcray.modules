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

    private static function getToken($force = false)
    {
        if (!$force && is_file('token.lock')) {
            return file_get_contents('token.lock');
        }

        $url = 'http://jcray.tech/tech/token?'.time();

        $result = file_get_contents($url);

        $token = json_decode($result)->token;
        file_put_contents('token.lock', $token);

        return $token;
    }

     /**
      * @AfterSuite
      */
     public static function prepareModule($event)
     {
         unlink('token.lock');
         unlink('last_nodes');

         $modules = [];
         $p = opendir('modules');
         while ($f = readdir($p)) {
             if (is_dir('modules/'.$f) && $f != '.' && $f != '..') {
                 $modules[$f] = [
                     'admin_controller' => file_get_contents('modules/'.$f.'/admin.php'),
                     'admin_template' => file_get_contents('modules/'.$f.'/admin.tpl'),
                     'game_controller' => file_get_contents('modules/'.$f.'/game.php'),
                     'game_template' => file_get_contents('modules/'.$f.'/game.tpl'),
                 ];
             }
         }

         file_put_contents('web/assets/modules.auto.js', 'var modules = '.json_encode($modules).';');
     }

     /**
      * @BeforeSuite
      */
     public static function cleanTests($event)
     {
         $url = 'http://api.jcray.tech/v8/games/tech/reset?'.time();

         $opts = array(
          'http' => array(
            'method' => 'GET',
            'header' => 'Authorization: Bearer '.self::getToken(true)."\r\n",
          ),
        );

         $context = stream_context_create($opts);
         file_get_contents($url, false, $context);
     }

    /**
     * @When I send a :arg1 request with:
     */
    public function iSendARequestWith($arg1, PyStringNode $string)
    {
        $url = '/modules/tech/render?'.time();
        $this->getRestContext()->iAddHeaderEqualTo('Authorization', 'Bearer '.$this->getToken());
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
