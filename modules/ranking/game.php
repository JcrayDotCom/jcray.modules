<?php

$players = [];
$game->registerMenu('ranking');
if ($request->get('page')) {
    $page = (int) $request->get('page');
} else {
    $page = 1;
}

$nextPage = false;
$previousPage = false;

$players = $game->getPlayersByRank($page);
$nbPlayers = count($players);
if ($nbPlayers >= 25) {
    $nextPage = $page + 1;
}
if ($page > 1) {
    $prevousPage = $page - 1;
}

$arrayReturn = [
    'players' => $players,
    'page' => $page,
    'startRank' => ($page - 1) * 25 + 1,
    'nextPage' => $nextPage,
    'previousPage' => $previousPage,
];

return $arrayReturn;
