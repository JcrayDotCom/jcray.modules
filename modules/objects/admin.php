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

if ($request->get('effectsElementObject')) {
    $object = $game->getElement($request->get('effectsElementObject'));
    foreach ($request->get('effectsElementObject')['properties'] as $property) {
        $object->set($property['name'], $property['value']);
    }
    if ($request->get('newEffect')) {
        $effect = $object->createEffect($request->get('newEffect')['propertyName'], $request->get('newEffect')['quantity']);
    }
}

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
