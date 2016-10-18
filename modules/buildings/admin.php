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
