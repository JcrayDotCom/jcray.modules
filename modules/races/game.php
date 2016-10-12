<?php

$races = $game->getElementsByProperties(['type' => 'Race']);

if ($request->get('chosenRace')) {
    $player->set('Race', $request->get('chosenRace')['id']);
}

$playerRace = $player->get('Race');
if ($playerRace) {
    $playerRace = $game->getElement($playerRace);
}

return [
    'races' => $races,
    'playerRace' => $playerRace,
    'introduction' => $module->get('introduction'),
];
