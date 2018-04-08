import csv
from time import sleep

import requests

STATES = [
    "Sachsen-Anhalt",
    "Niedersachsen",
    "Sachsen",
    "Bayern",
    "Mecklenburg-Vorpommern",
    "Hamburg",
    "Schleswig-Holstein",
    "Rheinland-Pfalz",
    "Hessen",
    "Baden-Württemberg",
    "Thüringen",
    "Saarland",
    "Bremen",
    "Brandenburg",
    "Nordrhein-Westfalen",
    "Berlin"
]

INPUT_PATH = "raw/original_data.csv"
OUTPUT_PATH = "intermediate/ort_bundesland.csv"

GEOCODE_API = "https://nominatim.openstreetmap.org/search?format=json&country=germany&accept-language=de&q="


def geocode_city(city):
    res = requests.get(GEOCODE_API + city)
    res_json = res.json()

    for result in res_json:
        # The display name string contains the Bundesland but the position in
        # the string varies among the data points. Thus, go over each each
        # possible candidate.
        candidates = result["display_name"].split(",")
        i = 0
        while i < len(candidates):
            trimmed = candidates[i].strip()

            if trimmed in STATES:  # excact case sensitive match
                return trimmed
            i += 1
    return None


# we only need to look up each city once
city_names = set()

# read in data
with open(INPUT_PATH, newline='') as csvfile:
    spamreader = csv.reader(csvfile)
    for row in spamreader:
        city_names.add(row[6])

print(city_names)

# main work happens here
data = []
for city in city_names:
    sleep(0.1)
    state = geocode_city(city)
    print(city)
    print(state)
    data.append({'Ort': city, 'Bundesland': state})

# persist to CSV
with open(OUTPUT_PATH, 'w', newline='') as csvfile:
    fieldnames = ['Ort', 'Bundesland']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    writer.writeheader()
    writer.writerows(data)
