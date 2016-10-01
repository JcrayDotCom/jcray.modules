<?php

$game->registerMenu('Objets');

if ($player) {
    $objects = $game->getElementsByProperties([
        'isObject' => true,
    ]);

    foreach ($objects as $object) {
        if (!$player->getElement($object)) {
            $player->createElement($object->id, 0);
        }
    }

    if ($request->get('playerObjects')) {
        foreach ($request->get('playerObjects') as $object) {
            if (isset($object['data']) && $object['data']) {
                $playerElement = $player->getElement($object['element']['id']);
                $playerElement->set('quantity', $playerElement->get('quantity') + (int) $object['data']);
            }
        }
    }

    if ($request->get('currentObject')) {
        $playerElement = $player->getElement($request->get('currentObject')['element']['id']);
        $playerElement->set('quantity', $playerElement->get('quantity') - 1);
    }

    $playerObjects = $player->getElementsByProperties([
        'isObject' => true,
    ]);

    return [
        'objects' => $objects,
        'playerObjects' => $playerObjects,
    ];
}

return [];
