<?php

if ($request->get('introduction')) {
    $module->set('introduction', $request->get('introduction'));
} elseif (!$module->get('introduction')) {
    $module->set('introduction', false);
}

$newRace = null;
$arrayReturn = [];

$newRace = $game->createElementIfInRequest('newRace', [
    'type' => 'Race',
]);

// Delete Race if removeRace is sent
$game->deleteElementIfInRequest('removeRace');

// Update races properties if is sent
$game->updateElementsIfInRequest('races');

$races = $game->getElementsByProperties(['type' => 'Race']);

$game->registerFilter('Race');

return [
    'races' => $races,
    'introduction' => $module->get('introduction'),
];
