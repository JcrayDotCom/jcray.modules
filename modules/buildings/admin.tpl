<!-- Tabs -->
<div ng-init="$parent.tabs = {}; $parent.currentModuleTab=false"></div>

<div class="row card">
    <div class="col s12">
      <ul class="tabs">
        <li class="tab col s3" ng-repeat="(key, tabName) in tabs">
            <a ng-click="$parent.currentModuleTab = key" ng-class="{active: $parent.currentModuleTab == key}">
                {{ tabName }}
            </a>
        </li>
      </ul>
    </div>
</div>

<div ng-init="tabs ? tabs.create = Translator.trans('New Building') : null"></div>

<!-- Create a Building -->
<div ng-show="!tabs || currentModuleTab == 'create'">
    {% block %}
        {% title %}{{ "Create a new Building" | trans }}{% endtitle %}
        <form>
            <input type="text" ng-model="data.newBuilding.name" placeholder="{{ 'Building name' | trans }}" />
            <input type="text" ng-model="data.newBuilding.quantity" placeholder="{{ 'Building default quantity' | trans }}" />
            <input type="text" ng-model="data.newBuilding.picture" placeholder="{{ 'Picture (prefixed with http://)' | trans }}" />
            {% button %}{{ "Create this new Building" | trans }}{% endbutton %}
        </form>
    {% endblock %}
</div>

<div ng-init="tabs ? tabs.edit = Translator.trans('All buildings') : null"></div>

<!-- Edit a Building -->
<div ng-show="(!tabs || currentModuleTab == 'edit') && data.buildings && data.buildings.length">
    {% block %}
        {% title %}{{ "buildings of your game" | trans }}{% endtitle %}
        <ul class="collection">
            <li class="collection-item">
                <div class="btn pull-right" ng-click="post()"><i class="material-icons">send</i></div>
            </li>
            <li ng-repeat="element in data.buildings" class="collection-item row">

                <div class="col-md-3">
                    <label>{{ "Name" | trans }}</label>
                    <input type="text" ng-model="element.name" ng-change="post()" />
                </div>
                <div class="col-md-3" ng-repeat="(propertyName, propertyValue) in element.properties" ng-if="propertyName == 'picture' || propertyName == 'quantity'">
                    <label>{{ propertyName | trans }}</label>
                    <input type="text" ng-model="propertyValue" />
                </div>
                <div class="col-md-3">
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;"></span>
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;"></span>
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;"><!-- Delete the Building -->
<a class="btn-floating btn-tiny waves-effect waves-light red" ng-click="data.removeBuilding = element.name;post();"><i class="tiny material-icons">delete</i></a>
</span>
                </div>
                <div class="clearfix"><!-- Edit the stats of the Building -->
<div ng-if="data.statsElementBuilding && elementTab == 'stats'+data.costsElementBuilding.id">

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
        <li class="collection-item row" ng-repeat="stat in data.buildingsStats">
            <div ng-repeat="property in data.statsElementBuilding.properties" ng-if="property.name == stat.name">
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
                <div class="clearfix"><!-- Edit the costs of the Building -->
<div ng-if="data.costsElementBuilding && elementTab == 'costs'+data.costsElementBuilding.id">
    Costs
    <ul class="collection">
        <li ng-repeat="cost in data.costsElementBuilding.costs" class="collection-item row">
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
