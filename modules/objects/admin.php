<?php

$game->registerMenu('Objets');

$newObject = $game->createElementIfInRequest('newObject', [
    'isObject' => true,
    'usable' => true,
]);

$game->deleteElementIfInRequest('removeObject');

if ($request->get('currentObject')) {
    $object = $game->getElement($request->get('currentObject')['id']);
    foreach ($request->get('currentObject')['properties'] as $property) {
        $object->set($property['name'], $property['value']);
    }
    if ($request->get('newEffect')) {
        $effect = $object->createEffect($request->get('newEffect')['propertyName'], $request->get('newEffect')['quantity']);
    }
}

$objects = $game->getElementsByProperties([
    'isObject' => true,
]);

return [
    'objects' => $objects,
    'properties' => $game->getElementsProperties(),
];
