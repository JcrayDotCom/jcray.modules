{% block %}
    {% title %}Create a new money{% endtitle %}
    <form>
        <input type="text" ng-model="data.newMoney.name" placeholder="Money name" />
        <input type="text" ng-model="data.newMoney.quantity" placeholder="Money default quantity" />
        <input type="text" ng-model="data.newMoney.picture" placeholder="Picture (prefixed with http://)" />
        {% button %}Create this new money{% endbutton %}
    </form>
{% endblock %}

<div ng-if="data.moneys && data.moneys.length">
    {% block %}
        {% title %}Moneys of your game{% endtitle %}
        <ul class="collection">
            <li ng-repeat="money in data.moneys" class="collection-item row">
                <div class="col-md-4">
                    <label>Name</label>
                    <input type="text" ng-model="money.name" ng-change="post()" />
                </div>
                <div class="col-md-4" ng-repeat="property in money.properties" ng-if="property.name == 'picture' || property.name == 'quantity'">
                    <label>{{ property.name }}</label>
                    <input type="text" ng-model="property.value"  ng-change="post()" />
                </div>
            </li>
        </ul>
    {% endblock %}
</div>
