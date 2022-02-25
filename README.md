Weather forecast aggregator script
========================================



## About

This Bash script will download weather forecast PDFs defined in `FORECAST_PLACES` array and will combine the forecasts into a single timestamped JPEG image.

This script is designed to work with weather forecast PDFs provided by [yr.no](https://yr.no) service.

If you want to add a new place just go to the relevant [yr.no](https://yr.no) page, copy **Forecast as PDF** URL and add it to the `FORECAST_PLACES` array in the `Config` section. Format of the entry should be as following:
```
      "PLACE_NAME|PLACE_FORECAST_PDF_URL"
```
where `PLACE_NAME` is the name of the place using only alphanumeric characters, underscore and dash (no spaces allowed).

In order to remove a place just comment out or completely delete relevant `FORECAST_PLACES` array entry.



## Prerequisites

This script relies on [ImageMagick](https://www.imagemagick.org/) package.

- Install `imagemagick` package.
- Edit `/etc/ImageMagick-6/policy.xml` file (location might be distro and version dependant; this example is for Ubuntu) and add the following line (or change existing to match this one):
    ```
    <policy domain="coder" rights="read | write" pattern="PDF" />
    ```


## Usage

Run the script from Bash (default Linux shell on most distros) without any parameters. It should work from WSL instance as well.
