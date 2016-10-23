<?php

$arrayReturn = [];

/*
* Buy a Unit
*/

if ($request->get('playerunits')) {
    foreach ($request->get('playerunits') as $playerElement) {
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
* Get the units owned by the player
*/

$units = $game->getElementsByProperties([
    'type' => 'Unit',
]);

$playerElements = [];

if ($player) {
    foreach ($units as $element) {
        $playerElement = $player->getElement($element->getId());
        if (!$playerElement) {
            $playerElement = $player->createElement($element->getId());
        }
        $playerElements[] = $playerElement;
    }

    $arrayReturn['playerunits'] = $playerElements;
}

$arrayReturn['units'] = $units;

/*
*   List stats of units
*/

$arrayReturn['unitsStats'] = $game->get('unitsStats');

if (isset($error)) {
    $arrayReturn['error'] = $error;
}

return $arrayReturn;
