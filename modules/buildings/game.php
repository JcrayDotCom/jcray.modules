<?php

$arrayReturn = [];

/*
* Get the buildings owned by the player
*/

$buildings = $game->getElementsByProperties([
    'type' => 'Building',
]);

$playerElements = [];

if ($player) {
    foreach ($buildings as $element) {
        $playerElement = $player->getElement($element->getId());
        if (!$playerElement) {
            $playerElement = $player->createElement($element->getId());
        }
        $playerElements[] = $playerElement;
    }

    $arrayReturn['playerElements'] = $playerElements;
}

$arrayReturn['buildings'] = $buildings;

if (isset($error)) {
    $arrayReturn['error'] = $error;
}

return $arrayReturn;
