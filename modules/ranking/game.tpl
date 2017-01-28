<!-- List players by rank -->
<div class="card horizontal">
    <div class="card-content">
        <div class="card-title">{{ 'ranking' | trans | ucfirst }}</div>
            <table>
                <tr ng-repeat="player in data.players">
                    <td>{{ data.startRank + $index }}</td>
                    <td>{{ player.pseudo }}</td>
                </tr>
            </table>
        </div>
    </div>
</div>

<div class="card horizontal" ng-if="data.previousPage ||  data.nextPage">
    <div class="card-content">
        <div class="row">
            <div class="col-md-6" ng-if="data.previousPage">
                <a href="" ng-click="data.page = data.previousPage; silentPost(); return false"><< {{ 'Previous' | trans }}</a>
            </div>
            <div class="col-md-6" ng-if="data.nextPage">
                <a href="" ng-click="data.page = data.nextPage; silentPost(); return false">{{ 'Next' | trans }} >></a>
            </div>
        </div>
    </div>
</div>
