﻿# importing users from a CSV-file
Import-Csv .\Users.csv -Delimiter ';' | Select-Object -First 2 |
    ForEach-Object { `
    ForEach-Object { `
    ForEach-Object { `