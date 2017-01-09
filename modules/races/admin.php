<?php

$arrayReturn = [];
$defaultProperties = [];

/*
* Create a new Race
*/

$newRace = null;

$newRace = $game->createElementIfInRequest('newRace', array_merge($defaultProperties, [
    'type' => 'Race',
]));

/*
* Edit an existant Race
*/

$game->updateElementsIfInRequest('races');

/*
* Create filter on Race :
* Player has to chose a Race
*/

$game->registerFilter('Race');

/*
* Delete a Race
*/

$game->deleteElementIfInRequest('removeRace');

/*
* Retrieve all races
*/

$arrayReturn['races'] = $game->getElementsByProperties([
    'type' => 'Race',
]);

return $arrayReturn;
