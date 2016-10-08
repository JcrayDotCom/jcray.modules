<?php

$races = $game->getElementsByProperties(['type' => 'race']);

if ($request->get('chosenRace')) {
    $player->set('race', $request->get('chosenRace')['id']);
}

$playerRace = $player->get('race');
if ($playerRace) {
    $playerRace = $game->getElement($playerRace);
}

return [
    'races' => $races,
    'playerRace' => $playerRace,
    'introduction' => $module->get('introduction'),
];
