<?php

$arrayReturn = [];

/*
* Buy a Building
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

    $arrayReturn['playerbuildings'] = $playerElements;
}

$arrayReturn['playerbuildings'] = $buildings;

/*
*   List stats of buildings
*/

$arrayReturn['buildingsStats'] = $game->get('buildingsStats');

if (isset($error)) {
    $arrayReturn['error'] = $error;
}

return $arrayReturn;
