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

<div ng-init="tabs ? tabs.create = 'New ' : null"></div>

<!-- Create a  -->
<div ng-show="!tabs || currentModuleTab == 'create' || (!data..length && !currentModuleTab)">
    {% block %}
        {% title %}{{ "Create a new " | trans }}{% endtitle %}
        <form>
            <input type="text" ng-model="data.new.name" placeholder="{{ ' name' | trans }}" />
            <input type="text" ng-model="data.new.description" placeholder="{{ ' description' | trans }}" />

            <input type="text" ng-model="data.new.quantity" placeholder="{{ ' default quantity' | trans }}" />


            <input type="text" ng-model="data.new.picture" placeholder="{{ 'Picture (prefixed with http://)' | trans }}" />
            {% button %}{{ "Create this new " | trans }}{% endbutton %}
        </form>
    {% endblock %}
</div>

<div ng-init="tabs ? tabs.edit = 'All ' : null"></div>

<!-- Edit a  -->
<div ng-show="(!tabs || currentModuleTab == 'edit' || (data..length && !currentModuleTab)) && data. && data..length">
    {% block %}
        {% title %}{{ " of your game" | trans | ucfirst }}{% endtitle %}
        <ul class="collection">
            <li ng-repeat="element in data." class="collection-item row">
                <div class="col-md-3">
                    <label>{{ "Name" | trans }}</label>
                    <input type="text" ng-model="element.name" ng-change="silentPost()" />
                </div>
                <div class="col-md-3" ng-repeat="(propertyName, propertyValue) in element.properties" ng-if="propertyName == 'picture' || propertyName == 'quantity'">
                    <label>{{ propertyName | trans }}</label>
                    <input type="text" ng-model="element.properties[propertyName]" ng-change="silentPost()"/>
                </div>
                <div class="col-md-3">
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;"></span>
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;"><!-- Button for edit the costs of the  -->
<a class="btn-floating btn-tiny waves-effect waves-light green" ng-click="elementTab = 'costs'+element.id; data.costsElement = element"><i class="fa fa-money"></i></a>
</span>
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;"></span>
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;"><!-- Delete the  -->
<a class="btn-floating btn-tiny waves-effect waves-light red" ng-click="data.remove = element.name;post();"><i class="tiny material-icons">delete</i></a>
</span>
                </div>
                <div class="clearfix"><!-- Edit the effects of the  -->
<div ng-if="data.effectsElement && elementTab == 'effects'+data.effectsElement.id">
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
            <div ng-if="data.effectsElement.effects.length">
                <ul class="collection">
                    <li class="row collection-item" ng-repeat="effect in data.effectsElement.effects">
                        <span class="col-md-4">{{ effect.property_name }}</span>
                        <span class="col-md-4"><input type="text" ng-model="effect.quantity" /></span>
                        <span class="col-md-4">
                            <a class="btn-floating btn-tiny waves-effect waves-light red" ng-click="data.removeEffect = effect;post();"><i class="tiny material-icons">delete</i></a>
                        </span>
                    </li>
                </ul>
                <button class="btn" ng-click="post()">Save</button>
            </div>
        </li>
    </ul>
</div>
</div>
                <div class="clearfix"><!-- Edit the stats of the  -->
<div ng-if="data.statsElement && elementTab == 'stats'+data.statsElement.id">

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
        <li class="collection-item row" ng-repeat="stat in data.Stats">
            <div ng-repeat="(propertyName, propertyValue) in data.statsElement.properties" ng-if="propertyName == stat.name">
                <div class="col-md-6">
                    <label>{{ propertyName }}</label>
                </div/>
                <div class="col-md-6">
                    <input type="text" ng-model="data.statsElement.properties[propertyName]" ng-change="silentPost()" />
                </div>
            </div>
        </li>
    </ul>
</div>
</div>
                <div class="clearfix"><!-- Edit the costs of the  -->
<div ng-if="data.costsElement && elementTab == 'costs'+data.costsElement.id">
    {{ 'Costs' | trans }}
    <ul class="collection">
        <li ng-repeat="cost in data.costsElement.costs" class="collection-item row">
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
