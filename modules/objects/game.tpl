<!-- List objects of the player -->
<div ng-if="data.playerobjects.length">
    <ul class="collection">
        <li class="collection-item row" ng-repeat="playerElement in data.playerobjects">
            <div class="col-md-1">
                <img ng-src="{{ playerElement.element.properties.picture }}" alt="{{ playerElement.element.name }}">
            </div>
            <div class="col-md-4">
                <h5>{{ playerElement.element.name }} <small>x{{ playerElement.properties.quantity }}</small></h5>
                <!-- Stats for the playerElement -->
<ul class="collection row">
    <li ng-repeat="stat in data.objectsStats">
        <span class="col-md-6">{{ stat.name }}</span>
        <span class="col-md-6" ng-repeat="(propertyName, propertyValue) in playerElement.properties" ng-if="propertyName == stat.name">{{ propertyValue }}</span>
    <li>
</ul>

                <!-- Costs for the playerElement -->
<ul class="collection row">
    <li>
        <span ng-repeat="cost in playerElement.element.costs" class="pull-left">
            <span class="col-md-6"><img ng-src="{{ cost.cost.properties.picture }}" width="30" alt="{{ cost.cost.name }}" /></span>
            <span class="col-md-6">{{ cost.quantity }}</span>
        </span>
    <li>
</ul>

            </div>
            <div class="col-md-4">
                <input type="text" placeholder="{{ 'How many to buy?' | trans }}'" ng-model="playerElement.data" />
            </div>
            <div class="col-md-1">
                <button class="btn" ng-click="post()">
                    <i class="material-icons">send</i>
                </button>
            </div>
        </li>
    </ul>
</div>
