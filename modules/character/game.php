<?php

$game->registerMenu('Personnage');

if (!$player->get('level')) {
    $player->set('level', 1);
}

if (!$player->get('xp')) {
    $player->set('xp', 0);
}

$player->set('xp', 6000);

return [];
