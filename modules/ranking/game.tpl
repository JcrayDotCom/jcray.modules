<!-- List players by rank -->
<table>
    <tr ng-repeat="player in data.players">
        <td>{{ data.startRank + $index }}</td>
        <td>{{ player.pseudo }}</td>
    </tr>
</table>
