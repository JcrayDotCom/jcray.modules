<?php

$game->registerMenu('Unités');

$newUnit = null;
$arrayReturn = [];

$newUnit = $game->createElementIfInRequest('newUnit', [
    'type' => 'unit',
]);

// Remove Unit if removeUnit is sent
$game->deleteElementIfInRequest('removeUnit');

// Update Units properties if is sent
$game->updateElementsIfInRequest('units');

if (!$game->get('unitStats')) {
    $game->set('unitStats', []);
}

if ($request->get('newStat')) {
    $gameStats = $game->get('unitStats');
    $gameStats[] = $request->get('newStat');
    $game->set('unitStats', $gameStats);
}

if ($request->get('unitStats')) {
    $game->set('unitStats', $request->get('unitStats'));
}

$createdCosts = [];
if ($request->get('currentUnit')) {
    $currentUnit = (array) $request->get('currentUnit');
    $unit = $game->getElement($currentUnit['id']);
    foreach ($currentUnit['costs'] as $costInfos) {
        $costInfos = (array) $costInfos;
        $costInfos['cost'] = (array) $costInfos['cost'];
        $createdCosts[] = $unit->createCost($costInfos['cost']['id'], $costInfos['quantity']);
    }
    $currentUnit = (array) $request->get('currentUnit');
    foreach ($currentUnit['properties'] as $property) {
        $property = (array) $property;
        $unit->set($property['name'], $property['value']);
    }
}

$gameStats = $game->get('unitStats');
$elements = $game->getElementsByProperties(['isUnit' => true]);
foreach ($gameStats as $stat) {
    foreach ($elements as $element) {
        if (!$element->get($stat->name)) {
            $element->set($stat->name, $stat->quantity);
        }
    }
}

$moneys = $game->getElementsByProperties(['isMoney' => true]);
$elements = $game->getElementsByProperties(['type' => 'unit']);
$action = $game->createAction('booster');

foreach ($elements as $element) {
    $costs = $element->getCosts();
    foreach ($moneys as $money) {
        if (!$element->getCost($money)) {
            $element->createCost($money, 0);
        }
    }
}

return [
    'units' => $elements,
    'moneys' => $moneys,
    'createdCosts' => $createdCosts,
    'unitStats' => (array) $game->get('unitStats'),
];
