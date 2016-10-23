<?php

/*
* Filter on Race :
* If Player chose a Race
*/

if ($request->get('chosenRace')) {
    $player->set('Race', $request->get('chosenRace')['id']);
}

$playerRace = $player->get('Race');
if ($playerRace) {
    $playerRace = $game->getElement($playerRace);
}

$arrayReturn['playerRace'] = $playerRace;

$arrayReturn = [];

/*
* Get the races owned by the player
*/

$races = $game->getElementsByProperties([
    'type' => 'Race',
]);

$playerElements = [];

if ($player) {
    foreach ($races as $element) {
        $playerElement = $player->getElement($element->getId());
        if (!$playerElement) {
            $playerElement = $player->createElement($element->getId());
        }
        $playerElements[] = $playerElement;
    }

    $arrayReturn['playerraces'] = $playerElements;
}

$arrayReturn['races'] = $races;

if (isset($error)) {
    $arrayReturn['error'] = $error;
}

return $arrayReturn;
