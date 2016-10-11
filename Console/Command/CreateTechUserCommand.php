<?php

namespace JcrayDotCom\Console\Command;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

class CreateTechUserCommand extends Command
{
    protected function configure()
    {
        $this
            ->setName('jcray:tech:env')
            ->setDescription('Generate fake user and fake game to tests')
        ;
    }

    /**
     * {@inheritdoc}
     */
    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $io = new SymfonyStyle($input, $output);
        $io->text('Ask for a new token...');
        $result = file_get_contents('http://jcray.tech/tech/token?'.time());
        $techEnv = json_decode($result);
        if (null === $techEnv) {
            $io->error('Unable to grant access.');
            throw new \Exception('Error retrieving token.');
        }

        $targetPublicFile = __DIR__.'/../../web/assets/token.auto.js';
        file_put_contents($targetPublicFile, 'var techEnv='.$result.';');

        $targetPrivateFile = __DIR__.'/../../token.auto.json';
        file_put_contents($targetPrivateFile, $result);

        $io->success('Granted!');
    }
}
