<!-- Tabs -->
<div ng-init="$parent.tabs = {}; $parent.currentModuleTab=false"></div>

<div class="row card">
    <div class="col s12">
      <ul class="tabs">
        <li class="tab col s3" ng-repeat="(key, tabName) in $parent.tabs">
            <a ng-click="$parent.currentModuleTab = key" ng-class="{active: $parent.currentModuleTab == key}">
                {{ tabName }}
            </a>
        </li>
      </ul>
    </div>
</div>

<div ng-if="data.error">
    <div class="card red">
        <div class="card-content white-text">
            <i class="material-icons">error_outline</i> <span style="position: relative;top: -7px;">{{ data.error.message  }}</span>
        </div>
    </div>
</div>

<div ng-init="$parent.tabs ? $parent.tabs.create = Translator.trans('New Race') : null"></div>

<!-- Create a Race -->
<div ng-show="!$parent.tabs || $parent.currentModuleTab == 'create'">
    {% block %}
        {% title %}{{ "Create a new Race" | trans }}{% endtitle %}
        <form>
            <input type="text" ng-model="data.newRace.name" placeholder="{{ 'Race name' | trans }}" />
            <input type="text" ng-model="data.newRace.description" placeholder="{{ 'Race description' | trans }}" />

            

            <input type="text" ng-model="data.newRace.picture" placeholder="{{ 'Picture (prefixed with http://)' | trans }}" />
            {% button %}{{ "Create this new Race" | trans }}{% endbutton %}
        </form>
    {% endblock %}
</div>

<div ng-init="$parent.tabs ? $parent.tabs.edit = Translator.trans('All races') : null"></div>

<!-- Edit a Race -->
<div ng-show="(!$parent.tabs || $parent.currentModuleTab == 'edit') && data.races && data.races.length">
    {% block %}
        {% title %}{{ "races of your game" | trans }}{% endtitle %}
        <ul class="collection">
            <li class="collection-item">
                <div class="btn pull-right" ng-click="post()"><i class="material-icons">send</i></div>
            </li>
            <li ng-repeat="element in data.races" class="collection-item row">
                <div class="col-md-3">
                    <label>{{ "Name" | trans }}</label>
                    <input type="text" ng-model="element.name" ng-change="post()" />
                </div>
                <div class="col-md-3" ng-repeat="(propertyName, propertyValue) in element.properties" ng-if="propertyName == 'picture' || propertyName == 'quantity'">
                    <label>{{ propertyName | trans }}</label>
                    <input type="text" ng-model="propertyValue" />
                </div>
                <div class="col-md-3">
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;"><!-- Button for edit the stats of the Race -->
<a class="btn-floating btn-tiny waves-effect waves-light blue" ng-click="elementTab = 'stats'+element.id; data.statsElementRace = element"><i class="fa fa-bar-chart"></i></a>
</span>
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;"></span>
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;"></span>
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;"><!-- Delete the Race -->
<a class="btn-floating btn-tiny waves-effect waves-light red" ng-click="data.removeRace = element.name;post();"><i class="tiny material-icons">delete</i></a>
</span>
                </div>
                <div class="clearfix"><!-- Edit the effects of the Race -->
<div ng-if="data.effectsElementRace && elementTab == 'effects'+data.effectsElementRace.id">
    <h4>{{ 'Effects' | trans }}</h4>
    <ul class="collection">
        <li class="collection-item row">
            <div class="col-md-3">
                <label>{{ "Create a new effect" | trans }}</label>
            </div>
            <div class="col-md-3">
                <input type="text" ng-model="data.newEffect.quantity" ng-model="Effect" placeholder="{{ 'Effect quantity' | trans }}" />
            </div>
            <div class="col-md-3">
                <select ng-model="data.newEffect.propertyName" style="display: block">
                    <option disabled selected>( {{ "Select a property" | trans }} )</option>
                    <option ng-repeat="property in data.properties" value="{{ property.name }}" ng-if="property.name != 'picture' && property.name != 'type' && property.name != 'quantity'">
                        {{ property.name }}
                    </option>
                </select>
                <input type="radio" style="position:relative; left: 0px; opacity: 100" model="data.newEffect.type" value="global" /> {{ "Apply evertyime" | trans }}
                <input type="radio"  style="position:relative; left: 0px; opacity: 100" model="data.newEffect.type" value="oneTime" /> {{ "Apply when used" | trans }}
            </div>
            <div class="col-md-3">
                <button ng-click="post()" class="waves-effect waves-light btn"><i class="material-icons">send</i></button>
            </div>
        </li>
        <li>
            <div ng-if="data.effectsElementRace.effects.length">
                <ul class="collection">
                    <li class="row collection-item" ng-repeat="effect in data.effectsElementRace.effects">
                        <span class="col-md-4">{{ effect.property_name }}</span>
                        <span class="col-md-4"><input type="text" ng-model="effect.quantity" /></span>
                        <span class="col-md-4">
                            <a class="btn-floating btn-tiny waves-effect waves-light red" ng-click="data.removeEffectRace = effect;post();"><i class="tiny material-icons">delete</i></a>
                        </span>
                    </li>
                </ul>
                <button class="btn" ng-click="post()">Save</button>
            </div>
        </li>
    </ul>
