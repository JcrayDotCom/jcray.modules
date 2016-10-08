<?php

$newMoney = null;
$arrayReturn = [];

$newMoney = $game->createElementIfInRequest('newMoney', [
    'type' => 'Money',
]);

$game->deleteElementIfInRequest('removeMoney');
$game->updateElementsIfInRequest('moneys');

$moneys = $game->getElementsByProperties([
    'type' => 'Money',
]);

return array_merge($arrayReturn, ['newMoney' => $newMoney, 'moneys' => $moneys]);
