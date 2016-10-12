<?php

$arrayReturn = [];

/*
* Add module units to the game menu
*/

$game->registerMenu('units');

/*
* Create a new Unit
*/

$newUnit = null;

$newUnit = $game->createElementIfInRequest('newUnit', [
    'type' => 'Unit',
]);

/*
* Edit stats of units
*/

// By default no stats
if (!$game->get('unitsStats')) {
    $game->set('unitsStats', []);
}

// Updating stats
if ($request->get('unitsStats')) {
    $game->set('unitsStats', $request->get('unitsStats'));
}

// Creating a new stat
if ($request->get('newStat')) {
    $gameStats = $game->get('unitsStats');
    $gameStats[] = $request->get('newStat');
    $game->set('unitsStats', $gameStats);
}

// Delete a stat
if ($request->get('removeUnitStat')) {
    $gameStats = $game->get('unitsStats');
    $newStats = [];
    foreach ($gameStats as $stat) {
        if ($stat->name != $request->get('removeUnitStat')['name']) {
            $newStats[] = $stat;
        }
    }

    $game->set('unitsStats', $newStats);
}

// Apply default stats to all elements
$gameStats = $arrayReturn['unitsStats'] = $game->get('unitsStats');

$elements = $game->getElementsByProperties(['type' => 'Unit']);
foreach ($gameStats as $stat) {
    foreach ($elements as $element) {
        if (!$element->get($stat->name)) {
            $element->set($stat->name, (int) $stat->quantity);
        }
        if ($request->get('removeUnitStat')) {
            $element->removeProperty($request->get('removeUnitStat')['name']);
        }
    }
}

/*
* Edit costs of an Unit
*/

// Update costs of a Unit
if ($request->get('costsElementUnit')) {
    $currentUnit = (array) $request->get('costsElementUnit');
    $elementUnit = $game->getElement($currentUnit['id']);
    foreach ($currentUnit['costs'] as $costInfos) {
        $costInfos = (array) $costInfos;
        $costInfos['cost'] = (array) $costInfos['cost'];
        $createdCosts[] = $elementUnit->createCost($costInfos['cost']['id'], $costInfos['quantity']);
    }
    $arrayReturn['costsElementUnit'] = $request->get('costsElementUnit');
}

$elements = $game->getElementsByProperties(['type' => 'Unit']);
$moneys = $game->getElementsByProperties(['type' => 'Resource']);

// Apply default costs to units
foreach ($elements as $element) {
    $costs = $element->getCosts();
    foreach ($moneys as $money) {
        if (!$element->getCost($money)) {
            $element->createCost($money, 0);
        }
    }
}

/*
* Edit an existant Unit
*/

$game->updateElementsIfInRequest('units');

/*
* Delete a Unit
*/

$game->deleteElementIfInRequest('removeUnit');

/*
* Retrieve all units
*/

$arrayReturn['units'] = $game->getElementsByProperties([
    'type' => 'Unit',
]);

return $arrayReturn;
