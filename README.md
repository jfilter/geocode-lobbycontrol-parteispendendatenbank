# Geocode LobbyControl Parteispendendatenbank

Geocode the German Political Party Donation Database [by LobbyControl](https://lobbypedia.de/wiki/Parteispenden-Datenbank).

## Resulting Charts

Check out two visualizations on DataWrapper:

* https://www.datawrapper.de/_/ayQ55/
* https://www.datawrapper.de/_/vYaUI/

## How It Was Done

1.  The city for a donation was already in the data but the state (Bundesland) was missing. So first we get the state via OSM. See [fetch_bundesland_to_ort.py](fetch_bundesland_to_ort.py).
2.  Clean cities that could not be automatically matched manually. See [manual_cleaning.R](manual_cleaning.R).
3.  Aggregate and combine the now cleaned and enrichted data with some other data sources ([GDP 2016](https://www.statistik-bw.de/Statistik-Portal/en/en_jb27_jahrtab65.asp) and [demographics 2016](https://www.destatis.de/DE/ZahlenFakten/LaenderRegionen/Regionales/Gemeindeverzeichnis/Administrativ/Aktuell/02Bundeslaender.html)). See [wrangle.R](wrangle.R).

## License

MIT.
