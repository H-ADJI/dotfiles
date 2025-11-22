# Paris
DEFAULT_LAT=48.8566
DEFAULT_LON=2.3522

LOC_DATA=$(curl -s ipinfo.io)

if [ $? -eq 0 ]; then
    LAT=$(echo $LOC_DATA | jq -r ".loc" | cut -d, -f1)
    LON=$(echo $LOC_DATA | jq -r ".loc" | cut -d, -f2)
else
    LAT=$DEFAULT_LAT
    LON=$DEFAULT_LON
fi

wlsunset -l "$LAT" -L "$LON" -t 1000
