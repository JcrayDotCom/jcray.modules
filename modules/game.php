<?php 
$arrayReturn = [];

/*
* Buy a 
*/

if ($request->get('player')) {
    foreach ($request->get('player') as $playerElement) {
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

/*
* Get the  owned by the player
*/

$ = $game->getElementsByProperties([
    'type' => '',
]);

$playerElements = [];

if ($player) {
    foreach ($ as $element) {
        $playerElement = $player->getElement($element->getId());
        if (!$playerElement) {
            $playerElement = $player->createElement($element->getId());
        }
        if ($player->canHave($element->getId())) {
            $playerElements[] = $playerElement;
        }
    }

    $arrayReturn['player'] = $playerElements;
}

$arrayReturn[''] = $;

/*
*   List stats of 
*/

$arrayReturn['Stats'] = $game->get('Stats');

if (isset($error)) {
    $arrayReturn['error'] = $error;
}

return $arrayReturn;
