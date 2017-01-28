<?php

$arrayReturn = [];

$elements = $game->getElements();

if ($request->get('rankingElement')) {
    $element = $game->getElement((array) $request->get('rankingElement')['id']);
    $game->setRankingElement($element);
}

if (0 === count($elements)) {
    $arrayReturn['error']['message'] = 'You do not have any element. Please create at least one using others modules.';
}
$arrayReturn[] = $elements;

return $arrayReturn;
