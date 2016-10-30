var jcrayApp = angular.module('jcrayApp', [
    'jcrayTech',
    'ngCookies'
]).filter('ucfirst', function(){
    return function(input, optional1, optional2) {
        return input.charAt(0).toUpperCase() + input.slice(1);
    };
});

var Translator = {
    locale: 'en',
    trans: function(input){
        return input;
    }
};
var jcrayTech = angular.module('jcrayTech', ['ngCookies']).filter('trans', function() {
    return function(input) {
        return input;
    };
}).filter('simpleQuote', function(){
    return function(input, optional1, optional2) {
        return input;
    };
});

jcrayApp.controller('appCtrl', ['$scope', '$templateCache', '$http', '$cookies',
    function ($scope, $templateCache, $http, $cookies) {
        $scope.bearer;
        $scope.Translator = Translator;
        console.log('Waiting for credentials...');
        if ($cookies.get('bearer')) {
            $scope.bearer = $cookies.get('bearer');

        }
        $scope.bearer = techEnv.token;
        $cookies.put('bearer', $scope.bearer );

        $scope.getDefaultHeaders = function(){
            if (techEnv) {
                return {'headers': {
                    'Authorization': 'Bearer '+($scope.mode == 'admin' ? techEnv.token : techEnv.player.token),
                    'X-Jcray-API': 1
                }};
            }
            return {
                'X-Jcray-API': 1
            };
        };

        $scope.currentModule = null;
        console.log('Angular started');
        if (typeof modules == 'undefined') {
            console.log('No modules found. You have to run ```bin/behat modules/``` to generate modules.auto.js');
        } else {
            console.log('Loaded modules:');
            console.log(modules);
        }
        $scope.modules = modules;
        $scope.mode = 'admin';
        $scope.data = {};

        $scope.setCurrentModule = function(name, module) {
            var s = document.createElement("script");
            s.type = "text/javascript";
            s.src = 'assets/modules.auto.js';
            $("head").append(s);
            $scope.renderable = false;
            module.name = name;
            $scope.currentModule = module;
            $scope.renderModule();
        };

        $scope.renderModule = function(silent) {
            $scope.data.module_configuration = {
                admin_controller: $scope.currentModule.admin_controller,
                admin_template: $scope.currentModule.admin_template,
                game_controller: $scope.currentModule.game_controller,
                game_template: $scope.currentModule.game_template
            };
            $scope.data.error = null;
            $http.post('https://'+($scope.mode == 'admin' ? 'api' : techEnv.game.slug)+'.jcray.tech/v8/tech/modules/render', $scope.data, $scope.getDefaultHeaders()).then(function(r){
                if (r.data.error) {
                    $scope.data.error = r.data.error;
                }
                console.log('Received data:');
                console.log(r.data);
                if (typeof silent != 'undefined' && silent) {
                    return;
                }
                while ($scope.currentModule.admin_template.replace('{% button %}', '') != $scope.currentModule.admin_template) {
                    $scope.currentModule.admin_template = $scope.currentModule.admin_template.replace('{% button %}', '<button class="btn" ng-click="post()">');
                }
                while ($scope.currentModule.admin_template.replace('{% endbutton %}', '') != $scope.currentModule.admin_template) {
                    $scope.currentModule.admin_template = $scope.currentModule.admin_template.replace('{% endbutton %}', '</button>');
                }
                while ($scope.currentModule.admin_template.replace('{% block %}', '') != $scope.currentModule.admin_template) {
                    $scope.currentModule.admin_template = $scope.currentModule.admin_template.replace('{% block %}', '<div class="card"><div class="card-content">');
                }
                while ($scope.currentModule.admin_template.replace('{% endblock %}', '') != $scope.currentModule.admin_template) {
                    $scope.currentModule.admin_template = $scope.currentModule.admin_template.replace('{% endblock %}', '</div></div>');
                }
                while ($scope.currentModule.admin_template.replace('{% title %}', '') != $scope.currentModule.admin_template) {
                    $scope.currentModule.admin_template = $scope.currentModule.admin_template.replace('{% title %}', '<div class="card-title">');
                }
                while ($scope.currentModule.admin_template.replace('{% endtitle %}', '') != $scope.currentModule.admin_template) {
                    $scope.currentModule.admin_template = $scope.currentModule.admin_template.replace('{% endtitle %}', '</div>');
                }
                $scope.data = r.data;
                $templateCache.put($scope.mode+$scope.currentModule.name+'Template.html', $scope.mode == 'admin' ? $scope.currentModule.admin_template : $scope.currentModule.game_template);
                $scope.renderable = true;
            }, function(r){
                if (r.data.error) {
                    $scope.data.error = r.data.error;
                    console.log('Error in controller: '+r.data.error.message);
                }
            });
        };

        $scope.post = function() {
            console.log('Sending data');
            console.log($scope.data);
            $scope.renderModule();
        };
        $scope.silentPost = function() {
            console.log('Sending data');
            console.log($scope.data);
            $scope.renderModule(1);
        };

    }
]);
