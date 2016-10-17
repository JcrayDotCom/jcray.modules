<?php

namespace JcrayDotCom\Console\Command;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;
use Symfony\Component\Yaml\Yaml;
use Symfony\Component\Console\Input\InputArgument;
use Doctrine\Common\Inflector\Inflector;
use Symfony\Component\Console\Input\ArrayInput;

class GenerateModuleCommand extends Command
{
    protected function configure()
    {
        $this
            ->setName('jcray:modules:generate')
            ->setDescription('Generate a new module with basic code')
            ->addArgument('recipe', InputArgument::OPTIONAL, 'Recipe of module to generate', 'default')
        ;
    }

    /**
     * {@inheritdoc}
     */
    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $recipe = $input->getArgument('recipe');
        $expectedFile = realpath(__DIR__.'/../../Generator/recipes').'/'.$recipe.'.yml';
        $io = new SymfonyStyle($input, $output);
        $io->title('Generating new module');
        if (!is_file($expectedFile)) {
            $io->error('Recipe '.$recipe.' not found at path '.$expectedFile);

            return;
        }

        $elementName = $io->ask('Please enter the singural name of elements used by this module', 'animal');
        $moduleName = Inflector::pluralize($elementName);
        $recipeData = Yaml::parse(file_get_contents($expectedFile));

        $files = [
            'translations.en.yml' => [file_get_contents(__DIR__.'/../../Generator/parts/base.translation.en')],
            'translations.fr.yml' => [file_get_contents(__DIR__.'/../../Generator/parts/base.translation.fr')],
        ];

        foreach ($recipeData['parts'] as $part) {
            $expectedFile = realpath(__DIR__.'/../../Generator/parts').'/'.str_replace(':', '.', $part);
            $expectedFileTests = realpath(__DIR__.'/../../Generator/parts').'/'.str_replace(':', '.', $part).'.feature';
            $expectedFileTranslationsEn = $expectedFile.'.translation.en';
            $expectedFileTranslationsFr = $expectedFile.'.translation.fr';

            if (!is_file($expectedFile)) {
                $io->error('Part '.$part.' not found at path '.$expectedFile);
                die();
            }

            if (is_file($expectedFileTranslationsEn)) {
                $files['translations.en.yml'][] = file_get_contents($expectedFileTranslationsEn);
            }
            if (is_file($expectedFileTranslationsFr)) {
                $files['translations.fr.yml'][] = file_get_contents($expectedFileTranslationsFr);
            }

            $partInfos = explode(':', $part);
            $targetFileTest = 'module.'.$partInfos[0].'.feature';

            $targetFile = $partInfos[0].($partInfos[2] == 'template' ? '.tpl' : '.php');
            if (!isset($files[$targetFile])) {
                $files[$targetFile] = [];
            }

            if (is_file($expectedFileTests)) {
                if (!isset($files[$targetFileTest])) {
                    $files[$targetFileTest] = [
                        file_get_contents(__DIR__.'/../../Generator/parts/intro_'.$partInfos[0].'.feature'),
                    ];
                }
                $files[$targetFileTest][] = file_get_contents($expectedFileTests);
            }
        }

        $moduleFolder = realpath(__DIR__.'/../../modules').'/'.Inflector::camelize($moduleName);
        if (is_dir($moduleFolder)) {
            if (!$io->confirm('Destination folder already exists. Overwrite?', false)) {
                $io->error('Aborted.');
                die();
            }
        } else {
            mkdir($moduleFolder);
        }

        foreach ($files as $filename => &$file) {
            $fileContent = implode("\n", $file);

            $fileContent = str_replace([
                '%elementName%',
                '%elementsName%',
            ], [
                ucfirst(Inflector::camelize($elementName)),
                Inflector::camelize($moduleName),
            ], $fileContent);

            if (strpos($filename, '.php')) {
                $fileContent = '<?php '."\n".$fileContent;
            }
            $file = $fileContent;
            preg_match_all('|\%hook\:(.+)\:(.+)\%|', $fileContent, $matches);
            foreach ($matches[0] as $hook) {
                if (isset($recipeData['ignore']) && in_array(str_replace('%', '', $hook), $recipeData['ignore'])) {
                    $io->note('Hook '.str_replace('%', '', $hook).' is in ignore list. Skipped.');
                    $fileContent = str_replace($hook, '',  $fileContent);
                    continue;
                }
                $hookFile = realpath(__DIR__.'/../../Generator/parts').'/'.str_replace(['%', ':'], ['', '.'], $hook);
                if (!is_file($hookFile)) {
                    $io->error('Hook file '.$hookFile.' does not exist.');
                    die();
                }
                $fileContent = str_replace($hook, str_replace([
                    '%elementName%',
                    '%elementsName%',
                ], [
                    ucfirst(Inflector::camelize($elementName)),
                    Inflector::camelize($moduleName),
                ], file_get_contents($hookFile)), $fileContent);
            }

            file_put_contents($moduleFolder.'/'.$filename, $fileContent);
            $io->text('Generated '.$moduleFolder.'/'.$filename);
        }

        shell_exec(__DIR__.'/../../bin/php-cs-fixer fix '.$moduleFolder);
        $io->success('Module created in '.$moduleFolder);

        $command = $this->getApplication()->find('jcray:modules:autoload');
        $input = new ArrayInput([]);
        $returnCode = $command->run($input, $output);
    }
}
