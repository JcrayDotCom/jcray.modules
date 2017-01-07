<?php

$arrayReturn = [];
$defaultProperties = [];

/*
* Add module objects to the game menu
*/

$game->registerMenu('objects');

/*
* Create a new Object
*/

$newObject = null;

$newObject = $game->createElementIfInRequest('newObject', array_merge($defaultProperties, [
    'type' => 'Object',
]));

/*
* Edit costs of an Object
*/

// Update costs of a Object
if ($request->get('costsElementObject')) {
    $currentObject = (array) $request->get('costsElementObject');
    $elementObject = $game->getElement($currentObject['id']);
    $createdCosts = [];
    foreach ($currentObject['costs'] as $costInfos) {
        $costInfos = (array) $costInfos;
        $costInfos['cost'] = (array) $costInfos['cost'];
        $createdCosts[] = $elementObject->createCost($costInfos['cost']['id'], $costInfos['quantity']);
    }
    $arrayReturn['costsElementObject'] = $request->get('costsElementObject');
}

$elements = $game->getElementsByProperties(['type' => 'Object']);
$moneys = $game->getElementsByProperties(['type' => 'Resource']);

// Apply default costs to objects
foreach ($elements as $element) {
    $costs = $element->getCosts();
    foreach ($moneys as $money) {
        if (!$element->getCost($money)) {
            $element->createCost($money, 0);
        }
    }
}

/*
* Edit requirements of an Object
*/

// List all requirable elements of the game
$arrayReturn['requirableElements'] = $game->getElementsByProperties(['requirable' => 1]);
$arrayReturn['haveRequirableElements'] = (bool) count($arrayReturn['requirableElements']);

$createdRequirements = [];

$objects = $game->getElementsByProperties([
    'type' => 'Object',
]);
$settedElements = [];

// Set default requirement (0)
foreach ($objects as $element) {
    foreach ($element->getRequirements() as $requirement) {
        $settedElements[] = $requirement->getRequiredElement()->getId();
    }

    foreach ($arrayReturn['requirableElements'] as $requirableElement) {
        if (!in_array($requirableElement->getId(), $settedElements)) {
            $createdRequirements[] = $element->createRequirement($requirableElement->getId(), 0);
        }
    }
}

// Update requirements of a Object
if ($request->get('requirementsElementObject')) {
    $currentObject = (array) $request->get('requirementsElementObject');
    $elementObject = $game->getElement($currentObject['id']);
    foreach ($currentObject['requirements'] as $requirementInfo) {
        $requirementInfo = (array) $requirementInfo;
        if (!isset($requirementInfo['required_element'])) {
            continue;
        }
        $requirementInfo['required_element'] = (array) $requirementInfo['required_element'];
        $createdRequirements[] = $elementObject->createRequirement($requirementInfo['required_element']['id'], $requirementInfo['ratio']);
    }
    $arrayReturn['requirementsElementObject'] = $createdRequirements;
}

// Delete a requirement of an Object
if ($request->get('removeObjectRequirement')) {
    $currentObject = (array) $request->get('removeObjectRequirement');
    $elementObject = $game->getElement($currentObject['id']);
    $elementObject->removeRequirement($currentObject);
}

/*
* Edit effects of an Object
*/

if ($request->get('effectsElementObject') && $request->get('newEffect')) {
    $object = $game->getElement($request->get('effectsElementObject')['id']);
    if ($request->get('newEffect')) {
        $effect = $object->createEffect($request->get('newEffect')['propertyName'], $request->get('newEffect')['quantity']);
        $effect->setType($request->get('newEffect')['type'] ?? 'global');
        $arrayReturn['created_effects'] = [$effect];
    }
}

/*
* Delete an effect
*/
if ($request->get('removeEffectObject') && $request->get('effectsElementObject')) {
    $object = $game->getElement($request->get('effectsElementObject')['id']);
    $object->removeEffect($request->get('removeEffectObject')['id']);
}

$arrayReturn['objects'] = $game->getElementsByProperties([
    'type' => 'Object',
]);

$arrayReturn['properties'] = $game->getElementsProperties();

/*
* Edit an existant Object
*/

$game->updateElementsIfInRequest('objects');

/*
* Delete a Object
*/

$game->deleteElementIfInRequest('removeObject');

/*
* Retrieve all objects
*/

$arrayReturn['objects'] = $game->getElementsByProperties([
    'type' => 'Object',
]);

return $arrayReturn;
