<?php

$arrayReturn = [];

/*
* Get the resources owned by the player
*/

$resources = $game->getElementsByProperties([
    'type' => 'Resource',
]);

$playerElements = [];

if ($player) {
    foreach ($resources as $element) {
        $playerElement = $player->getElement($element->getId());
        if (!$playerElement) {
            $playerElement = $player->createElement($element->getId());
        }
        if ($player->canHave($element->getId())) {
            $playerElements[] = $playerElement;
        }
    }

    $arrayReturn['playerresources'] = $playerElements;
}

$arrayReturn['resources'] = $resources;

if (isset($error)) {
    $arrayReturn['error'] = $error;
}

return $arrayReturn;
