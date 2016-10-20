<div class="row card">
    <div class="col s12">
      <ul class="tabs">
        <li class="tab col s3"><a ng-click="currentTab = 'all'; currentObject = null">All Objects</a></li>
        <li class="tab col s3"><a class="active" ng-click="currentTab = 'new'">New Object</a></li>
      </ul>
    </div>
</div>

<div ng-if="currentTab == 'new' || (!data.objects.length && !currentTab)">
    {% block %}
        {% title %}New object{% endtitle %}
        <input type="text" placeholder="Name of the object" ng-model="data.newObject.name" />
        <input type="text" placeholder="Picture of the object" ng-model="data.newObject.picture" />
        <button class="btn" ng-click="post()">Create this object</button>
    {% endblock %}
</div>

<div ng-if="currentTab == 'all' || (!data.currentObject && data.objects.length && !currentTab)">
    {% block %}
    <ul class="collection">
        <li class="collection-item clear row" ng-repeat="object in data.objects">
            <span class="col-md-6">{{ object.name }}</span>
            <span class="col-md-6">
                <button class="btn" ng-click="data.currentObject = object">Edit</button>
            </span>
        </li>
    </ul>
    <div class="clear"></div>
    {% endblock %}
</div>

<div ng-if="data.currentObject && (currentTab == 'all' || !currentTab)">
    {% block %}
        {% title %}Properties of {{ data.currentObject.name }}{% endtitle %}
        <ul class="collection">
            <li class="row collection-item" ng-repeat="property in data.currentObject.properties" ng-if="property.name != 'isObject'">
                <span class="col-md-6">{{ property.name }}</span>
                <span class="col-md-6"><input type="text" ng-model="property.value" /></span>
            </li>
        </ul>
        <button class="btn" ng-click="post()">Save</button>
    {% endblock %}
    {% block %}
        <div ng-if="data.currentObject.effects.length">
            {% title %}Effects of {{ data.currentObject.name }}{% endtitle %}
            <ul class="collection">
                <li class="row collection-item" ng-repeat="effect in data.currentObject.effects">
                    <span class="col-md-6">{{ effect.property_name }}</span>
                    <span class="col-md-6"><input type="text" ng-model="effect.quantity" /></span>
                </li>
            </ul>
            <button class="btn" ng-click="post()">Save</button>
        </div>
    {% endblock %}
    {% block %}
        {% title %}New effect{% endtitle %}
        <select ng-model="data.newEffect.propertyName">
            <option disabled selected>( Select a property )</option>
            <option ng-repeat="property in data.properties" value="{{ property.name }}">
                {{ property.name }}
            </option>
        </select>
        <input type="text" ng-model="data.newEffect.quantity" ng-model="Effect" />
        <button class="btn" ng-click="post()">Create effect</button>
    {% endblock %}
</div>
