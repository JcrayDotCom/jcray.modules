{% block %}
    {% title %}Page d'introduction{% endtitle %}
    <textarea placeholder="Texte d'ambiance: choisissez votre race, etc." ng-model="data.introduction" ng-repeat="property in module.properties" ng-if="property.name='introduction'">
    </textarea>
    <button class="btn" ng-click="post()">Update</button>
{% endblock %}

{% block %}
    {% title %}New race{% endtitle %}
    <input type="text" ng-model="data.newRace.name" placeholder="Name of the race" />
    <input type="text" ng-model="data.newRace.picture" placeholder="Picture of the race" />
    <textarea placeholder="Description of this race" ng-model="data.newRace.description"></textarea>
    <button class="btn" ng-click="post()">Create this race</button>
{% endblock %}

<div ng-if="data.races.length">
{% block %}
    <button class="btn pull-right" ng-click="post()">Update</button>
    {% title %}Races{% endtitle %}
    <ul class="collection">
        <li ng-repeat="race in data.races">
            <div class="row">
                <div class="col-md-4">
                    <label>Name</label>
                    <input type="text" ng-model="race.name" />
                </div>
                <div class="col-md-4">
                    <label>Picture</label>
                    <input ng-repeat="property in race.properties" ng-if="property.name=='picture'" type="text" ng-model="property.value" />
                </div>
                <div class="col-md-4">
                    <label>Description</label>
                    <textarea ng-repeat="property in race.properties" ng-if="property.name=='description'" ng-model="property.value" ng-bind="property.value"></textarea>
                </div>
            </div>
        </li>
    </ul>
    <button class="btn pull-right" ng-click="post()">Update</button>
    <div class="clear"></div>
{% endblock %}
</div>
