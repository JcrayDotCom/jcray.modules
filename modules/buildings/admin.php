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
    $createdCosts = [];
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
* Edit requirements of an Building
*/

// Update requirements of a Building
if ($request->get('requirementsElementBuilding')) {
    $currentBuilding = (array) $request->get('requirementsElementBuilding');
    $elementBuilding = $game->getElement($currentBuilding['id']);
    $createdRequirements = [];
    foreach ($currentBuilding['requirements'] as $requirementInfo) {
        $requirementInfo = (array) $requirementInfo;
        $requirementInfo['required_element'] = (array) $requirementInfo['required_element'];
        $createdRequirements[] = $elementBuilding->createRequirement($requirementInfo['required_element']['id'], $costInfos['ratio']);
    }
    $arrayReturn['costsElementBuilding'] = $request->get('costsElementBuilding');
}

// Delete a requirement of an Building
if ($request->get('removeBuildingRequirement')) {
    $currentBuilding = (array) $request->get('removeBuildingRequirement');
    $this->removeRequirement($currentBuilding);
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
