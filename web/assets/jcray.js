var jcrayApp = angular.module('jcrayApp', [
    'jcrayTech',
    'ngCookies'
]);

var jcrayTech = angular.module('jcrayTech', ['ngCookies']);

jcrayApp.controller('appCtrl', ['$scope', '$templateCache', '$http', '$cookies',
    function ($scope, $templateCache, $http, $cookies) {
        $scope.bearer;
        console.log('Waiting for credentials...');
        if ($cookies.get('bearer')) {
            $scope.bearer = $cookies.get('bearer');

        }
        $scope.bearer = techEnv.token;
        $cookies.put('bearer', $scope.bearer );
        
        $scope.getDefaultHeaders = function(){
            if ($scope.bearer) {
                return {'headers': {
                    'Authorization': 'Bearer '+$scope.bearer,
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

        $scope.renderModule = function() {

            $scope.data.module_configuration = {
                admin_controller: $scope.currentModule.admin_controller,
                admin_template: $scope.currentModule.admin_template,
                game_controller: $scope.currentModule.game_controller,
                game_template: $scope.currentModule.game_template
            };
            $scope.data.error = null;
            $http.post('http://api.jcray.tech/v8/modules/tech/render', $scope.data, $scope.getDefaultHeaders()).then(function(r){
                if (r.data.error) {
                    $scope.data.error = r.data.error;
                }
                console.log('Received data:');
                console.log(r.data);
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
                $templateCache.put($scope.mode+$scope.currentModule.name+'Template.html', $scope.currentModule.admin_template);
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

    }
]);
