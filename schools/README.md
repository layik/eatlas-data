School rankings with TGVE
================

Let us show how the TGVE can be used to see rankings of schools in the
UK with fewest steps possible. For the purpose of this Rmarkdown doc, I
will create a directory at:

``` r
library(readr)
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
d = "~/code/tgve/eatlas-data/schools/data"
if(!dir.exists(d)) {
  dir.create(d)
}
```

## Get school data

The school data is availabe from
<https://get-information-schools.service.gov.uk/Downloads>. For the
purpose of this analysis download “All establishment data” by checking
“Establishment fields CSV, 60.56 MB” checkbox. If you download that you
will get a file with name `dubasealldata20220306.csv`.

You if you then read the contents of that CSV with `readr` you would be
looking at something like this:

``` r
csv = readr::read_csv("~/Downloads/edubasealldata20220306.csv")
```

    ## Rows: 49440 Columns: 138
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (98): LA (code), LA (name), EstablishmentNumber, EstablishmentName, Type...
    ## dbl (36): URN, EstablishmentTypeGroup (code), EstablishmentStatus (code), Ph...
    ## lgl  (4): NextInspectionVisit, SEN13 (name), QABReport, CHNumber
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
head(names(csv))
```

    ## [1] "URN"                        "LA (code)"                 
    ## [3] "LA (name)"                  "EstablishmentNumber"       
    ## [5] "EstablishmentName"          "TypeOfEstablishment (code)"

``` r
names(csv)[grep("ofsted", names(csv), ignore.case = TRUE)]
```

    ## [1] "OfstedLastInsp"               "OfstedSpecialMeasures (code)"
    ## [3] "OfstedSpecialMeasures (name)" "OfstedRating (name)"

``` r
# lots of code columns
head(names(csv)[grep("code", names(csv), ignore.case = TRUE)])
```

    ## [1] "LA (code)"                        "TypeOfEstablishment (code)"      
    ## [3] "EstablishmentTypeGroup (code)"    "EstablishmentStatus (code)"      
    ## [5] "ReasonEstablishmentOpened (code)" "ReasonEstablishmentClosed (code)"

``` r
# this is what we will be using
names(csv)[grep("district", names(csv), ignore.case = TRUE)]
```

    ## [1] "DistrictAdministrative (code)" "DistrictAdministrative (name)"

So let us get only the ranking and the geography as:

``` r
data = csv %>% select(`OfstedRating (name)`, `DistrictAdministrative (code)`, `DistrictAdministrative (name)`)
names(data) = c("ranking", "la_code", "name")
# we can remove the na's in the csv like
# data = data %>% filter(!is.na(ranking))
data %>% group_by(ranking, la_code, name) %>% summarise(ranking_count = n()) %>% 
  readr::write_csv(file.path(d, "data.csv"))
```

    ## `summarise()` has grouped output by 'ranking', 'la_code'. You can override using
    ## the `.groups` argument.

## Get geography

The reason I named second column `la_code` is that I know we have that
Local Authority District geographies over at SaferActive project here.
We can of course download the file and save it in the same directory:

``` r
geoURL = "https://raw.githubusercontent.com/saferactive/tgve/main/las-only-code.geojson"
download.file(geoURL, file.path(d, "lad.geojson"))
```

Now, feel free to explore this using `sf` or any other way you do your
geoprocessing but there will be a column named `la_code` as `tgver` will
need a matching column name to put the two files together.

## `tgver::explore_dir`

Make sure you have `tgver`

``` r
install.packages("tgver")
```

Step three:

``` r
tgver::explore_dir(d)
```

We can do even better, all we have to do is get the data somewhere, so I
added it to the `tgve/example-data` repository, therefore we can do:

``` r
# the link to browse
# https://tgve.github.io/app/?defaultURL=https://raw.githubusercontent.com/tgve/example-data/main/schools/data.csv&geographyURL=https://raw.githubusercontent.com/saferactive/tgve/main/las-only-code.geojson&geographyColumn=la_code
dataURL = "https://raw.githubusercontent.com/tgve/example-data/main/schools/data.csv"
app = "https://tgve.github.io/app/"
knitr::include_url(paste0(
  app, "?defaultURL=", dataURL, "&geographyURL=", geoURL, "&geographyColumn=la_code"
))
```

<a href="https://tgve.github.io/app/?defaultURL=https://raw.githubusercontent.com/tgve/example-data/main/schools/data.csv&geographyURL=https://raw.githubusercontent.com/saferactive/tgve/main/las-only-code.geojson&geographyColumn=la_code" target="_blank"><img src="/home/layik/code/tgve/eatlas-data/schools/README_files/figure-gfm/final-1.png" width="100%" /></a>
