<?php

if ($request->get('introduction')) {
    $module->set('introduction', $request->get('introduction'));
} elseif (!$module->get('introduction')) {
    $module->set('introduction', false);
}

$newRace = null;
$arrayReturn = [];

$newRace = $game->createElementIfInRequest('newRace', [
    'type' => 'race',
]);

// Delete Race if removeRace is sent
$game->deleteElementIfInRequest('removeRace');

// Update races properties if is sent
$game->updateElementsIfInRequest('units');

$races = $game->getElementsByProperties(['type' => 'race']);

$game->registerFilter('race');

return [
    'races' => $races,
    'introduction' => $module->get('introduction'),
];
