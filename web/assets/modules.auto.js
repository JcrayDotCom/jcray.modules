var modules = {"moneys":{"admin_controller":"<?php\n\n$newMoney = null;\n$arrayReturn = [];\n\n$newMoney = $game->createElementIfInRequest('newMoney', [\n    'type' => 'Money',\n]);\n\n$game->deleteElementIfInRequest('removeMoney');\n$game->updateElementsIfInRequest('moneys');\n\n$moneys = $game->getElementsByProperties([\n    'type' => 'Money',\n]);\n\nreturn array_merge($arrayReturn, ['newMoney' => $newMoney, 'moneys' => $moneys]);\n","admin_template":"{% block %}\n    {% title %}Create a new money{% endtitle %}\n    <form>\n        <input type=\"text\" ng-model=\"data.newMoney.name\" placeholder=\"Money name\" \/>\n        <input type=\"text\" ng-model=\"data.newMoney.quantity\" placeholder=\"Money default quantity\" \/>\n        <input type=\"text\" ng-model=\"data.newMoney.picture\" placeholder=\"Picture (prefixed with http:\/\/)\" \/>\n        {% button %}Create this new money{% endbutton %}\n    <\/form>\n{% endblock %}\n\n<div ng-if=\"data.moneys && data.moneys.length\">\n    {% block %}\n        {% title %}Moneys of your game{% endtitle %}\n        <ul class=\"collection\">\n            <li ng-repeat=\"money in data.moneys\" class=\"collection-item row\">\n                <div class=\"col-md-4\">\n                    <label>Name<\/label>\n                    <input type=\"text\" ng-model=\"money.name\" ng-change=\"post()\" \/>\n                <\/div>\n                <div class=\"col-md-4\" ng-repeat=\"property in money.properties\" ng-if=\"property.name == 'picture' || property.name == 'quantity'\">\n                    <label>{{ property.name }}<\/label>\n                    <input type=\"text\" ng-model=\"property.value\"  ng-change=\"post()\" \/>\n                <\/div>\n            <\/li>\n        <\/ul>\n    {% endblock %}\n<\/div>\n","game_controller":"<?php\n\n$moneys = $game->getElementsByProperties([\n    'type' => 'Money',\n]);\n\n$playerMoneys = [];\n\nif ($player) {\n    foreach ($moneys as $money) {\n        $playerMoney = $player->getElement($money->getId());\n        if (!$playerMoney) {\n            $playerMoney = $player->createElement($money->getId());\n        }\n        $playerMoneys[] = $playerMoney;\n    }\n\n    return [\n        'moneys' => $playerMoneys,\n    ];\n} else {\n    return ['defaultMoneys' => $moneys];\n}\n","game_template":"<div ng-if=\"data.moneys.length\">\n    <div class=\"chip\" ng-repeat=\"money in data.moneys\">\n        <img ng-repeat=\"property in money.properties\" ng-if=\"property.name == 'picture'\" ng-src=\"{{ property.value }}\" alt=\"{{ money.name }}\">\n        <span ng-repeat=\"property in money.properties\" ng-if=\"property.name == 'quantity'\">\n            {{ property.value }}\n        <\/span>\n    <\/div>\n<\/div>\n<div ng-if=\"!data.moneys.length && data.defaultMoneys.length\">\n    You can earn a lot of these moneys:\n    <div class=\"chip\" ng-repeat=\"money in data.defaultMoneys\">\n        <img ng-repeat=\"property in money.properties\" ng-if=\"property.name == 'picture'\" ng-src=\"{{ property.value }}\" alt=\"{{ money.name }}\">\n        <span ng-repeat=\"property in money.properties\" ng-if=\"property.name == 'quantity'\">\n            {{ property.value }}\n        <\/span>\n    <\/div>\n<\/div>\n"},"objects":{"admin_controller":"<?php\n\n$game->registerMenu('Objets');\n\n$newObject = $game->createElementIfInRequest('newObject', [\n    'type' => 'Object',\n    'usable' => true,\n]);\n\n$game->deleteElementIfInRequest('removeObject');\n\nif ($request->get('currentObject')) {\n    $object = $game->getElement($request->get('currentObject')['id']);\n    foreach ($request->get('currentObject')['properties'] as $property) {\n        $object->set($property['name'], $property['value']);\n    }\n    if ($request->get('newEffect')) {\n        $effect = $object->createEffect($request->get('newEffect')['propertyName'], $request->get('newEffect')['quantity']);\n    }\n}\n\n$objects = $game->getElementsByProperties([\n    'type' => 'Object',\n]);\n\nreturn [\n    'objects' => $objects,\n    'properties' => $game->getElementsProperties(),\n];\n","admin_template":"<div class=\"row card\">\n    <div class=\"col s12\">\n      <ul class=\"tabs\">\n        <li class=\"tab col s3\"><a ng-click=\"currentTab = 'all'; currentObject = null\">All Objects<\/a><\/li>\n        <li class=\"tab col s3\"><a class=\"active\" ng-click=\"currentTab = 'new'\">New Object<\/a><\/li>\n      <\/ul>\n    <\/div>\n<\/div>\n\n<div ng-if=\"currentTab == 'new' || (!data.objects.length && !currentTab)\">\n    {% block %}\n        {% title %}New object{% endtitle %}\n        <input type=\"text\" placeholder=\"Name of the object\" ng-model=\"data.newObject.name\" \/>\n        <input type=\"text\" placeholder=\"Picture of the object\" ng-model=\"data.newObject.picture\" \/>\n        <button class=\"btn\" ng-click=\"post()\">Create this object<\/button>\n    {% endblock %}\n<\/div>\n\n<div ng-if=\"currentTab == 'all' || (!data.currentObject && data.objects.length && !currentTab)\">\n    {% block %}\n    <ul class=\"collection\">\n        <li class=\"collection-item clear row\" ng-repeat=\"object in data.objects\">\n            <span class=\"col-md-6\">{{ object.name }}<\/span>\n            <span class=\"col-md-6\">\n                <button class=\"btn\" ng-click=\"data.currentObject = object\">Edit<\/button>\n            <\/span>\n        <\/li>\n    <\/ul>\n    <div class=\"clear\"><\/div>\n    {% endblock %}\n<\/div>\n\n<div ng-if=\"data.currentObject && (currentTab == 'all' || !currentTab)\">\n    {% block %}\n        {% title %}Properties of {{ data.currentObject.name }}{% endtitle %}\n        <ul class=\"collection\">\n            <li class=\"row collection-item\" ng-repeat=\"property in data.currentObject.properties\" ng-if=\"property.name != 'isObject'\">\n                <span class=\"col-md-6\">{{ property.name }}<\/span>\n                <span class=\"col-md-6\"><input type=\"text\" ng-model=\"property.value\" \/><\/span>\n            <\/li>\n        <\/ul>\n        <button class=\"btn\" ng-click=\"post()\">Save<\/button>\n    {% endblock %}\n    {% block %}\n        <div ng-if=\"data.currentObject.effects.length\">\n            {% title %}Effects of {{ data.currentObject.name }}{% endtitle %}\n            <ul class=\"collection\">\n                <li class=\"row collection-item\" ng-repeat=\"effect in data.currentObject.effects\">\n                    <span class=\"col-md-6\">{{ effect.property_name }}<\/span>\n                    <span class=\"col-md-6\"><input type=\"text\" ng-model=\"effect.quantity\" \/><\/span>\n                <\/li>\n            <\/ul>\n            <button class=\"btn\" ng-click=\"post()\">Save<\/button>\n        <\/div>\n    {% endblock %}\n    {% block %}\n        {% title %}New effect{% endtitle %}\n        <select ng-model=\"data.newEffect.propertyName\">\n            <option disabled selected>( Select a property )<\/option>\n            <option ng-repeat=\"property in data.properties\" value=\"{{ property.name }}\">\n                {{ property.name }}\n            <\/option>\n        <\/select>\n        <input type=\"text\" ng-model=\"data.newEffect.quantity\" ng-model=\"Effect\" \/>\n        <button class=\"btn\" ng-click=\"post()\">Create effect<\/button>\n    {% endblock %}\n<\/div>\n","game_controller":"<?php\n\n$game->registerMenu('Objets');\n\nif ($player) {\n    $objects = $game->getElementsByProperties([\n        'type' => 'Object',\n    ]);\n\n    foreach ($objects as $object) {\n        if (!$player->getElement($object)) {\n            $player->createElement($object->id, 0);\n        }\n    }\n\n    if ($request->get('playerObjects')) {\n        foreach ($request->get('playerObjects') as $object) {\n            if (isset($object['data']) && $object['data']) {\n                $playerElement = $player->getElement($object['element']['id']);\n                $playerElement->set('quantity', $playerElement->get('quantity') + (int) $object['data']);\n            }\n        }\n    }\n\n    if ($request->get('currentObject')) {\n        $playerElement = $player->getElement($request->get('currentObject')['element']['id']);\n        $playerElement->set('quantity', $playerElement->get('quantity') - 1);\n    }\n\n    $playerObjects = $player->getElementsByProperties([\n        'type' => 'Object',\n    ]);\n\n    return [\n        'objects' => $objects,\n        'playerObjects' => $playerObjects,\n    ];\n}\n\nreturn [];\n","game_template":"<div class=\"card horizontal\" ng-repeat=\"object in data.playerObjects\">\n    <div class=\"card-image\">\n        <img ng-repeat=\"property in object.element.properties\" ng-if=\"property.name == 'picture'\" ng-src=\"{{ property.value }}\">\n    <\/div>\n    <div class=\"card-content\">\n        <div class=\"card-title\">\n            {{ object.element.name }}\n            <span ng-repeat=\"property in object.properties\" ng-if=\"property.name == 'quantity'\">\n                ({{ property.value }})\n            <\/span>\n        <\/div>\n        <div class=\"row\">\n            <div class=\"col-md-4\">\n                Effects: <br \/>\n                <div ng-repeat=\"effect in object.element.effects\">\n                    <span ng-if=\"effect.quantity > 0\">+<\/span> {{ effect.quantity }}\n                    {{ effect.property_name }}\n                <\/div>\n                <button class=\"btn\" ng-click=\"data.currentObject = object; post()\">Use it!<\/button>\n            <\/div>\n            <div class=\"col-md-4\">\n                <input type=\"text\"  ng-model=\"object.data\" placeholder=\"Quantity to buy\" \/>\n            <\/div>\n            <div class=\"col-md-4\">\n                <button class=\"btn\" ng-click=\"post()\">Buy!<\/button>\n            <\/div>\n        <\/div>\n    <\/div>\n<\/div>\n"},"units":{"admin_controller":"<?php\n\n$game->registerMenu('Unit\u00e9s');\n\n$newUnit = null;\n$arrayReturn = [];\n\n$newUnit = $game->createElementIfInRequest('newUnit', [\n    'type' => 'Unit',\n]);\n\n\/\/ Remove Unit if removeUnit is sent\n$game->deleteElementIfInRequest('removeUnit');\n\n\/\/ Update Units properties if is sent\n$game->updateElementsIfInRequest('units');\n\nif (!$game->get('unitStats')) {\n    $game->set('unitStats', []);\n}\n\nif ($request->get('newStat')) {\n    $gameStats = $game->get('unitStats');\n    $gameStats[] = $request->get('newStat');\n    $game->set('unitStats', $gameStats);\n}\n\nif ($request->get('unitStats')) {\n    $game->set('unitStats', $request->get('unitStats'));\n}\n\n$createdCosts = [];\nif ($request->get('currentUnit')) {\n    $currentUnit = (array) $request->get('currentUnit');\n    $unit = $game->getElement($currentUnit['id']);\n    foreach ($currentUnit['costs'] as $costInfos) {\n        $costInfos = (array) $costInfos;\n        $costInfos['cost'] = (array) $costInfos['cost'];\n        $createdCosts[] = $unit->createCost($costInfos['cost']['id'], $costInfos['quantity']);\n    }\n    $currentUnit = (array) $request->get('currentUnit');\n    foreach ($currentUnit['properties'] as $property) {\n        $property = (array) $property;\n        $unit->set($property['name'], $property['value']);\n    }\n}\n\n$gameStats = $game->get('unitStats');\n$elements = $game->getElementsByProperties(['isUnit' => true]);\nforeach ($gameStats as $stat) {\n    foreach ($elements as $element) {\n        if (!$element->get($stat->name)) {\n            $element->set($stat->name, $stat->quantity);\n        }\n    }\n}\n\n$moneys = $game->getElementsByProperties(['isMoney' => true]);\n$elements = $game->getElementsByProperties(['type' => 'unit']);\n$action = $game->createAction('booster');\n\nforeach ($elements as $element) {\n    $costs = $element->getCosts();\n    foreach ($moneys as $money) {\n        if (!$element->getCost($money)) {\n            $element->createCost($money, 0);\n        }\n    }\n}\n\nreturn [\n    'units' => $elements,\n    'moneys' => $moneys,\n    'createdCosts' => $createdCosts,\n    'unitStats' => (array) $game->get('unitStats'),\n];\n","admin_template":"<div class=\"row card\">\n    <div class=\"col s12\">\n      <ul class=\"tabs\">\n        <li class=\"tab col s3\"><a ng-click=\"currentEditing = 'all'; currentUnit = null\">All Units<\/a><\/li>\n        <li class=\"tab col s3\"><a class=\"active\" ng-click=\"currentEditing = 'new'\">New Unit<\/a><\/li>\n        <li class=\"tab col s3\"><a ng-click=\"currentEditing = 'stats'\">Stats<\/a><\/li>\n      <\/ul>\n    <\/div>\n  <\/div>\n\n<div ng-if=\"currentEditing == 'new' || (!currentEditing && !data.units.length)\">\n{% block %}\n    {% title %}Create a new unit{% endtitle %}\n    <form>\n        <input type=\"text\" ng-model=\"data.newUnit.name\" placeholder=\"Unit name\" \/>\n        <input type=\"text\" ng-model=\"data.newUnit.quantity\" placeholder=\"Unit default quantity\" \/>\n        <input type=\"text\" ng-model=\"data.newUnit.picture\" placeholder=\"Picture (prefixed with http:\/\/)\" \/>\n        {% button %}Create this new unit{% endbutton %}\n    <\/form>\n{% endblock %}\n<\/div>\n\n<div ng-if=\"currentEditing == 'stats'\">\n{% block %}\n    {% title %}Stats{% endtitle %}\n    <ul class=\"collection\">\n        <li class=\"collection-item row\" ng-repeat=\"stat in data.unitStats\">\n            <span class=\"col-md-4\"><input type=\"text\" ng-model=\"stat.name\" \/><\/span>\n            <span class=\"col-md-4\"><input type=\"text\" ng-model=\"stat.quantity\" \/><\/span>\n        <\/li>\n        <li class=\"collection-item\">\n            <button class=\"btn\" ng-click=\"post()\">Update stats<\/button>\n        <\/li>\n    <\/ul>\n    {% title %}New stat {% endtitle %}\n    <input type=\"text\" placeholder=\"Name of the stat\" ng-model=\"data.newStat.name\" \/>\n    <input type=\"text\" placeholder=\"Default value of the stat\" ng-model=\"data.newStat.quantity\" \/>\n    <button class=\"btn\" ng-click=\"post()\">Create this stat<\/button>\n{% endblock %}\n<\/div>\n\n<div ng-if=\"data.currentUnit && (currentEditing == 'all' || !currentEditing)\">\n    {% block %}\n        {% block %}\n        {% title %}Properties of {{ data.currentUnit.name }}{% endtitle %}\n        <ul class=\"collection\">\n            <li class=\"row collection-item\" ng-repeat=\"property in data.currentUnit.properties\" ng-if=\"property.name != 'isUnit'\">\n                <span class=\"col-md-6\">{{ property.name }}<\/span>\n                <span class=\"col-md-6\"><input type=\"text\" ng-model=\"property.value\" \/><\/span>\n            <\/li>\n        <\/ul>\n        <button class=\"btn\" ng-click=\"post()\">Save<\/button>\n        {% endblock %}\n        {% title %}Edit costs for {{ data.currentUnit.name }}{% endtitle %}\n        <ul class=\"collection\">\n            <li class=\"collection-item row\" ng-repeat=\"cost in data.currentUnit.costs\">\n                <span class=\"col-md-4\">{{ cost.cost.name }}<\/span>\n                <span class=\"col-md-4\">\n                    <input type=\"text\" ng-model=\"cost.quantity\" \/>\n                <\/span>\n            <\/li>\n        <\/ul>\n        <button class=\"btn\" ng-click=\"post()\">Update costs<\/button>\n    {% endblock %}\n    {% block %}\n        {% title %}Edit stats for {{ data.currentUnit.name }}{% endtitle %}\n        <ul class=\"collection\">\n            <li class=\"collection-item row\" ng-repeat=\"stat in data.unitStats\">\n                <span class=\"col-md-4\">{{ stat.name }}<\/span>\n                <span class=\"col-md-4\">\n                    <input ng-repeat=\"property in data.currentUnit.properties\" ng-if=\"property.name == stat.name\" type=\"text\" ng-model=\"property.value\" \/>\n                <\/span>\n            <\/li>\n        <\/ul>\n        <button class=\"btn\" ng-click=\"post()\">Update stats<\/button>\n    {% endblock %}\n<\/div>\n\n<div ng-if=\"!data.currentUnit && ((data.units && data.units.length && currentEditing == 'all') || (!currentEditing && data.units.length))\">\n    {% block %}\n        {% title %}Units of your game{% endtitle %}\n        <ul class=\"collection\">\n            <li ng-repeat=\"unit in data.units\" class=\"collection-item row\">\n                <div class=\"col-md-3\">\n                    <label>Name<\/label>\n                    <input type=\"text\" ng-model=\"unit.name\" ng-change=\"post()\" \/>\n                <\/div>\n                <div class=\"col-md-3\" ng-repeat=\"property in unit.properties\" ng-if=\"property.name == 'picture' || property.name == 'quantity'\">\n                    <label>{{ property.name }}<\/label>\n                    <input type=\"text\" ng-model=\"property.value\"  ng-change=\"post()\" \/>\n                <\/div>\n                <div class=\"col-md-3\">\n                    <button class=\"btn\" ng-click=\"data.currentUnit = unit\">Edit<\/button>\n                <\/div>\n            <\/li>\n        <\/ul>\n    {% endblock %}\n<\/div>\n","game_controller":"<?php\n\n$game->registerMenu('Unit\u00e9s');\n\n$elements = $game->getElementsByProperties(['type' => 'Unit']);\n$playerElements = [];\n$error = false;\n\nif ($player) {\n    if ($request->get('playerElements')) {\n        foreach ($request->get('playerElements') as $playerElement) {\n            if (isset($playerElement['data']) && (int) $playerElement['data'] > 0) {\n                $playerElementEntity = $player->getElement($playerElement['element']['id']);\n                try {\n                    $playerElementEntity->set('quantity', (int) $playerElementEntity->get('quantity') + (int) $playerElement['data']);\n                } catch (Exception $e) {\n                    $error = $e->getMessage();\n                }\n            }\n        }\n    }\n\n    foreach ($elements as $element) {\n        $playerElement = $player->getElement($element->getId());\n        $playerElement->setData(0);\n        $playerElements[] = $playerElement;\n    }\n}\n\nreturn ['units' => $elements, 'playerElements' => $playerElements, 'error' => $error];\n","game_template":"<div ng-if=\"!data.player\">\n    Discover my wonderful game and a lot of units:\n    <ul class=\"collection\">\n        <li class=\"collection-item\" ng-repeat=\"unit in data.units\">\n            {{ unit.name }}\n        <\/li>\n    <\/ul>\n<\/div>\n\n<div ng-if=\"data.player\">\n    <div ng-if=\"data.error\" class=\"alert alert-danger\">\n        <a class=\"close\" data-dismiss=\"alert\">&times;<\/a>\n        <strong>Error:<\/strong> {{ data.error }}\n    <\/div>\n    <div class=\"card horizontal\" ng-repeat=\"unit in data.playerElements\">\n        <div class=\"card-image\">\n            <img ng-repeat=\"property in unit.properties\" ng-if=\"property.name == 'picture'\" ng-src=\"{{ property.value }}\" \/>\n        <\/div>\n        <div class=\"card-title\">\n            {{ unit.element.name }}\n            <span ng-repeat=\"property in unit.properties\" ng-if=\"property.name == 'quantity'\">({{ property.value }})<\/span>\n        <\/div>\n        <div class=\"card-content\">\n            <div class=\"row\">\n                <div class=\"col-md-4\">\n                    <div ng-repeat=\"cost in unit.element.costs\">\n                        <img ng-repeat=\"costProperty in cost.cost.properties\" ng-if=\"costProperty.name == 'picture'\" ng-src=\"{{ costProperty.value }}\" \/>\n                        {{ cost.quantity }}\n                    <\/div>\n                <\/div>\n                <div class=\"col-md-4\">\n                    <label>Want more?<\/label>\n                    <input type=\"text\" ng-model=\"unit.data\" \/>\n                <\/div>\n                <div class=\"col-md-4\">\n                    <button class=\"btn\" ng-click=\"post()\">Recruit!<\/button>\n                <\/div>\n            <\/div>\n        <\/div>\n    <\/div>\n<\/div>\n"},"animals":{"admin_controller":"<?php\n\n$arrayReturn = [];\n\n\/*\n* Add module animals to the game menu\n*\/\n\n$game->registerMenu('animals');\n\n\/*\n* Create a new Animal\n*\/\n\n$newAnimal = null;\n\n$newAnimal = $game->createElementIfInRequest('newAnimal', [\n    'type' => 'Animal',\n]);\n\n\/*\n* Edit an existant Animal\n*\/\n\n$game->updateElementsIfInRequest('animals');\n\n\/*\n* Delete a Animal\n*\/\n\n$game->deleteElementIfInRequest('removeAnimal');\n\n\/*\n* Retrieve all animals\n*\/\n\n$arrayReturn['animals'] = $game->getElementsByProperties([\n    'type' => 'Animal',\n]);\n\nreturn $arrayReturn;\n","admin_template":"<!-- Create a Animal -->\n{% block %}\n    {% title %}Create a new Animal {% endtitle %}\n    <form>\n        <input type=\"text\" ng-model=\"data.newAnimal.name\" placeholder=\"Animal name\" \/>\n        <input type=\"text\" ng-model=\"data.newAnimal.quantity\" placeholder=\"Animal default quantity\" \/>\n        <input type=\"text\" ng-model=\"data.newAnimal.picture\" placeholder=\"Picture (prefixed with http:\/\/)\" \/>\n        {% button %}Create this new Animal{% endbutton %}\n    <\/form>\n{% endblock %}\n\n<!-- Edit a Animal -->\n<div ng-if=\"data.animals && data.animals.length\">\n    {% block %}\n        {% title %}animals of your game{% endtitle %}\n        <ul class=\"collection\">\n            <li ng-repeat=\"element in data.animals\" class=\"collection-item row\">\n                <div class=\"col-md-4\">\n                    <label>Name<\/label>\n                    <input type=\"text\" ng-model=\"element.name\" ng-change=\"post()\" \/>\n                <\/div>\n                <div class=\"col-md-4\" ng-repeat=\"property in element.properties\" ng-if=\"property.name == 'picture' || property.name == 'quantity'\">\n                    <label>{{ property.name }}<\/label>\n                    <input type=\"text\" ng-model=\"property.value\" ng-change=\"post()\" \/>\n                <\/div>\n            <\/li>\n        <\/ul>\n    {% endblock %}\n<\/div>\n","game_controller":"<?php \n","game_template":"{% block %}\n\n{% endblock %}"},"races":{"admin_controller":"<?php\n\nif ($request->get('introduction')) {\n    $module->set('introduction', $request->get('introduction'));\n} elseif (!$module->get('introduction')) {\n    $module->set('introduction', false);\n}\n\n$newRace = null;\n$arrayReturn = [];\n\n$newRace = $game->createElementIfInRequest('newRace', [\n    'type' => 'Race',\n]);\n\n\/\/ Delete Race if removeRace is sent\n$game->deleteElementIfInRequest('removeRace');\n\n\/\/ Update races properties if is sent\n$game->updateElementsIfInRequest('races');\n\n$races = $game->getElementsByProperties(['type' => 'Race']);\n\n$game->registerFilter('Race');\n\nreturn [\n    'races' => $races,\n    'introduction' => $module->get('introduction'),\n];\n","admin_template":"{% block %}\n    {% title %}Page d'introduction{% endtitle %}\n    <textarea placeholder=\"Texte d'ambiance: choisissez votre race, etc.\" ng-model=\"data.introduction\" ng-repeat=\"property in module.properties\" ng-if=\"property.name='introduction'\">\n    <\/textarea>\n    <button class=\"btn\" ng-click=\"post()\">Update<\/button>\n{% endblock %}\n\n{% block %}\n    {% title %}New race{% endtitle %}\n    <input type=\"text\" ng-model=\"data.newRace.name\" placeholder=\"Name of the race\" \/>\n    <input type=\"text\" ng-model=\"data.newRace.picture\" placeholder=\"Picture of the race\" \/>\n    <textarea placeholder=\"Description of this race\" ng-model=\"data.newRace.description\"><\/textarea>\n    <button class=\"btn\" ng-click=\"post()\">Create this race<\/button>\n{% endblock %}\n\n<div ng-if=\"data.races.length\">\n{% block %}\n    <button class=\"btn pull-right\" ng-click=\"post()\">Update<\/button>\n    {% title %}Races{% endtitle %}\n    <ul class=\"collection\">\n        <li ng-repeat=\"race in data.races\">\n            <div class=\"row\">\n                <div class=\"col-md-4\">\n                    <label>Name<\/label>\n                    <input type=\"text\" ng-model=\"race.name\" \/>\n                <\/div>\n                <div class=\"col-md-4\">\n                    <label>Picture<\/label>\n                    <input ng-repeat=\"property in race.properties\" ng-if=\"property.name=='picture'\" type=\"text\" ng-model=\"property.value\" \/>\n                <\/div>\n                <div class=\"col-md-4\">\n                    <label>Description<\/label>\n                    <textarea ng-repeat=\"property in race.properties\" ng-if=\"property.name=='description'\" ng-model=\"property.value\" ng-bind=\"property.value\"><\/textarea>\n                <\/div>\n            <\/div>\n        <\/li>\n    <\/ul>\n    <button class=\"btn pull-right\" ng-click=\"post()\">Update<\/button>\n    <div class=\"clear\"><\/div>\n{% endblock %}\n<\/div>\n","game_controller":"<?php\n\n$races = $game->getElementsByProperties(['type' => 'Race']);\n\nif ($request->get('chosenRace')) {\n    $player->set('Race', $request->get('chosenRace')['id']);\n}\n\n$playerRace = $player->get('Race');\nif ($playerRace) {\n    $playerRace = $game->getElement($playerRace);\n}\n\nreturn [\n    'races' => $races,\n    'playerRace' => $playerRace,\n    'introduction' => $module->get('introduction'),\n];\n","game_template":"<div ng-if=\"!data.playerRace\">\n    {% block %}\n        {% title %}\n            {{ data.introduction }}\n        {% endtitle %}\n    {% endblock %}\n    <div ng-repeat=\"race in data.races\" class=\"card horizontal\">\n        <div class=\"card-image\">\n            <img ng-repeat=\"property in race.properties\" ng-if=\"property.name == 'picture'\" ng-src=\"{{ property.value }}\" \/>\n        <\/div>\n        <div class=\"card-content\">\n            <div class=\"card-title\">\n                {{ race.name }}\n                <p>{{ race.description }}<\/p>\n                <button class=\"btn\" ng-click=\"data.chosenRace = race; post()\">I want to be a {{ race.name }}!<\/button>\n            <\/div>\n        <\/div>\n    <\/div>\n<\/div>\n<div ng-if=\"data.playerRace\">\n    You are a {{ data.playerRace.name }}\n<\/div>\n"},"character":{"admin_controller":"<?php\n\n$game->registerMenu('Personnage');\n$game->registerTrigger('xp', function () {\n    if ($player->get('xp') >= $player->get('level') * 1500) {\n        $player->set('xp', 0);\n        $player->set('level', $player->get('level') + 1);\n    }\n});\n\nreturn [];\n","admin_template":"{% block %}Hello Jcray! This is my module!{% endblock %}\n","game_controller":"<?php\n\n$game->registerMenu('Personnage');\n\nif (!$player->get('level')) {\n    $player->set('level', 1);\n}\n\nif (!$player->get('xp')) {\n    $player->set('xp', 0);\n}\n\n$player->set('xp', 6000);\n\nreturn [];\n","game_template":"{% block %}\n    {% title %}{{ player.pseudo }}{% endtitle %}\n    <ul class=\"collection\">\n        <li class=\"collection-item\">\n            Level:\n            <span ng-repeat=\"property in player.properties\" ng-if=\"property.name=='level'\">\n                {{ property.value }}\n            <\/span>\n        <\/li>\n\n        <li class=\"collection-item\">\n            Xp:\n            <span ng-repeat=\"property in player.properties\" ng-if=\"property.name=='xp'\">\n                {{ property.value }}\n            <\/span>\n        <\/li>\n        <li class=\"collection-item\" ng-repeat=\"playerElement in data.filters\">\n            {{ filter.property_name }}\n            <span ng-repeat=\"property in player.properties\" ng-if=\"property.name == filter.property_name\">\n                {{ property.value }}\n            <\/span>\n        <\/li>\n    <\/ul>\n{% endblock %}\n"}};