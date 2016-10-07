<?php

$newMoney = null;
$arrayReturn = [];

$newMoney = $game->createElementIfInRequest('newMoney', [
    'isMoney' => true,
]);

$game->deleteElementIfInRequest('removeMoney');
$game->updateElementsIfInRequest('moneys');

$moneys = $game->getElementsByProperties([
    'isMoney' => true,
]);

return array_merge($arrayReturn, ['newMoney' => $newMoney, 'moneys' => $moneys]);
