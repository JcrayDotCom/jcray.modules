<?php

$arrayReturn = [];

/*
* Add module resources to the game menu
*/

$game->registerMenu('resources');

/*
* Create a new Resource
*/

$newResource = null;

$newResource = $game->createElementIfInRequest('newResource', [
    'type' => 'Resource',
]);

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
