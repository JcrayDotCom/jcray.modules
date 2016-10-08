<?php

$arrayReturn = [];

/*
* Add module animals to the game menu
*/

$game->registerMenu('animals');

/*
* Create a new Animal
*/

$newAnimal = null;

$newAnimal = $game->createElementIfInRequest('newAnimal', [
    'type' => 'Animal',
]);

/*
* Edit an existant Animal
*/

$game->updateElementsIfInRequest('animals');

/*
* Delete a Animal
*/

$game->deleteElementIfInRequest('removeAnimal');

/*
* Retrieve all animals
*/

$arrayReturn['animals'] = $game->getElementsByProperties([
    'type' => 'Animal',
]);

return $arrayReturn;
