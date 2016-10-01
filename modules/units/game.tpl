<div ng-if="!data.player">
    Discover my wonderful game and a lot of units:
    <ul class="collection">
        <li class="collection-item" ng-repeat="unit in data.units">
            {{ unit.name }}
        </li>
    </ul>
</div>

<div ng-if="data.player">
    <div ng-if="data.error" class="alert alert-danger">
        <a class="close" data-dismiss="alert">&times;</a>
        <strong>Error:</strong> {{ data.error }}
    </div>
    <div class="card horizontal" ng-repeat="unit in data.playerElements">
        <div class="card-image">
            <img ng-repeat="property in unit.properties" ng-if="property.name == 'picture'" ng-src="{{ property.value }}" />
        </div>
        <div class="card-title">
            {{ unit.element.name }}
            <span ng-repeat="property in unit.properties" ng-if="property.name == 'quantity'">({{ property.value }})</span>
        </div>
        <div class="card-content">
            <div class="row">
                <div class="col-md-4">
                    <div ng-repeat="cost in unit.element.costs">
                        <img ng-repeat="costProperty in cost.cost.properties" ng-if="costProperty.name == 'picture'" ng-src="{{ costProperty.value }}" />
                        {{ cost.quantity }}
                    </div>
                </div>
                <div class="col-md-4">
                    <label>Want more?</label>
                    <input type="text" ng-model="unit.data" />
                </div>
                <div class="col-md-4">
                    <button class="btn" ng-click="post()">Recruit!</button>
                </div>
            </div>
        </div>
    </div>
</div>
