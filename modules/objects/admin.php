<?php

$arrayReturn = [];

/*
* Add module objects to the game menu
*/

$game->registerMenu('objects');

/*
* Create a new Object
*/

$newObject = null;

$newObject = $game->createElementIfInRequest('newObject', [
    'type' => 'Object',
]);

/*
* Edit costs of an Object
*/

// Update costs of a Object
if ($request->get('costsElementObject')) {
    $currentObject = (array) $request->get('costsElementObject');
    $elementObject = $game->getElement($currentObject['id']);
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
