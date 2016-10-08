<?php

namespace Context;

require_once __DIR__.'/../../../Console/Command/GenerateModulesLoaderCommand.php';

use Behat\Behat\Context\Context;
use Behat\Gherkin\Node\PyStringNode;
use Sanpi\Behatch\Context\BaseContext;
use Sanpi\Behatch\Context\RestContext;
use Behat\Behat\Hook\Scope\BeforeScenarioScope;
use Symfony\Component\Console\Application;
use JcrayDotCom\Console\Command\GenerateModulesLoaderCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\ArrayInput;
use Symfony\Component\Console\Output\BufferedOutput;
use Symfony\Component\Console\Output\OutputInterface;

class FeatureContext extends BaseContext implements Context
{
    /**
     * @var RestContext
     */
    private $restContext;

    /**
     *   @var string
     */
    private $adminController;

    /**
     *   @var string
     */
    private $adminTemplate;

    /**
     *   @var string
     */
    private $gameController;

    /**
     *   @var string
     */
    private $gameTemplate;

    /**
     * @var console
     */
    private $console;

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

    public static function getConsole()
    {
        $console = new Application('JcrayTech', '0.1');

        $generateModulesLoaderCommand = new GenerateModulesLoaderCommand();
        $console->add($generateModulesLoaderCommand);
        $console->setAutoExit(false);

        return $console;
    }

    /**
     * @param string $command
     * @param array  $args
     *
     * @return $this
     */
    public static function execCommand($commandName, $args = [])
    {
        $input = new ArrayInput(array_merge(
           ['command' => $commandName],
           $args
        ));

        $output = new BufferedOutput(
            OutputInterface::VERBOSITY_NORMAL,
            true
        );

        self::getConsole()->run($input, $output);

        $content = $output->fetch();
        fwrite(STDOUT, $content);
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

         return self::execCommand('modules:generate:js');
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
