<?php

namespace JcrayDotCom\Console\Command;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

class GenerateModulesLoaderCommand extends Command
{
    private $helperSet;

    protected function configure()
    {
        $this
            ->setName('jcray:modules:autoload')
            ->setDescription('Regenerate the modules.auto.js file with updated controllers and templates files contents')
        ;
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $io = new SymfonyStyle($input, $output);
        $io->title('Generating modules.auto.js file');
        $modulesPath = __DIR__.'/../../modules';
        $webPath = __DIR__.'/../../web';
        $modules = [];
        $p = opendir($modulesPath);
        while ($f = readdir($p)) {
            if (is_dir($modulesPath.'/'.$f) && $f != '.' && $f != '..') {
                $io->text('Found module '.$f.' in '.realpath($modulesPath.'/'.$f));
                $modules[$f] = [
                    'admin_controller' => is_file($modulesPath.'/'.$f.'/admin.php') ? file_get_contents($modulesPath.'/'.$f.'/admin.php') : '<?php '."\n",
                    'admin_template' => is_file($modulesPath.'/'.$f.'/admin.tpl') ? file_get_contents($modulesPath.'/'.$f.'/admin.tpl') : '{% block %}'."\n\n".'{% endblock %}',
                    'game_controller' => is_file($modulesPath.'/'.$f.'/game.php') ? file_get_contents($modulesPath.'/'.$f.'/game.php') : '<?php '."\n",
                    'game_template' => is_file($modulesPath.'/'.$f.'/game.tpl') ? file_get_contents($modulesPath.'/'.$f.'/game.tpl') : '{% block %}'."\n\n".'{% endblock %}',
                ];
            }
        }
        file_put_contents($webPath.'/assets/modules.auto.js', 'var modules = '.json_encode($modules).';');
        $io->success('modules.auto.js written in '.realpath($webPath.'/assets').'');
    }
}
