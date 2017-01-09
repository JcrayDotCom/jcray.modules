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

<div ng-init="tabs ? tabs.create = 'New Object' : null"></div>

<!-- Create a Object -->
<div ng-show="!tabs || currentModuleTab == 'create' || (!data.objects.length && !currentModuleTab)">
    {% block %}
        {% title %}{{ "Create a new Object" | trans }}{% endtitle %}
        <form>
            <input type="text" ng-model="data.newObject.name" placeholder="{{ 'Object name' | trans }}" />
            <input type="text" ng-model="data.newObject.description" placeholder="{{ 'Object description' | trans }}" />

            <input type="text" ng-model="data.newObject.quantity" placeholder="{{ 'Object default quantity' | trans }}" />


            <input type="text" ng-model="data.newObject.picture" placeholder="{{ 'Picture (prefixed with http://)' | trans }}" />
            {% button %}{{ "Create this new Object" | trans }}{% endbutton %}
        </form>
    {% endblock %}
</div>

<div ng-init="tabs ? tabs.edit = 'All objects' : null"></div>

<!-- Edit a Object -->
<div ng-show="(!tabs || currentModuleTab == 'edit' || (data.objects.length && !currentModuleTab)) && data.objects && data.objects.length">
    {% block %}
        {% title %}{{ "objects of your game" | trans | ucfirst }}{% endtitle %}
        <ul class="collection">
            <li ng-repeat="element in data.objects" class="collection-item row">
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
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;"><!-- Button for edit the costs of the Object -->
<a class="btn-floating btn-tiny waves-effect waves-light green" ng-click="elementTab = 'costs'+element.id; data.costsElementObject = element"><i class="fa fa-money"></i></a>
</span>
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;"><!-- Button for edit the effects of the Object -->
<a class="btn-floating btn-tiny waves-effect waves-light green" ng-click="elementTab = 'effects'+element.id; data.effectsElementObject  = element"><i class="fa fa-asterisk"></i></a>
</span>
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;"><!-- Button for edit the requirements of the Object -->
<a
    class="btn-floating btn-tiny waves-effect waves-light green"
    ng-click="elementTab = 'requirements'+element.id; data.requirementsElementObject = element"
>
        <i class="fa fa-check-circle-o"></i>
</a>
</span>
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;"><!-- Delete the Object -->
<a class="btn-floating btn-tiny waves-effect waves-light red" ng-click="data.removeObject = element.name;post();"><i class="tiny material-icons">delete</i></a>
</span>
                </div>
                <div class="clearfix"><!-- Edit the effects of the Object -->
<div ng-if="data.effectsElementObject && elementTab == 'effects'+data.effectsElementObject.id">
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
            <div ng-if="data.effectsElementObject.effects.length">
                <ul class="collection">
                    <li class="row collection-item" ng-repeat="effect in data.effectsElementObject.effects">
                        <span class="col-md-4">{{ effect.property_name }}</span>
                        <span class="col-md-4"><input type="text" ng-model="effect.quantity" /></span>
                        <span class="col-md-4">
                            <a class="btn-floating btn-tiny waves-effect waves-light red" ng-click="data.removeEffectObject = effect;post();"><i class="tiny material-icons">delete</i></a>
                        </span>
                    </li>
                </ul>
                <button class="btn" ng-click="post()">Save</button>
            </div>
        </li>
    </ul>
</div>
</div>
                <div class="clearfix"><!-- Edit the stats of the Object -->
<div ng-if="data.statsElementObject && elementTab == 'stats'+data.statsElementObject.id">

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
        <li class="collection-item row" ng-repeat="stat in data.objectsStats">
            <div ng-repeat="(propertyName, propertyValue) in data.statsElementObject.properties" ng-if="propertyName == stat.name">
                <div class="col-md-6">
                    <label>{{ propertyName }}</label>
                </div/>
                <div class="col-md-6">
                    <input type="text" ng-model="data.statsElementObject.properties[propertyName]" ng-change="silentPost()" />
                </div>
            </div>
        </li>
    </ul>
</div>
</div>
                <div class="clearfix"><!-- Edit the costs of the Object -->
<div ng-if="data.costsElementObject && elementTab == 'costs'+data.costsElementObject.id">
    {{ 'Costs' | trans }}
    <ul class="collection">
        <li ng-repeat="cost in data.costsElementObject.costs" class="collection-item row">
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
                <div class="clearfix"><!-- Edit the requirements of the Object -->
<div ng-if="data.requirementsElementObject && elementTab == 'requirements'+data.requirementsElementObject.id">
    <h4>{{ 'Requirements' | trans }}</h4>
    <ul class="collection">
        <li class="collection-item row" ng-repeat="item in data.requirableElements" ng-if="item.id != data.requirementsElementObject.id">
            <div class="col-md-2" ng-if="item.properties.picture">
                <img src="{{ item.properties.picture }}" alt="{{ item.name }}" width="64" />
            </div>
            <div class="col-md-5">
                <label>{{ item.name }} <i>({{ item.properties.type | trans }})</i></label/>
            </div>
            <div class="col-md-5">
                <input ng-repeat="requirement in data.requirementsElementObject.requirements" ng-if="requirement.required_element.id == item.id" alt="{{ 'ratio' | trans}}" type="text" ng-model="requirement.ratio" ng-change="silentPost()" />
            </div>
        </li>
    </ul>
</div>
</div>
            </li>
        </ul>
    {% endblock %}
</div>
