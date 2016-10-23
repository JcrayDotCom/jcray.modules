<?php

$arrayReturn = [];

/*
* Buy a Object
*/

if ($request->get('playerElements')) {
    foreach ($request->get('playerElements') as $playerElement) {
        if (isset($playerElement['data']) && (int) $playerElement['data'] > 0) {
            $playerElementEntity = $player->getElement($playerElement['element']['id']);
            try {
                $playerElementEntity->set('quantity', (int) $playerElementEntity->get('quantity') + (int) $playerElement['data']);
            } catch (Exception $e) {
                $error = $e->getMessage();
            }
        }
    }
}

/*
* Get the objects owned by the player
*/

$objects = $game->getElementsByProperties([
    'type' => 'Object',
]);

$playerElements = [];

if ($player) {
    foreach ($objects as $element) {
        $playerElement = $player->getElement($element->getId());
        if (!$playerElement) {
            $playerElement = $player->createElement($element->getId());
        }
        $playerElements[] = $playerElement;
    }

    $arrayReturn['playerobjects'] = $playerElements;
}

$arrayReturn['playerobjects'] = $objects;

/*
*   List stats of objects
*/

$arrayReturn['objectsStats'] = $game->get('objectsStats');

if (isset($error)) {
    $arrayReturn['error'] = $error;
}

return $arrayReturn;
