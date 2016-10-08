<!-- Create a Animal -->
{% block %}
    {% title %}Create a new Animal {% endtitle %}
    <form>
        <input type="text" ng-model="data.Animal.name" placeholder="Animal name" />
        <input type="text" ng-model="data.Animal.quantity" placeholder="Animal default quantity" />
        <input type="text" ng-model="data.Animal.picture" placeholder="Picture (prefixed with http://)" />
        {% button %}Create this new Animal{% endbutton %}
    </form>
{% endblock %}

<!-- Edit a Animal -->
<div ng-if="data.animals && data.animals.length">
    {% block %}
        {% title %}animals of your game{% endtitle %}
        <ul class="collection">
            <li ng-repeat="element in data.animals" class="collection-item row">
                <div class="col-md-4">
                    <label>Name</label>
                    <input type="text" ng-model="element.name" ng-change="post()" />
                </div>
                <div class="col-md-4" ng-repeat="property in element.properties" ng-if="property.name == 'picture' || property.name == 'quantity'">
                    <label>{{ property.name }}</label>
                    <input type="text" ng-model="property.value" ng-change="post()" />
                </div>
            </li>
        </ul>
    {% endblock %}
</div>
