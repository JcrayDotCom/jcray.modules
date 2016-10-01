<?php

$newMoney = null;
$arrayReturn = [];

if (null !== $newMoney = $game->createElementIfInRequest('newMoney')) {
    $newMoney->set('isMoney', true);
}
$game->deleteElementIfInRequest('removeMoney');

$game->updateElementsIfInRequest('moneys');

$moneys = $game->getElementsByProperties([
    'isMoney' => true,
]);

return array_merge($arrayReturn, ['newMoney' => $newMoney, 'moneys' => $moneys]);
