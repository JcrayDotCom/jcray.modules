<?php

$arrayReturn = [];
$defaultProperties = [];

$defaultProperties['requirable'] = 1;

/*
* Add module buildings to the game menu
*/

$game->registerMenu('buildings');

/*
* Create a new Building
*/

$newBuilding = null;

$newBuilding = $game->createElementIfInRequest('newBuilding', array_merge($defaultProperties, [
    'type' => 'Building',
]));

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

// List all requirable elements of the game
$arrayReturn['requirableElements'] = $game->getElementsByProperties(['requirable' => 1]);
$arrayReturn['haveRequirableElements'] = (bool) count($arrayReturn['requirableElements']);

$createdRequirements = [];

$buildings = $game->getElementsByProperties([
    'type' => 'Building',
]);
$settedElements = [];

// Set default requirement (0)
foreach ($buildings as $element) {
    foreach ($element->getRequirements() as $requirement) {
        $settedElements[] = $requirement->getRequiredElement()->getId();
    }

    foreach ($arrayReturn['requirableElements'] as $requirableElement) {
        if (!in_array($requirableElement->getId(), $settedElements)) {
            $createdRequirements[] = $element->createRequirement($requirableElement->getId(), 0);
        }
    }
}

// Update requirements of a Building
if ($request->get('requirementsElementBuilding')) {
    $currentBuilding = (array) $request->get('requirementsElementBuilding');
    $elementBuilding = $game->getElement($currentBuilding['id']);
    foreach ($currentBuilding['requirements'] as $requirementInfo) {
        $requirementInfo = (array) $requirementInfo;
        if (!isset($requirementInfo['required_element'])) {
            continue;
        }
        $requirementInfo['required_element'] = (array) $requirementInfo['required_element'];
        $createdRequirements[] = $elementBuilding->createRequirement($requirementInfo['required_element']['id'], $requirementInfo['ratio']);
    }
    $arrayReturn['requirementsElementBuilding'] = $createdRequirements;
}

// Delete a requirement of an Building
if ($request->get('removeBuildingRequirement')) {
    $currentBuilding = (array) $request->get('removeBuildingRequirement');
    $elementBuilding = $game->getElement($currentBuilding['id']);
    $elementBuilding->removeRequirement($currentBuilding);
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
