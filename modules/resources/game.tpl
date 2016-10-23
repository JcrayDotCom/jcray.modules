<!-- List resources of the player -->
<div ng-if="data.resources.length">
    <div class="chip" ng-repeat="playerElement in data.playerElements">
        <img ng-src="{{ playerElement.element.properties.picture }}" alt="{{ playerElement.element.name }}">
        <span>
            {{ playerElement.properties.quantity }}
        </span>
    </div>
</div>
