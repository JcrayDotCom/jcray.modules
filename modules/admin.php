<?php 
$arrayReturn = [];

/*
* Add module  to the game menu
*/

$game->registerMenu('');


/*
* Create a new 
*/

$new = null;

$new = $game->createElementIfInRequest('new', [
    'type' => '',
]);

/*
* Edit costs of an 
*/

// Update costs of a 
if ($request->get('costsElement')) {
    $current = (array) $request->get('costsElement');
    $element = $game->getElement($current['id']);
    $createdCosts = [];
    foreach ($current['costs'] as $costInfos) {
        $costInfos = (array) $costInfos;
        $costInfos['cost'] = (array) $costInfos['cost'];
        $createdCosts[] = $element->createCost($costInfos['cost']['id'], $costInfos['quantity']);
    }
     $arrayReturn['costsElement'] = $request->get('costsElement');
}

$elements = $game->getElementsByProperties(['type' => '']);
$moneys = $game->getElementsByProperties(['type' => 'Resource']);

// Apply default costs to 
foreach ($elements as $element) {
    $costs = $element->getCosts();
    foreach ($moneys as $money) {
        if (!$element->getCost($money)) {
            $element->createCost($money, 0);
        }
    }
}

/*
* Edit requirements of an 
*/

// Update requirements of a 
if ($request->get('requirementsElement')) {
    $current = (array) $request->get('requirementsElement');
    $element = $game->getElement($current['id']);
    $createdRequirements = [];
    foreach ($current['requirements'] as $requirementInfo) {
        $requirementInfo = (array) $requirementInfo;
        $requirementInfo['required_element'] = (array) $requirementInfo['required_element'];
        $createdRequirements[] = $element->createRequirement($requirementInfo['required_element']['id'], $costInfos['ratio'])
    }
     $arrayReturn['costsElement'] = $request->get('costsElement');
}

// Delete a requirement of an 
if ($request->get('removeRequirement')) {
    $current = (array) $request->get('removeRequirement');
    $this->removeRequirement($current);
}

/*
* Edit an existant 
*/

$game->updateElementsIfInRequest('');

/*
* Delete a 
*/

$game->deleteElementIfInRequest('remove');

/*
* Retrieve all 
*/

$arrayReturn[''] = $game->getElementsByProperties([
    'type' => '',
]);

return $arrayReturn;
