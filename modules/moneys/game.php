<?php

$moneys = $game->getElementsByProperties([
    'type' => 'Money',
]);

$playerMoneys = [];

if ($player) {
    foreach ($moneys as $money) {
        $playerMoney = $player->getElement($money->getId());
        if (!$playerMoney) {
            $playerMoney = $player->createElement($money->getId());
        }
        $playerMoneys[] = $playerMoney;
    }

    return [
        'moneys' => $playerMoneys,
    ];
} else {
    return ['defaultMoneys' => $moneys];
}
