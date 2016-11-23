<?php

$arrayReturn = [];

/*
* Buy a Object
*/

if ($request->get('playerobjects')) {
    foreach ($request->get('playerobjects') as $playerElement) {
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
        if ($player->canHave($element->getId())) {
            $playerElements[] = $playerElement;
        }
    }

    $arrayReturn['playerobjects'] = $playerElements;
}

$arrayReturn['objects'] = $objects;

/*
*   List stats of objects
*/

$arrayReturn['objectsStats'] = $game->get('objectsStats');

if (isset($error)) {
    $arrayReturn['error'] = $error;
}

return $arrayReturn;
