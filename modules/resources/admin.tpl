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

<div ng-init="tabs ? tabs.create = 'New Resource' : null"></div>

<!-- Create a Resource -->
<div ng-show="!tabs || currentModuleTab == 'create'">
    {% block %}
        {% title %}Create a new Resource {% endtitle %}
        <form>
            <input type="text" ng-model="data.newResource.name" placeholder="Resource name" />
            <input type="text" ng-model="data.newResource.quantity" placeholder="Resource default quantity" />
            <input type="text" ng-model="data.newResource.picture" placeholder="Picture (prefixed with http://)" />
            {% button %}Create this new Resource{% endbutton %}
        </form>
    {% endblock %}
</div>

<div ng-init="tabs ? tabs.edit = 'All resources' : null"></div>

<!-- Edit a Resource -->
<div ng-show="(!tabs || currentModuleTab == 'edit') && data.resources && data.resources.length">
    {% block %}
        {% title %}resources of your game{% endtitle %}
        <ul class="collection">
            <li class="collection-item">
                <div class="btn pull-right" ng-click="post()"><i class="material-icons">send</i></div>
            </li>
            <li ng-repeat="element in data.resources" class="collection-item row">

                <div class="col-md-3">
                    <label>Name</label>
                    <input type="text" ng-model="element.name" ng-change="post()" />
                </div>
                <div class="col-md-3" ng-repeat="(propertyName, propertyValue) in element.properties" ng-if="propertyName == 'picture' || propertyName == 'quantity'">
                    <label>{{ propertyName }}</label>
                    <input type="text" ng-model="propertyValue" />
                </div>
                <div class="col-md-3">
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;"></span>
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;"></span>
                    <span class="pull-right" style="margin-right: 10px;margin-top: 25px;"><!-- Delete the Resource -->
<a class="btn-floating btn-tiny waves-effect waves-light red" ng-click="data.removeResource = element.name;post();"><i class="tiny material-icons">delete</i></a>
</span>
                </div>
                <div class="clearfix"><!-- Edit the stats of the Resource -->
<div ng-if="data.statsElementResource && elementTab == 'stats'+data.costsElementResource.id">

    <ul class="collection">
        <li class="collection-item row">
            <div class="col-md-3">
                <label>Create a new stat</label>
            </div>
            <div class="col-md-3">
                <input type="text" ng-model="data.newStat.name" placeholder="Name of the stat" />
            </div>
            <div class="col-md-3">
                <input type="text" ng-model="data.newStat.quantity" placeholder="Default value for this stat" />
            </div>
            <div class="col-md-3">
                <button ng-click="post()" class="waves-effect waves-light btn"><i class="material-icons">send</i></button>
            </div>
        </li>
        <li class="collection-item row" ng-repeat="stat in data.resourcesStats">
            <div ng-repeat="property in data.statsElementResource.properties" ng-if="property.name == stat.name">
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
                <div class="clearfix"><!-- Edit the costs of the Resource -->
<div ng-if="data.costsElementResource && elementTab == 'costs'+data.costsElementResource.id">
    Costs
    <ul class="collection">
        <li ng-repeat="cost in data.costsElementResource.costs" class="collection-item row">
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
