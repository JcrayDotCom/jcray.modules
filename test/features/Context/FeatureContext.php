<?php

namespace Context;

require_once __DIR__.'/../../../Console/Command/GenerateModulesLoaderCommand.php';
require_once __DIR__.'/../../../Console/Command/CreateTechUserCommand.php';

use Behat\Behat\Context\Context;
use Behat\Gherkin\Node\PyStringNode;
use Sanpi\Behatch\Context\BaseContext;
use Sanpi\Behatch\Context\RestContext;
use Behat\Behat\Hook\Scope\BeforeScenarioScope;
use Symfony\Component\Console\Application;
use JcrayDotCom\Console\Command\GenerateModulesLoaderCommand;
use JcrayDotCom\Console\Command\CreateTechUserCommand;
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
        $createTechUserCommand = new CreateTechUserCommand();

        $console->add($generateModulesLoaderCommand);
        $console->add($createTechUserCommand);
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
        $this->adminController = is_file($file.'admin.php') ? file_get_contents($file.'admin.php') : '';
        $this->adminTemplate = is_file($file.'admin.tpl') ? file_get_contents($file.'admin.tpl') : '';
        $this->gameController = is_file($file.'game.php') ? file_get_contents($file.'game.php') : '';
        $this->gameTemplate = is_file($file.'game.tpl') ? file_get_contents($file.'game.tpl') : '';
    }

    private static function getToken($force = false)
    {
        $targetPrivateFile = __DIR__.'/../../../token.auto.json';
        if (!is_file($targetPrivateFile)) {
            self::execCommand('jcray:tech:env');
        }

        $data = json_decode(file_get_contents($targetPrivateFile));

        return $data->token;
    }

    public static function http_request($url, $opts = [])
    {
        $opts = array_merge([
            'ssl' => [
                'verify_peer' => false,
                'verify_peer_name' => false,
            ],
        ], $opts);

        return file_get_contents($url, false, stream_context_create($opts));
    }
     /**
      * @AfterSuite
      */
     public static function prepareModule($event)
     {
         if (is_file('last_nodes')) {
             unlink('last_nodes');
         }

         return self::execCommand('jcray:modules:autoload');
     }

     /**
      * @BeforeSuite
      */
     public static function cleanTests($event)
     {
         $url = 'https://api.jcray.tech/v8/games/tech/reset?'.time();

         $opts = array(
          'http' => array(
            'method' => 'GET',
            'header' => 'Authorization: Bearer '.self::getToken(true)."\r\n",
          ),
        );

         self::http_request($url, $opts);
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
