<?php

$arrayReturn = [];

/*
* Add module buildings to the game menu
*/

$game->registerMenu('buildings');

/*
* Create a new Building
*/

$newBuilding = null;

$newBuilding = $game->createElementIfInRequest('newBuilding', [
    'type' => 'Building',
]);

/*
* Edit costs of an Building
*/

// Update costs of a Building
if ($request->get('costsElementBuilding')) {
    $currentBuilding = (array) $request->get('costsElementBuilding');
    $elementBuilding = $game->getElement($currentBuilding['id']);
    foreach ($currentBuilding['costs'] as $costInfos) {
        $costInfos = (array) $costInfos;
        $costInfos['cost'] = (array) $costInfos['cost'];
        $createdCosts[] = $elementBuilding->createCost($costInfos['cost']['id'], $costInfos['quantity']);
    }
    $arrayReturn['costsElementBuilding'] = $request->get('costsElementBuilding');
}

$elements = $game->getElementsByProperties(['type' => 'Building']);
$moneys = $game->getElementsByProperties(['type' => 'Resource']);

// Apply default costs to buildings
foreach ($elements as $element) {
    $costs = $element->getCosts();
    foreach ($moneys as $money) {
        if (!$element->getCost($money)) {
            $element->createCost($money, 0);
        }
    }
}

/*
* Edit an existant Building
*/

$game->updateElementsIfInRequest('buildings');

/*
* Delete a Building
*/

$game->deleteElementIfInRequest('removeBuilding');

/*
* Retrieve all buildings
*/

$arrayReturn['buildings'] = $game->getElementsByProperties([
    'type' => 'Building',
]);

return $arrayReturn;
