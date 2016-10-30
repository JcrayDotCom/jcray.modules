<!-- Tabs -->
<div ng-init="tabs = {}; currentModuleTab=false"></div>

<div class="row card">
    <div class="col s12">
      <ul class="tabs">
        <li class="tab col s3" ng-repeat="(key, tabName) in tabs">
            <a ng-click="$parent.currentModuleTab = key" ng-class="{active: currentModuleTab == key}">
                {{ tabName | trans }}
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

<div ng-init="tabs ? tabs.create = 'New Unit' : null"></div>

<!-- Create a Unit -->
<div ng-show="!tabs || currentModuleTab == 'create' || (!data.units.length && !currentModuleTab)">
    {% block %}
        {% title %}{{ "Create a new Unit" | trans }}{% endtitle %}
        <form>
            <input type="text" ng-model="data.newUnit.name" placeholder="{{ 'Unit name' | trans }}" />
            <input type="text" ng-model="data.newUnit.description" placeholder="{{ 'Unit description' | trans }}" />

            <input type="text" ng-model="data.newUnit.quantity" placeholder="{{ 'Unit default quantity' | trans }}" />


            <input type="text" ng-model="data.newUnit.picture" placeholder="{{ 'Picture (prefixed with http://)' | trans }}" />
            {% button %}{{ "Create this new Unit" | trans }}{% endbutton %}
        </form>
    {% endblock %}
</div>

<div ng-init="tabs ? tabs.edit = 'All units' : null"></div>

<!-- Edit a Unit -->
<div ng-show="(!tabs || currentModuleTab == 'edit' || (data.units.length && !currentModuleTab)) && data.units && data.units.length">
    {% block %}
        {% title %}{{ "units of your game" | trans | ucfirst }}{% endtitle %}
        <ul class="collection">
            <li ng-repeat="element in data.units" class="collection-item row">
                <div class="col-md-3">
                    <label>{{ "Name" | trans }}</label>
                    <input type="text" ng-model="element.name" ng-change="silentPost()" />
                </div>
                <div class="col-md-3" ng-repeat="(propertyName, propertyValue) in element.properties" ng-if="propertyName == 'picture' || propertyName == 'quantity'">
                    <label>{{ propertyName | trans }}</label>
                    <input type="text" ng-model="element.properties[propertyName]" ng-change="silentPost()"/>
                </div>
                <div class="col-md-3">
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;"><!-- Button for edit the stats of the Unit -->
<a class="btn-floating btn-tiny waves-effect waves-light blue" ng-click="elementTab = 'stats'+element.id; data.statsElementUnit = element"><i class="fa fa-bar-chart"></i></a>
</span>
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;"><!-- Button for edit the costs of the Unit -->
<a class="btn-floating btn-tiny waves-effect waves-light green" ng-click="elementTab = 'costs'+element.id; data.costsElementUnit = element"><i class="fa fa-money"></i></a>
</span>
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;"></span>
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;"><!-- Delete the Unit -->
<a class="btn-floating btn-tiny waves-effect waves-light red" ng-click="data.removeUnit = element.name;post();"><i class="tiny material-icons">delete</i></a>
</span>
                </div>
                <div class="clearfix"></div>
                <div class="clearfix"><!-- Edit the stats of the Unit -->
<div ng-if="data.statsElementUnit && elementTab == 'stats'+data.statsElementUnit.id">

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
        <li class="collection-item row" ng-repeat="stat in data.unitsStats">
            <div ng-repeat="(propertyName, propertyValue) in data.statsElementUnit.properties" ng-if="propertyName == stat.name">
                <div class="col-md-6">
                    <label>{{ propertyName }}</label>
                </div/>
                <div class="col-md-6">
                    <input type="text" ng-model="data.statsElementUnit.properties[propertyName]" ng-change="silentPost()" />
                </div>
            </div>
        </li>
    </ul>
</div>
</div>
                <div class="clearfix"><!-- Edit the costs of the Unit -->
<div ng-if="data.costsElementUnit && elementTab == 'costs'+data.costsElementUnit.id">
    {{ 'Costs' | trans }}
    <ul class="collection">
        <li ng-repeat="cost in data.costsElementUnit.costs" class="collection-item row">
            <div class="col-md-6">
                <label>{{ cost.cost.name }}</label/>
            </div>
            <div class="col-md-6">
                <input type="text" ng-model="cost.quantity" ng-change="silentPost()" />
            </div>
        </li>
    </ul>
</div>
</div>
            </li>
        </ul>
    {% endblock %}
</div>

<div ng-init="tabs ? tabs.stats = 'Stats' : null"></div>

<div ng-if="!tabs || currentModuleTab == 'stats'">
{% block %}
    {% title %}{{ 'New stat' | trans }}{% endtitle %}
    <input type="text" placeholder="{{ 'Name of the stat' | trans }}" ng-model="data.newStat.name" />
    <input type="text" placeholder="{{ 'Default value of the stat' | trans }}" ng-model="data.newStat.quantity" />
    <button class="btn" ng-click="post()">{{ 'Create this stat' | trans }}</button>
{% endblock %}

<div ng-if="data.unitsStats.length">
    {% block %}
        {% title %}{{ "Stats" | trans }}{% endtitle %}
        <ul class="collection">
            <li class="collection-item row" ng-repeat="stat in data.unitsStats">
                <span class="col-md-4"><input type="text" ng-model="stat.name" ng-change="silentPost()" /></span>
                <span class="col-md-4"><input type="text" ng-model="stat.quantity" ng-change="silentPost()" /></span>
                <span class="col-md-4">
                    <span class="pull-right" style="margin-right: 10px;margin-top: 10px;">
                        <a class="btn-floating btn-tiny waves-effect waves-light red" ng-click="data.removeUnitStat = stat;post();"><i class="tiny material-icons">delete</i></a>
                    </span>
                </span>
            </li>
        </ul>
    {% endblock %}
    </div>
</div>
