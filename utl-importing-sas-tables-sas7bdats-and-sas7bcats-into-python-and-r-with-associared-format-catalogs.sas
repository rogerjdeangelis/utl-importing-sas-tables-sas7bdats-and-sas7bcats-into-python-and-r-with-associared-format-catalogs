%let pgm=utl-importing-sas-tables-sas7bdats-and-sas7bcats-into-python-and-r-with-associared-format-catalogs;

Importing sas tables sas7bdats and sas7bcats into python and r with associared format catalog

I don't think this works with 32bit formats?

Note: GitHub is a development platform and I really appreciate any bug fixes or comments.

GitHub
https://tinyurl.com/pm4pbwea
https://github.com/rogerjdeangelis/utl-importing-sas-tables-sas7bdats-and-sas7bcats-into-python-and-r-with-associared-format-catalogs

StackOveFlow
https://tinyurl.com/ypd8hrz6
https://stackoverflow.com/questions/65457857/how-to-import-a-formatted-sas7bdat-file-into-r-without-format-deletion

Related Python GitHub
https://tinyurl.com/hx8mtpst
https://github.com/rogerjdeangelis?tab=repositories&q=python+sas7bdat&type=&language=&sort=

Related R GitHub
https://tinyurl.com/55f9dsw4
https://github.com/rogerjdeangelis?tab=repositories&q=r+sas7bdat&type=&language=&sort=


LANGUAGES

    1. R
    2. Python

 _     ____
/ |   |  _ \
| |   | |_) |
| |_  |  _ <
|_(_) |_| \_\

 _                   _
(_)_ __  _ __  _   _| |_ ___
| | `_ \| `_ \| | | | __/ __|
| | | | | |_) | |_| | |_\__ \
|_|_| |_| .__/ \__,_|\__|___/
  __    |_|                     _
 / _| ___  _ __ _ __ ___   __ _| |_
