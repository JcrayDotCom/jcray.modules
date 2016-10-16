Jcray Modules v8
===============

(Working on.)

These modules will be used on [Jcray](http://jcray.com).
All modules files are located in the /modules/ folder.

## Why modules ?
Developing modules directly in a web-ui can be painfull (because Jcray is a game creation system, not an IDE ;). You can use this repo to develop your modules using your
favorite IDE.

## Issues & fixes
Users can submit issues directly in this repository, or submit their fixes using pull requests.

## Modules submission
Users can submit modules using Pull Request.

## Installing PHP libraries (using composer):
Install composer:
``` bash
$ sudo apt-get install composer
```
``` bash
$ composer install
```

## Installing assets:
Install npm and bower:
``` bash
$ sudo apt-get install npm && npm install -g bower
```
Deploying assets:
``` bash
$ bower install
```

## Runing tests
Before using your custom modules, you have to run tests. These tests will generate a "modules.auto.js" file which contains all the modules sources.
Tests are [behat](http://behat.org/en/latest/guides.html) tests.
To run tests:
``` bash
$ bin/behat modules
```

To run tests for a specific module:
``` bash
$ bin/behat modules --tags={ModuleName}
```
or
``` bash
$ bin/behat modules/{ModuleName}
```

## Tests admin and game templates
After running behat tests, go to web/index.html :)

## ReGenerating token and game
For your tests, jcray.tech provider a fake account and a fake game. These are generated on each tests runing.
If you want to manuallay regenerate it (without running tests):
``` bash
$ bin/console jcray:tech:env
```

## Regenerating modules.auto.js
If you just edited a module template, maybe you don't need to wait for all behat tests passing to regenerate the modules.auto.js file (which contains the controller and templates contents). You can use the bin/console executable to regenerate it manually:
``` bash
$ bin/console jcray:modules:autoload
```

## AutoGenerating modules
Some parts of a module is often the same: creation an element, edit it, delete it... It's a bit boring to rewrite these functionnalities just to change one or two words... You can generate a classical creation/edit/remove workflow for a module, using the jcray module generator:
``` bash
$ bin/console jcray:modules:generate
```

More documentation:
- [About Module Generator](https://github.com/JcrayDotCom/jcray.modules/blob/master/doc/ModuleGenerator.md)
- [About Module Generator Recipes](https://github.com/JcrayDotCom/jcray.modules/blob/master/doc/ModuleGeneratorRecipes.md)
- [About Controllers](https://github.com/JcrayDotCom/jcray.modules/blob/master/doc/Controllers.md)
- [About Templates](https://github.com/JcrayDotCom/jcray.modules/blob/master/doc/Templates.md)
- [About Behat tests](https://github.com/JcrayDotCom/jcray.modules/blob/master/doc/BehatTests.md)

## Todo:
- Write tests for untested modules
- Write tests for all game controllers
- Write more recipes parts :)
