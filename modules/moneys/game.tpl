<div ng-if="data.moneys.length">
    <div class="chip" ng-repeat="money in data.moneys">
        <img ng-repeat="property in money.properties" ng-if="property.name == 'picture'" ng-src="{{ property.value }}" alt="{{ money.name }}">
        <span ng-repeat="property in money.properties" ng-if="property.name == 'quantity'">
            {{ property.value }}
        </span>
    </div>
</div>
<div ng-if="!data.moneys.length && data.defaultMoneys.length">
    You can earn a lot of these moneys:
    <div class="chip" ng-repeat="money in data.defaultMoneys">
        <img ng-repeat="property in money.properties" ng-if="property.name == 'picture'" ng-src="{{ property.value }}" alt="{{ money.name }}">
        <span ng-repeat="property in money.properties" ng-if="property.name == 'quantity'">
            {{ property.value }}
        </span>
    </div>
</div>
