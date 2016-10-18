<!-- List buildings of the player -->
<div ng-if="data.buildings.length">
    <div class="chip" ng-repeat="playerElement in data.playerElements">
        <img ng-repeat="property in playerElement.element.properties" ng-if="property.name == 'picture'" ng-src="{{ property.value }}" alt="{{ element.name }}">
        <span ng-repeat="property in playerElement.properties" ng-if="property.name == 'quantity'">
            {{ property.value }}
        </span>
    </div>
</div>
