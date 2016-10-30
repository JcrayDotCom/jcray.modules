<div ng-if="data.error">
    <div class="card red">
        <div class="card-content white-text">
            <i class="material-icons">error_outline</i> <span style="position: relative;top: -7px;">{{ data.error }}</span>
        </div>
    </div>
</div>

<!-- List objects of the player -->
<div ng-if="data.playerobjects.length">
    <ul class="collection">
        <li class="collection-item row" ng-repeat="playerElement in data.playerobjects">
            <div class="col-md-4">
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
            <img ng-src="{{ cost.cost.properties.picture }}" width="30" alt="{{ cost.cost.name }}" />
            &nbsp; {{ cost.quantity }}
        </span>
    <li>
</ul>

            </div>
            <div class="col-md-4">
                <div class="row">
                    <div class="col-md-6">
                        <input type="text" placeholder="{{ 'How many to buy?' | trans }}" ng-model="playerElement.data" />
                    </div>
                    <div class="col-md-6">
                        <button class="btn" ng-click="post()">
                            <i class="material-icons">send</i>
                        </button>
                    </div>
                </div>
            </div>

        </li>
    </ul>
</div>
