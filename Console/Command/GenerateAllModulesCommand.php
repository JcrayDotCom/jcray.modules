<?php

namespace JcrayDotCom\Console\Command;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Input\ArrayInput;

class GenerateAllModulesCommand extends Command
{
    protected function configure()
    {
        $this
            ->setName('jcray:modules:regenerate')
            ->setDescription('ReGenerate all modules from recipes')
        ;
    }

    /**
     * {@inheritdoc}
     */
    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $modulesDir = realpath(__DIR__.'/../../modules');
        $opendir = opendir($modulesDir);
        while ($f = readdir($opendir)) {
            $moduleDir = $modulesDir.'/'.$f;
            if (is_dir($moduleDir) && $f != '.' && $f != '..') {
                $recipeFileInfo = $moduleDir.'/.recipe';
                if (!is_file($recipeFileInfo)) {
                    continue;
                }

                $command = $this->getApplication()->find('jcray:modules:generate');
                $commandArgs = new ArrayInput((array) json_decode(file_get_contents($recipeFileInfo)));
                $command->run($commandArgs, $output);
            }
        }
    }
}
