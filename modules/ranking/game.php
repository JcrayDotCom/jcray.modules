<?php

$players = [];
$game->registerMenu('ranking');
if ($request->get('page')) {
    $page = (int) $request->get('page');
} else {
    $page = 1;
}

$players = $game->getPlayersByRank($page);

$arrayReturn = [
    'players' => $players,
    'page' => $page,
    'startRank' => ($page - 1) * 25 + 1,
];

return $arrayReturn;
