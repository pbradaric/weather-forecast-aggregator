#!/bin/bash
################################################################################
# Weather forecast aggregator script
################################################################################
#
# This script will download weather forecast PDFs defined in FORECAST_PLACES
# array and will combine the forecasts into a single timestamped JPEG image.
# This script is designed to work with weather forecast PDFs provided by
# yr.no service.
#
# If you want to add a new place just go to the relevant yr.no page, copy 
# "Forecast as PDF" URL and add it to the FORECAST_PLACES array in the "Config"
# section. Format of the entry should be as following:
#
#       "PLACE_NAME|PLACE_FORECAST_PDF_URL"
#
# where PLACE_NAME is the name of the place using only alphanumeric characters,
# underscore and dash (no spaces allowed).
# In order to remove a place just comment out or completely delete relevant
# FORECAST_PLACES array entry.
#
#
# Prerequisites
# -------------
#
# This script relies on [ImageMagick](https://www.imagemagick.org/) package.
# Install `imagemagick` package and make sure that the
# `/etc/ImageMagick-6/policy.xml` has the following line:
#
#       <policy domain="coder" rights="read | write" pattern="PDF" />
#
# Usage
# -----
#
# Run the script without any parameters.
#
# Author: Predrag Bradaric
#
################################################################################

#
# Config
# ------------------------------------------------------------------------------
FORECAST_PLACES=(
    "Baile_Herculane|https://www.yr.no/en/print/forecast/2-685796/Romania/Caras-Severin/Ora%C5%9F%20B%C3%A3ile%20Herculane/B%C4%83ile%20Herculane"
    "Belgrade|https://www.yr.no/en/print/forecast/2-792680/Serbia/Central%20Serbia/Belgrade/Belgrade"
    "Borski_Stol|https://www.yr.no/en/print/forecast/2-785459/Serbia/Central%20Serbia/Bor/Stol"
    "Blagaj|https://www.yr.no/en/print/forecast/2-3203970/Bosnia%20and%20Herzegovina/Federation%20of%20B&H/Blagaj"
    "Demir_Kapija|https://www.yr.no/en/print/forecast/2-862961/North%20Macedonia/Demir%20Kapija"
    "Dubocka_Rudina|https://www.yr.no/en/print/forecast/2-838062/Serbia/Central%20Serbia/Branicevo/Dubo%C4%8Dka%20Rudina"
    "Gornjacka_Klisura|https://www.yr.no/en/print/forecast/2-790516/Serbia/Gornja%C4%8Dka%20Klisura"
    "Guca|https://www.yr.no/en/print/forecast/2-790106/Serbia/Central%20Serbia/Morava/Gu%C4%8Da"
    "Kadina_Luka|https://www.yr.no/en/print/forecast/2-789706/Serbia/Central%20Serbia/Kolubara/Kadina%20Luka"
    "Jelasnica|https://www.yr.no/en/print/forecast/2-789814/Serbia/Central%20Serbia/Ni%C5%A1ava/Jela%C5%A1nica"
    "Ljubovija|https://www.yr.no/en/print/forecast/2-3196331/Serbia/Central%20Serbia/Ma%C4%8Dva/Ljubovija"
    "Nisevac|https://www.yr.no/en/print/forecast/2-787654/Serbia/Central%20Serbia/Ni%C5%A1ava/Ni%C5%A1evac"
    "Rtanj|https://www.yr.no/en/print/forecast/2-11280179/Serbia/Central%20Serbia/Zaje%C4%8Dar/Rtanj"
    "Sicevo|https://www.yr.no/en/print/forecast/2-785928/Serbia/Central%20Serbia/Ni%C5%A1ava/Si%C4%87evo"
    "Smokovac|https://www.yr.no/en/print/forecast/2-3342840/Montenegro/Podgorica/Smokovac"
    "Strmosten|https://www.yr.no/en/print/forecast/2-785401/Serbia/Central%20Serbia/Pomoravlje/Strmosten"
    "Tupiznica|https://www.yr.no/en/print/forecast/2-784829/Serbia/Tupi%C5%BEnica"
    "Uzice|https://www.yr.no/en/print/forecast/2-3188434/Serbia/Central%20Serbia/Zlatibor/U%C5%BEice"
    "Vrmdza|https://www.yr.no/en/print/forecast/2-784147/Serbia/Central%20Serbia/Zaje%C4%8Dar/Vrmd%C5%BEa"
    "Valjevo|https://www.yr.no/en/print/forecast/2-3188402/Serbia/Central%20Serbia/Kolubara/Valjevo"
    "Vrsac|https://www.yr.no/en/print/forecast/2-784136/Serbia/Vojvodina/South%20Banat/Vr%C5%A1ac"
)

