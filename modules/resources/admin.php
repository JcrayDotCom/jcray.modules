<?php

$arrayReturn = [];
$defaultProperties = [];

/*
* Create a new Resource
*/

$newResource = null;

$newResource = $game->createElementIfInRequest('newResource', array_merge($defaultProperties, [
    'type' => 'Resource',
]));

/*
* Edit an existant Resource
*/

$game->updateElementsIfInRequest('resources');

/*
* Delete a Resource
*/

$game->deleteElementIfInRequest('removeResource');

/*
* Retrieve all resources
*/

$arrayReturn['resources'] = $game->getElementsByProperties([
    'type' => 'Resource',
]);

return $arrayReturn;
