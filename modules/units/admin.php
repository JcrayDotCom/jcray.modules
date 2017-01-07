<?php

$arrayReturn = [];
$defaultProperties = [];

$defaultProperties['requirable'] = 1;

/*
* Add module units to the game menu
*/

$game->registerMenu('units');

/*
* Create a new Unit
*/

$newUnit = null;

$newUnit = $game->createElementIfInRequest('newUnit', array_merge($defaultProperties, [
    'type' => 'Unit',
]));

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
    $createdCosts = [];
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
* Edit requirements of an Unit
*/

// List all requirable elements of the game
$arrayReturn['requirableElements'] = $game->getElementsByProperties(['requirable' => 1]);
$arrayReturn['haveRequirableElements'] = (bool) count($arrayReturn['requirableElements']);

$createdRequirements = [];

$units = $game->getElementsByProperties([
    'type' => 'Unit',
]);
$settedElements = [];

// Set default requirement (0)
foreach ($units as $element) {
    foreach ($element->getRequirements() as $requirement) {
        $settedElements[] = $requirement->getRequiredElement()->getId();
    }

    foreach ($arrayReturn['requirableElements'] as $requirableElement) {
        if (!in_array($requirableElement->getId(), $settedElements)) {
            $createdRequirements[] = $element->createRequirement($requirableElement->getId(), 0);
        }
    }
}

// Update requirements of a Unit
if ($request->get('requirementsElementUnit')) {
    $currentUnit = (array) $request->get('requirementsElementUnit');
    $elementUnit = $game->getElement($currentUnit['id']);
    foreach ($currentUnit['requirements'] as $requirementInfo) {
        $requirementInfo = (array) $requirementInfo;
        if (!isset($requirementInfo['required_element'])) {
            continue;
        }
        $requirementInfo['required_element'] = (array) $requirementInfo['required_element'];
        $createdRequirements[] = $elementUnit->createRequirement($requirementInfo['required_element']['id'], $requirementInfo['ratio']);
    }
    $arrayReturn['requirementsElementUnit'] = $createdRequirements;
}

// Delete a requirement of an Unit
if ($request->get('removeUnitRequirement')) {
    $currentUnit = (array) $request->get('removeUnitRequirement');
    $elementUnit = $game->getElement($currentUnit['id']);
    $elementUnit->removeRequirement($currentUnit);
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
