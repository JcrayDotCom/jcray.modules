<div class="row card">
    <div class="col s12">
      <ul class="tabs">
        <li class="tab col s3"><a ng-click="currentEditing = 'all'; currentUnit = null">All Units</a></li>
        <li class="tab col s3"><a class="active" ng-click="currentEditing = 'new'">New Unit</a></li>
        <li class="tab col s3"><a ng-click="currentEditing = 'stats'">Stats</a></li>
      </ul>
    </div>
  </div>

<div ng-if="currentEditing == 'new' || (!currentEditing && !data.units.length)">
{% block %}
    {% title %}Create a new unit{% endtitle %}
    <form>
        <input type="text" ng-model="data.newUnit.name" placeholder="Unit name" />
        <input type="text" ng-model="data.newUnit.quantity" placeholder="Unit default quantity" />
        <input type="text" ng-model="data.newUnit.picture" placeholder="Picture (prefixed with http://)" />
        {% button %}Create this new unit{% endbutton %}
    </form>
{% endblock %}
</div>

<div ng-if="currentEditing == 'stats'">
{% block %}
    {% title %}Stats{% endtitle %}
    <ul class="collection">
        <li class="collection-item row" ng-repeat="stat in data.unitStats">
            <span class="col-md-4"><input type="text" ng-model="stat.name" /></span>
            <span class="col-md-4"><input type="text" ng-model="stat.quantity" /></span>
        </li>
        <li class="collection-item">
            <button class="btn" ng-click="post()">Update stats</button>
        </li>
    </ul>
    {% title %}New stat {% endtitle %}
    <input type="text" placeholder="Name of the stat" ng-model="data.newStat.name" />
    <input type="text" placeholder="Default value of the stat" ng-model="data.newStat.quantity" />
    <button class="btn" ng-click="post()">Create this stat</button>
{% endblock %}
</div>

<div ng-if="data.currentUnit && (currentEditing == 'all' || !currentEditing)">
    {% block %}
        {% block %}
        {% title %}Properties of {{ data.currentUnit.name }}{% endtitle %}
        <ul class="collection">
            <li class="row collection-item" ng-repeat="property in data.currentUnit.properties" ng-if="property.name != 'isUnit'">
                <span class="col-md-6">{{ property.name }}</span>
                <span class="col-md-6"><input type="text" ng-model="property.value" /></span>
            </li>
        </ul>
        <button class="btn" ng-click="post()">Save</button>
        {% endblock %}
        {% title %}Edit costs for {{ data.currentUnit.name }}{% endtitle %}
        <ul class="collection">
            <li class="collection-item row" ng-repeat="cost in data.currentUnit.costs">
                <span class="col-md-4">{{ cost.cost.name }}</span>
                <span class="col-md-4">
                    <input type="text" ng-model="cost.quantity" />
                </span>
            </li>
        </ul>
        <button class="btn" ng-click="post()">Update costs</button>
    {% endblock %}
    {% block %}
        {% title %}Edit stats for {{ data.currentUnit.name }}{% endtitle %}
        <ul class="collection">
            <li class="collection-item row" ng-repeat="stat in data.unitStats">
                <span class="col-md-4">{{ stat.name }}</span>
                <span class="col-md-4">
                    <input ng-repeat="property in data.currentUnit.properties" ng-if="property.name == stat.name" type="text" ng-model="property.value" />
                </span>
            </li>
        </ul>
        <button class="btn" ng-click="post()">Update stats</button>
    {% endblock %}
</div>

<div ng-if="!data.currentUnit && ((data.units && data.units.length && currentEditing == 'all') || (!currentEditing && data.units.length))">
    {% block %}
        {% title %}Units of your game{% endtitle %}
        <ul class="collection">
            <li ng-repeat="unit in data.units" class="collection-item row">
                <div class="col-md-3">
                    <label>Name</label>
                    <input type="text" ng-model="unit.name" ng-change="post()" />
                </div>
                <div class="col-md-3" ng-repeat="property in unit.properties" ng-if="property.name == 'picture' || property.name == 'quantity'">
                    <label>{{ property.name }}</label>
                    <input type="text" ng-model="property.value"  ng-change="post()" />
                </div>
                <div class="col-md-3">
                    <button class="btn" ng-click="data.currentUnit = unit">Edit</button>
                </div>
            </li>
        </ul>
    {% endblock %}
</div>
