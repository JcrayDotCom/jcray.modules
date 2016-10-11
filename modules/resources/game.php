<?php

$arrayReturn = [];

/*
* Get the resources owned by the player
*/

$resources = $game->getElementsByProperties([
    'type' => 'Resource',
]);

$playerresources = [];

if ($player) {
    foreach ($resources as $element) {
        $playerElement = $player->getElement($element->getId());
        if (!$playerElement) {
            $playerElement = $player->createElement($element->getId());
        }
        $playerElements[] = $playerElement;
    }

    $arrayReturn['playerElements'] = $playerElements;
}

$arrayReturn['resources'] = $resources;

if (isset($error)) {
    $arrayReturn['error'] = $error;
}

return $arrayReturn;