</div>
</div>
                <div class="clearfix"><!-- Edit the stats of the Race -->
<div ng-if="data.statsElementRace && elementTab == 'stats'+data.statsElementRace.id">

    <ul class="collection">
        <li class="collection-item row">
            <div class="col-md-3">
                <label>{{ "Create a new stat" | trans }}</label>
            </div>
            <div class="col-md-3">
                <input type="text" ng-model="data.newStat.name" placeholder="{{ 'Name of the stat' | trans }}" />
            </div>
            <div class="col-md-3">
                <input type="text" ng-model="data.newStat.quantity" placeholder="{{ 'Default value for this stat' | trans }}" />
            </div>
            <div class="col-md-3">
                <button ng-click="post()" class="waves-effect waves-light btn"><i class="material-icons">send</i></button>
            </div>
        </li>
        <li class="collection-item row" ng-repeat="stat in data.racesStats">
            <div ng-repeat="property in data.statsElementRace.properties" ng-if="property.name == stat.name">
                <div class="col-md-6">
                    <label>{{ property.name }}</label>
                </div/>
                <div class="col-md-6">
                    <input type="text" ng-model="property.value" ng-change="post()" />
                </div>
            </div>
        </li>
    </ul>
</div>
</div>
                <div class="clearfix"><!-- Edit the costs of the Race -->
<div ng-if="data.costsElementRace && elementTab == 'costs'+data.costsElementRace.id">
    Costs
    <ul class="collection">
        <li ng-repeat="cost in data.costsElementRace.costs" class="collection-item row">
            <div class="col-md-6">
                <label>{{ cost.cost.name }}</label/>
            </div>
            <div class="col-md-6">
                <input type="text" ng-change="post()" ng-model="cost.quantity" />
            </div>
        </li>
    </ul>
</div>
</div>
            </li>
            <li class="collection-item">
                <div class="btn pull-right" ng-click="post()"><i class="material-icons">send</i></div>
            </li>
        </ul>
    {% endblock %}
</div>

<div ng-init="$parent.tabs ? $parent.tabs.stats = Translator.trans('Stats') : null"></div>

<div ng-if="!$parent.tabs || $parent.currentModuleTab == 'stats'">
{% block %}
    {% title %}New stat{% endtitle %}
    <input type="text" placeholder="{{ 'Name of the stat' | trans }}" ng-model="data.newStat.name" />
    <input type="text" placeholder="{{ 'Default value of the stat' | trans }}" ng-model="data.newStat.quantity" />
    <button class="btn" ng-click="post()">{{ 'Create this stat' | trans }}</button>
{% endblock %}

<div ng-if="data.racesStats.length">
    {% block %}
        {% title %}{{ "Stats" | trans }}{% endtitle %}
        <ul class="collection">
            <li class="collection-item row" ng-repeat="stat in data.racesStats">
                <span class="col-md-4"><input type="text" ng-model="stat.name" /></span>
                <span class="col-md-4"><input type="text" ng-model="stat.quantity" /></span>
                <span class="col-md-4">
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;">
                        <a class="btn-floating btn-tiny waves-effect waves-light red" ng-click="data.removeRaceStat = stat;post();"><i class="tiny material-icons">delete</i></a>
                    </span>
                </span>
            </li>
            <li class="collection-item">
                <button class="btn" ng-click="post()">{{ "Update stats" | trans }}</button>
            </li>
        </ul>
    {% endblock %}
    </div>
</div>
