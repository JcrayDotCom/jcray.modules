<?php

$arrayReturn = [];

/*
* Create a new Race
*/

$newRace = null;

$newRace = $game->createElementIfInRequest('newRace', [
    'type' => 'Race',
]);

/*
* Edit stats of races
*/

// By default no stats
if (!$game->get('racesStats')) {
    $game->set('racesStats', []);
}

// Updating stats
if ($request->get('racesStats')) {
    $game->set('racesStats', $request->get('racesStats'));
}

// Creating a new stat
if ($request->get('newStat')) {
    $gameStats = $game->get('racesStats');
    $gameStats[] = $request->get('newStat');
    $game->set('racesStats', $gameStats);
}

// Delete a stat
if ($request->get('removeRaceStat')) {
    $gameStats = $game->get('racesStats');
    $newStats = [];
    foreach ($gameStats as $stat) {
        if ($stat->name != $request->get('removeRaceStat')['name']) {
            $newStats[] = $stat;
        }
    }

    $game->set('racesStats', $newStats);
}

// Apply default stats to all elements
$gameStats = $arrayReturn['racesStats'] = $game->get('racesStats');

$elements = $game->getElementsByProperties(['type' => 'Race']);
foreach ($gameStats as $stat) {
    foreach ($elements as $element) {
        if (!$element->get($stat->name)) {
            $element->set($stat->name, (int) $stat->quantity);
        }
        if ($request->get('removeRaceStat')) {
            $element->removeProperty($request->get('removeRaceStat')['name']);
        }
    }
}

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
