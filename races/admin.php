<?php

if ($request->get('introduction')) {
    $module->set('introduction', $request->get('introduction'));
} elseif (!$module->get('introduction')) {
    $module->set('introduction', false);
}

// Create Race if newRace is sent
if (null !== $newRace = $game->createElementIfInRequest('newRace')) {
    $newRace->set('isRace', true);
}

// Delete Race if removeRace is sent
$game->deleteElementIfInRequest('removeRace');

// Update races properties if is sent
$game->updateElementsIfInRequest('units');

$races = $game->getElementsByProperties(['isRace' => true]);

$game->registerFilter('race');

return [
    'races' => $races,
    'introduction' => $module->get('introduction'),
];
