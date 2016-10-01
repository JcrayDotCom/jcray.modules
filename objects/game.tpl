<div class="card horizontal" ng-repeat="object in data.playerObjects">
    <div class="card-image">
        <img ng-repeat="property in object.element.properties" ng-if="property.name == 'picture'" ng-src="{{ property.value }}">
    </div>
    <div class="card-content">
        <div class="card-title">
            {{ object.element.name }}
            <span ng-repeat="property in object.properties" ng-if="property.name == 'quantity'">
                ({{ property.value }})
            </span>
        </div>
        <div class="row">
            <div class="col-md-4">
                Effects: <br />
                <div ng-repeat="effect in object.element.effects">
                    <span ng-if="effect.quantity > 0">+</span> {{ effect.quantity }}
                    {{ effect.property_name }}
                </div>
                <button class="btn" ng-click="data.currentObject = object; post()">Use it!</button>
            </div>
            <div class="col-md-4">
                <input type="text"  ng-model="object.data" placeholder="Quantity to buy" />
            </div>
            <div class="col-md-4">
                <button class="btn" ng-click="post()">Buy!</button>
            </div>
        </div>
    </div>
</div>
