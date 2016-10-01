<?php

$game->registerMenu('Personnage');
$game->registerTrigger('xp', function () {
    if ($player->get('xp') >= $player->get('level') * 1500) {
        $player->set('xp', 0);
        $player->set('level', $player->get('level') + 1);
    }
});

return [];
