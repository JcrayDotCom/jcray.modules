var jcrayApp = angular.module('jcrayApp', [
    'jcrayTech'
]);

var jcrayTech = angular.module('jcrayTech', []);

jcrayApp.controller('appCtrl', ['$scope',
    function ($scope) {
        console.log('Angular started');
        if (typeof modules == 'undefined') {
            console.log('No modules found. You have to run ```bin/behat modules/``` to generate modules.auto.js');
        } else {
            console.log('Loaded modules:');
            console.log(modules);
        }
    }
]);
