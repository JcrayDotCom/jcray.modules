<?php

$newMoney = null;
$arrayReturn = [];

$newMoney = $game->createElementIfInRequest('newMoney', [
    'type' => 'money',
]);

$game->deleteElementIfInRequest('removeMoney');
$game->updateElementsIfInRequest('moneys');

$moneys = $game->getElementsByProperties([
    'type' => 'money',
]);

return array_merge($arrayReturn, ['newMoney' => $newMoney, 'moneys' => $moneys]);
