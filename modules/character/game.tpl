{% block %}
    {% title %}{{ player.pseudo }}{% endtitle %}
    <ul class="collection">
        <li class="collection-item">
            Level:
            <span ng-repeat="property in player.properties" ng-if="property.name=='level'">
                {{ property.value }}
            </span>
        </li>

        <li class="collection-item">
            Xp:
            <span ng-repeat="property in player.properties" ng-if="property.name=='xp'">
                {{ property.value }}
            </span>
        </li>
        <li class="collection-item" ng-repeat="playerElement in data.filters">
            {{ filter.property_name }}
            <span ng-repeat="property in player.properties" ng-if="property.name == filter.property_name">
                {{ property.value }}
            </span>
        </li>
    </ul>
{% endblock %}