| |_ / _ \| `__| `_ ` _ \ / _` | __|
|  _| (_) | |  | | | | | | (_| | |_
|_|  \___/|_|  |_| |_| |_|\__,_|\__|

libname tmp "c:/temp";

options fmtsearch=(tmp.formats);

proc format lib=tmp.formats;
  value $sex
    "M" = "Male"
    "F" = "Female"
;quit;

proc format lib=fmt;
 select $sex;
run;quit;

----------------------------------------------------------------------------
|       FORMAT NAME: $SEX     LENGTH:    6   NUMBER OF VALUES:    2        |
|   MIN LENGTH:   1  MAX LENGTH:  40  DEFAULT LENGTH:   6  FUZZ:        0  |
|--------------------------------------------------------------------------|
|START           |END             |LABEL  (VER. V7|V8   14SEP2021:17:28:44)|
|----------------+----------------+----------------------------------------|
|F               |F               |Female                                  |
|M               |M               |Male                                    |
----------------------------------------------------------------------------

options validvarname=upcase;
data tmp.have(label="Math Class Students");
  label
      name    ="Student Name  "
      age     ="Student Age   "
      sex     ="Student Gender   "
      height  ="Student Height in"
      weight  ="Student Weight lbs"
;
  set sashelp.class(obs=4);
  format sex $sex.;
run;quit;

Up to 40 obs TMP.HAVE total obs=4

Obs     NAME      SEX    AGE    HEIGHT    WEIGHT

 1     Alfred      M      14     69.0      112.5
 2     Alice       F      13     56.5       84.0
 3     Barbara     F      13     65.3       98.0
 4     Carol       F      14     62.8      102.5

Variables in Creation Order

#    Variable    Type    Len    Format

1    NAME        Char      8
2    SEX         Char      1    $SEX.    ** want to apply this in R
3    AGE         Num       8
4    HEIGHT      Num       8
5    WEIGHT      Num       8

  ___                _               _
|  _ \    ___  _   _| |_ _ __  _   _| |_
| |_) |  / _ \| | | | __| `_ \| | | | __|
|  _ <  | (_) | |_| | |_| |_) | |_| | |_
|_| \_\  \___/ \__,_|\__| .__/ \__,_|\__|
                        |_|

> library(haven);data <- read_sas("c:/temp/have.sas7bdat", catalog_file="c:/temp/formats.sas7bcat");print(data);

# A tibble: 4 x 5

  NAME    SEX          AGE HEIGHT WEIGHT
  <chr>   <chr+lbl>  <dbl>  <dbl>  <dbl>
1 Alfred  M [Male]      14   69     112.
2 Alice   F [Female]    13   56.5    84
3 Barbara F [Female]    13   65.3    98
4 Carol   F [Female]    14   62.8   102.
>

 $ SEX   : chr+lbl [1:4] M, F, F, F
   ..@ format.sas: chr "$SEX"
   ..@ labels    : Named chr [1:2] "M" "F"
   .. ..- attr(*, "names")= chr [1:2] "Male" "Female"

  ___
|  _ \   _ __  _ __ ___   ___ ___  ___ ___
| |_) | | `_ \| `__/ _ \ / __/ _ \/ __/ __|
|  _ <  | |_) | | | (_) | (_|  __/\__ \__ \
|_| \_\ | .__/|_|  \___/ \___\___||___/___/
        |_|

%utl_submit_r64('
library(haven);
data <- read_sas("c:/temp/have.sas7bdat", catalog_file="c:/temp/formats.sas7bcat");
print(data);
str(data);
');

/*___                  _   _
|___ \     _ __  _   _| |_| |__   ___  _ __     _ __  _ __ ___   ___ ___  ___ ___
  __) |   | `_ \| | | | __| `_ \ / _ \| `_ \   | `_ \| `__/ _ \ / __/ _ \/ __/ __|
 / __/ _  | |_) | |_| | |_| | | | (_) | | | |  | |_) | | | (_) | (_|  __/\__ \__ \
|_____(_) | .__/ \__, |\__|_| |_|\___/|_| |_|  | .__/|_|  \___/ \___\___||___/___/
          |_|    |___/                         |_|
*/

%utl_submit_py64_38("
import pandas as pd;
import pyreadstat;
want, metaWant = pyreadstat.read_sas7bdat('c:/temp/have.sas7bdat', catalog_file='c:/temp/formats.sas7bcat', formats_as_category=True);
print(want);
print('COLUMNS:  ', metaWant.column_names);
print('LABELS:   ',metaWant.column_labels);
print('ROWS:     ',metaWant.number_rows);
print('FIELDS:   ',metaWant.number_columns);
print('DSN LABEL:',metaWant.file_label);
print('ENCODING: ',metaWant.file_encoding);
");

/*           _   _                               _               _
 _ __  _   _| |_| |__   ___  _ __     ___  _   _| |_ _ __  _   _| |_
| `_ \| | | | __| `_ \ / _ \| `_ \   / _ \| | | | __| `_ \| | | | __|
| |_) | |_| | |_| | | | (_) | | | | | (_) | |_| | |_| |_) | |_| | |_
| .__/ \__, |\__|_| |_|\___/|_| |_|  \___/ \__,_|\__| .__/ \__,_|\__|
|_|    |___/                                        |_|
*/
      NAME     SEX   AGE  HEIGHT  WEIGHT
0   Alfred    Male  14.0    69.0   112.5
1    Alice  Female  13.0    56.5    84.0
2  Barbara  Female  13.0    65.3    98.0
3    Carol  Female  14.0    62.8   102.5

COLUMNS:   ['NAME', 'SEX', 'AGE', 'HEIGHT', 'WEIGHT']
LABELS:    LABELS:    ['Student Name', 'Student Age', 'Student Gender', 'Student Height in', 'Student Weight lbs']
ROWS:      4
FIELDS:    5
DSN LABEL: Math Class Students
ENCODING:  WINDOWS-1252

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
