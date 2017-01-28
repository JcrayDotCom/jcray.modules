<!-- Tabs -->
<div ng-if="data.error">
    <div class="card red">
        <div class="card-content white-text">
            <i class="material-icons">error_outline</i> <span style="position: relative;top: -7px;">{{ data.error.message | trans  }}</span>
        </div>
    </div>
</div>

<!-- List elements-->
<div ng-show="!tabs || currentModuleTab == 'create' || (!data.buildings.length && !currentModuleTab)">
    {% block %}
        {% title %}{{ "Rank players by" | trans }}...{% endtitle %}
        <ul ng-repeat="element in elements" class="collection row">
            <li class="collection-item">
                <div class="col-md-6">
                    {{ element.name }} <i>({{ element.type | trans }})</i>
                </div>
                <div class="col-md-6">
                    <input type="checkbox" ng-model="{{ element.ranking }}" ng-change="silentPost()" />
                </div>
            </li>
        </ul>
    {% endblock %}
</div>
