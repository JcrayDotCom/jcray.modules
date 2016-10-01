<?php

$game->registerMenu('Unités');

$elements = $game->getElementsByProperties(['isUnit' => true]);
$playerElements = [];
$error = false;

if ($player) {
    if ($request->get('playerElements')) {
        foreach ($request->get('playerElements') as $playerElement) {
            if (isset($playerElement['data']) && (int) $playerElement['data'] > 0) {
                $playerElementEntity = $player->getElement($playerElement['element']['id']);
                try {
                    $playerElementEntity->set('quantity', (int) $playerElementEntity->get('quantity') + (int) $playerElement['data']);
                } catch (Exception $e) {
                    $error = $e->getMessage();
                }
            }
        }
    }

    foreach ($elements as $element) {
        $playerElement = $player->getElement($element->getId());
        $playerElement->setData(0);
        $playerElements[] = $playerElement;
    }
}

return ['units' => $elements, 'playerElements' => $playerElements, 'error' => $error];