#
# Helper variables
# ------------------------------------------------------------------------------
UNIX_TIMESTAMP=`date +"%s%N"`
DATETIME_STRING=`date +"%Y_%m_%d_%H%M%S"`
OUTPUT_FILENAME="agregated_weather_forecast_${DATETIME_STRING}.jpg"
FORECAST_FILENAMES_STRING=""

#
# Start
# ------------------------------------------------------------------------------
for idx in "${!FORECAST_PLACES[@]}"; do
    IFS="|" read -r -a PLACE <<< "${FORECAST_PLACES[idx]}"
    _PDF_NAME="weather_forecast_${PLACE[0]}_${UNIX_TIMESTAMP}.pdf"
    _JPG_NAME="weather_forecast_${PLACE[0]}_${UNIX_TIMESTAMP}.jpg"
    _METEOGRAM_JPG_NAME="meteogram_${_JPG_NAME}"
    _LONG_1_JPG_NAME="long_weather_forecast_1_${_JPG_NAME}"
    _LONG_2_JPG_NAME="long_weather_forecast_2_${_JPG_NAME}"
    _LONG_3_JPG_NAME="long_weather_forecast_3_${_JPG_NAME}"
    _FINAL_JPG_NAME="final_weather_forecast_${_JPG_NAME}"
    FORECAST_FILENAMES_STRING+="${_FINAL_JPG_NAME} "
    wget ${PLACE[1]} -O ${_PDF_NAME}
    convert -flatten -density 300 -quality 100 ${_PDF_NAME} ${_JPG_NAME} && \
        convert ${_JPG_NAME} -crop 2430x1380+30+240 ${_METEOGRAM_JPG_NAME} && \
        convert ${_JPG_NAME} -crop 260x1380+115+1780 ${_LONG_1_JPG_NAME} && \
        convert ${_JPG_NAME} -crop 350x1380+860+1780 ${_LONG_2_JPG_NAME} && \
        convert ${_JPG_NAME} -crop 680x1380+1710+1780 ${_LONG_3_JPG_NAME} && \
        convert ${_METEOGRAM_JPG_NAME} ${_LONG_1_JPG_NAME} ${_LONG_2_JPG_NAME} ${_LONG_3_JPG_NAME} +append ${_FINAL_JPG_NAME} && \
        convert ${_FINAL_JPG_NAME} -resize 1560x ${_FINAL_JPG_NAME}
done
convert $FORECAST_FILENAMES_STRING -append $OUTPUT_FILENAME

#
# Clean-up
# ------------------------------------------------------------------------------
rm meteogram_*.jpg 2>/dev/null
rm long_weather_forecast_*.jpg 2>/dev/null
rm final_weather_forecast_*.jpg 2>/dev/null
rm weather_forecast_*.jpg 2>/dev/null
rm weather_forecast_*.pdf 2>/dev/null

#
# Launch image viewer with final result (if possible)
# ------------------------------------------------------------------------------
if command -v eog &> /dev/null
then
    eog $OUTPUT_FILENAME
fi
