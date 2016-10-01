<div ng-if="!data.playerRace">
    {% block %}
        {% title %}
            {{ data.introduction }}
        {% endtitle %}
    {% endblock %}
    <div ng-repeat="race in data.races" class="card horizontal">
        <div class="card-image">
            <img ng-repeat="property in race.properties" ng-if="property.name == 'picture'" ng-src="{{ property.value }}" />
        </div>
        <div class="card-content">
            <div class="card-title">
                {{ race.name }}
                <p>{{ race.description }}</p>
                <button class="btn" ng-click="data.chosenRace = race; post()">I want to be a {{ race.name }}!</button>
            </div>
        </div>
    </div>
</div>
<div ng-if="data.playerRace">
    You are a {{ data.playerRace.name }}
</div>
