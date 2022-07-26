{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "87373687",
   "metadata": {
    "papermill": {
     "duration": 0.008636,
     "end_time": "2022-07-26T13:52:14.584561",
     "exception": false,
     "start_time": "2022-07-26T13:52:14.575925",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Author: JianHui (Jake) Li\n",
    "\n",
    "Date: 07/26/2022\n",
    "\n",
    "## Introduction\n",
    "\n",
    "This is a capstone project from the final course of the Google Data Analytics Professional Certificate (track #1, case study #1). For more information click [here](https://www.coursera.org/learn/google-data-analytics-capstone?). I will be following the steps of the data analysis process (ask, prepare, process, analyze, share, act) I learned throughout the courses, and the case study roadmap provided as a guide.\n",
    "\n",
    "## Background\n",
    "\n",
    "**About the company:**\n",
    "In 2016, Cyclistic launched a successful bike-share offering. Since then, the program has grown to a fleet of 5,824 bicycles that are geotracked and locked into a network of 692 stations across Chicago. The bikes can be unlocked from one station and returned to any other station in the system anytime.\n",
    "\n",
    "**Scenario:**\n",
    "You are a junior data analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, your team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, your team will design a new marketing strategy to convert casual riders into annual members. But first, Cyclistic executives must approve your recommendations, so they must be backed up with compelling data insights and professional data visualizations.\n",
    "\n",
    "**Business task:**\n",
    "Identify trends and differences between members and casual riders using Cyclistic historical bike trip data to help design marketing strategies for the Cyclistic marketing analytics team.\n",
    "\n",
    "**Data Source:**\n",
    "[Cyclistic’s Historical Trip Data (06/2021 - 05/2022)](https://divvy-tripdata.s3.amazonaws.com/index.html)\n",
    "\n",
    "*Note*: These datasets have a different name because Cyclistic is a fictional company, and the data has been made available by Motivate International Inc. under this [license](https://www.divvybikes.com/data-license-agreement)."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 1,
   "id": "9d84f62d",
   "metadata": {
    "_kg_hide-output": false,
    "execution": {
     "iopub.execute_input": "2022-07-26T13:52:14.604530Z",
     "iopub.status.busy": "2022-07-26T13:52:14.601479Z",
     "iopub.status.idle": "2022-07-26T13:52:16.158535Z",
     "shell.execute_reply": "2022-07-26T13:52:16.156702Z"
    },
    "papermill": {
     "duration": 1.569901,
     "end_time": "2022-07-26T13:52:16.161670",
     "exception": false,
     "start_time": "2022-07-26T13:52:14.591769",
     "status": "completed"
    },
    "scrolled": true,
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "── \u001b[1mAttaching packages\u001b[22m ─────────────────────────────────────── tidyverse 1.3.1 ──\n",
      "\n",
      "\u001b[32m✔\u001b[39m \u001b[34mggplot2\u001b[39m 3.3.6     \u001b[32m✔\u001b[39m \u001b[34mpurrr  \u001b[39m 0.3.4\n",
      "\u001b[32m✔\u001b[39m \u001b[34mtibble \u001b[39m 3.1.7     \u001b[32m✔\u001b[39m \u001b[34mdplyr  \u001b[39m 1.0.9\n",
      "\u001b[32m✔\u001b[39m \u001b[34mtidyr  \u001b[39m 1.2.0     \u001b[32m✔\u001b[39m \u001b[34mstringr\u001b[39m 1.4.0\n",
      "\u001b[32m✔\u001b[39m \u001b[34mreadr  \u001b[39m 2.1.2     \u001b[32m✔\u001b[39m \u001b[34mforcats\u001b[39m 0.5.1\n",
      "\n",
      "── \u001b[1mConflicts\u001b[22m ────────────────────────────────────────── tidyverse_conflicts() ──\n",
      "\u001b[31m✖\u001b[39m \u001b[34mdplyr\u001b[39m::\u001b[32mfilter()\u001b[39m masks \u001b[34mstats\u001b[39m::filter()\n",
      "\u001b[31m✖\u001b[39m \u001b[34mdplyr\u001b[39m::\u001b[32mlag()\u001b[39m    masks \u001b[34mstats\u001b[39m::lag()\n",
      "\n",
      "\n",
      "Attaching package: ‘lubridate’\n",
      "\n",
      "\n",
      "The following objects are masked from ‘package:base’:\n",
      "\n",
      "    date, intersect, setdiff, union\n",
      "\n",
      "\n",
      "\n",
      "Attaching package: ‘scales’\n",
      "\n",
      "\n",
      "The following object is masked from ‘package:purrr’:\n",
      "\n",
      "    discard\n",
      "\n",
      "\n",
      "The following object is masked from ‘package:readr’:\n",
      "\n",
      "    col_factor\n",
      "\n",
      "\n"
     ]
    }
   ],
   "source": [
    "# Setting up the environment.\n",
    "library(tidyverse)\n",
    "library(skimr)\n",
    "library(ggplot2)\n",
    "library(lubridate)\n",
    "library(scales)\n",
    "library(RColorBrewer)\n",
    "library(repr)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "id": "7002c6a1",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:52:16.208831Z",
     "iopub.status.busy": "2022-07-26T13:52:16.178658Z",
     "iopub.status.idle": "2022-07-26T13:52:51.547216Z",
     "shell.execute_reply": "2022-07-26T13:52:51.545409Z"
    },
    "papermill": {
     "duration": 35.380902,
     "end_time": "2022-07-26T13:52:51.550128",
     "exception": false,
     "start_time": "2022-07-26T13:52:16.169226",
     "status": "completed"
    },
    "scrolled": true,
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "\u001b[1mRows: \u001b[22m\u001b[34m729595\u001b[39m \u001b[1mColumns: \u001b[22m\u001b[34m13\u001b[39m\n",
      "\u001b[36m──\u001b[39m \u001b[1mColumn specification\u001b[22m \u001b[36m────────────────────────────────────────────────────────\u001b[39m\n",
      "\u001b[1mDelimiter:\u001b[22m \",\"\n",
      "\u001b[31mchr\u001b[39m  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...\n",
      "\u001b[32mdbl\u001b[39m  (4): start_lat, start_lng, end_lat, end_lng\n",
      "\u001b[34mdttm\u001b[39m (2): started_at, ended_at\n",
      "\n",
      "\u001b[36mℹ\u001b[39m Use `spec()` to retrieve the full column specification for this data.\n",
      "\u001b[36mℹ\u001b[39m Specify the column types or set `show_col_types = FALSE` to quiet this message.\n",
      "\u001b[1mRows: \u001b[22m\u001b[34m822410\u001b[39m \u001b[1mColumns: \u001b[22m\u001b[34m13\u001b[39m\n",
      "\u001b[36m──\u001b[39m \u001b[1mColumn specification\u001b[22m \u001b[36m────────────────────────────────────────────────────────\u001b[39m\n",
      "\u001b[1mDelimiter:\u001b[22m \",\"\n",
      "\u001b[31mchr\u001b[39m  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...\n",
      "\u001b[32mdbl\u001b[39m  (4): start_lat, start_lng, end_lat, end_lng\n",
      "\u001b[34mdttm\u001b[39m (2): started_at, ended_at\n",
      "\n",
      "\u001b[36mℹ\u001b[39m Use `spec()` to retrieve the full column specification for this data.\n",
      "\u001b[36mℹ\u001b[39m Specify the column types or set `show_col_types = FALSE` to quiet this message.\n",
      "\u001b[1mRows: \u001b[22m\u001b[34m804352\u001b[39m \u001b[1mColumns: \u001b[22m\u001b[34m13\u001b[39m\n",
      "\u001b[36m──\u001b[39m \u001b[1mColumn specification\u001b[22m \u001b[36m────────────────────────────────────────────────────────\u001b[39m\n",
      "\u001b[1mDelimiter:\u001b[22m \",\"\n",
      "\u001b[31mchr\u001b[39m  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...\n",
      "\u001b[32mdbl\u001b[39m  (4): start_lat, start_lng, end_lat, end_lng\n",
      "\u001b[34mdttm\u001b[39m (2): started_at, ended_at\n",
      "\n",
      "\u001b[36mℹ\u001b[39m Use `spec()` to retrieve the full column specification for this data.\n",
      "\u001b[36mℹ\u001b[39m Specify the column types or set `show_col_types = FALSE` to quiet this message.\n",
      "\u001b[1mRows: \u001b[22m\u001b[34m756147\u001b[39m \u001b[1mColumns: \u001b[22m\u001b[34m13\u001b[39m\n",
      "\u001b[36m──\u001b[39m \u001b[1mColumn specification\u001b[22m \u001b[36m────────────────────────────────────────────────────────\u001b[39m\n",
      "\u001b[1mDelimiter:\u001b[22m \",\"\n",
      "\u001b[31mchr\u001b[39m  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...\n",
      "\u001b[32mdbl\u001b[39m  (4): start_lat, start_lng, end_lat, end_lng\n",
      "\u001b[34mdttm\u001b[39m (2): started_at, ended_at\n",
      "\n",
      "\u001b[36mℹ\u001b[39m Use `spec()` to retrieve the full column specification for this data.\n",
      "\u001b[36mℹ\u001b[39m Specify the column types or set `show_col_types = FALSE` to quiet this message.\n",
      "\u001b[1mRows: \u001b[22m\u001b[34m631226\u001b[39m \u001b[1mColumns: \u001b[22m\u001b[34m13\u001b[39m\n",
      "\u001b[36m──\u001b[39m \u001b[1mColumn specification\u001b[22m \u001b[36m────────────────────────────────────────────────────────\u001b[39m\n",
      "\u001b[1mDelimiter:\u001b[22m \",\"\n",
      "\u001b[31mchr\u001b[39m  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...\n",
      "\u001b[32mdbl\u001b[39m  (4): start_lat, start_lng, end_lat, end_lng\n",
      "\u001b[34mdttm\u001b[39m (2): started_at, ended_at\n",
      "\n",
      "\u001b[36mℹ\u001b[39m Use `spec()` to retrieve the full column specification for this data.\n",
      "\u001b[36mℹ\u001b[39m Specify the column types or set `show_col_types = FALSE` to quiet this message.\n",
      "\u001b[1mRows: \u001b[22m\u001b[34m359978\u001b[39m \u001b[1mColumns: \u001b[22m\u001b[34m13\u001b[39m\n",
      "\u001b[36m──\u001b[39m \u001b[1mColumn specification\u001b[22m \u001b[36m────────────────────────────────────────────────────────\u001b[39m\n",
      "\u001b[1mDelimiter:\u001b[22m \",\"\n",
      "\u001b[31mchr\u001b[39m  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...\n",
      "\u001b[32mdbl\u001b[39m  (4): start_lat, start_lng, end_lat, end_lng\n",
      "\u001b[34mdttm\u001b[39m (2): started_at, ended_at\n",
      "\n",
      "\u001b[36mℹ\u001b[39m Use `spec()` to retrieve the full column specification for this data.\n",
      "\u001b[36mℹ\u001b[39m Specify the column types or set `show_col_types = FALSE` to quiet this message.\n",
      "\u001b[1mRows: \u001b[22m\u001b[34m247540\u001b[39m \u001b[1mColumns: \u001b[22m\u001b[34m13\u001b[39m\n",
      "\u001b[36m──\u001b[39m \u001b[1mColumn specification\u001b[22m \u001b[36m────────────────────────────────────────────────────────\u001b[39m\n",
      "\u001b[1mDelimiter:\u001b[22m \",\"\n",
      "\u001b[31mchr\u001b[39m  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...\n",
      "\u001b[32mdbl\u001b[39m  (4): start_lat, start_lng, end_lat, end_lng\n",
      "\u001b[34mdttm\u001b[39m (2): started_at, ended_at\n",
      "\n",
      "\u001b[36mℹ\u001b[39m Use `spec()` to retrieve the full column specification for this data.\n",
      "\u001b[36mℹ\u001b[39m Specify the column types or set `show_col_types = FALSE` to quiet this message.\n",
      "\u001b[1mRows: \u001b[22m\u001b[34m103770\u001b[39m \u001b[1mColumns: \u001b[22m\u001b[34m13\u001b[39m\n",
      "\u001b[36m──\u001b[39m \u001b[1mColumn specification\u001b[22m \u001b[36m────────────────────────────────────────────────────────\u001b[39m\n",
      "\u001b[1mDelimiter:\u001b[22m \",\"\n",
      "\u001b[31mchr\u001b[39m  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...\n",
      "\u001b[32mdbl\u001b[39m  (4): start_lat, start_lng, end_lat, end_lng\n",
      "\u001b[34mdttm\u001b[39m (2): started_at, ended_at\n",
      "\n",
      "\u001b[36mℹ\u001b[39m Use `spec()` to retrieve the full column specification for this data.\n",
      "\u001b[36mℹ\u001b[39m Specify the column types or set `show_col_types = FALSE` to quiet this message.\n",
      "\u001b[1mRows: \u001b[22m\u001b[34m115609\u001b[39m \u001b[1mColumns: \u001b[22m\u001b[34m13\u001b[39m\n",
      "\u001b[36m──\u001b[39m \u001b[1mColumn specification\u001b[22m \u001b[36m────────────────────────────────────────────────────────\u001b[39m\n",
      "\u001b[1mDelimiter:\u001b[22m \",\"\n",
      "\u001b[31mchr\u001b[39m  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...\n",
      "\u001b[32mdbl\u001b[39m  (4): start_lat, start_lng, end_lat, end_lng\n",
      "\u001b[34mdttm\u001b[39m (2): started_at, ended_at\n",
      "\n",
      "\u001b[36mℹ\u001b[39m Use `spec()` to retrieve the full column specification for this data.\n",
      "\u001b[36mℹ\u001b[39m Specify the column types or set `show_col_types = FALSE` to quiet this message.\n",
      "\u001b[1mRows: \u001b[22m\u001b[34m284042\u001b[39m \u001b[1mColumns: \u001b[22m\u001b[34m13\u001b[39m\n",
      "\u001b[36m──\u001b[39m \u001b[1mColumn specification\u001b[22m \u001b[36m────────────────────────────────────────────────────────\u001b[39m\n",
      "\u001b[1mDelimiter:\u001b[22m \",\"\n",
      "\u001b[31mchr\u001b[39m  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...\n",
      "\u001b[32mdbl\u001b[39m  (4): start_lat, start_lng, end_lat, end_lng\n",
      "\u001b[34mdttm\u001b[39m (2): started_at, ended_at\n",
      "\n",
      "\u001b[36mℹ\u001b[39m Use `spec()` to retrieve the full column specification for this data.\n",
      "\u001b[36mℹ\u001b[39m Specify the column types or set `show_col_types = FALSE` to quiet this message.\n",
      "\u001b[1mRows: \u001b[22m\u001b[34m371249\u001b[39m \u001b[1mColumns: \u001b[22m\u001b[34m13\u001b[39m\n",
      "\u001b[36m──\u001b[39m \u001b[1mColumn specification\u001b[22m \u001b[36m────────────────────────────────────────────────────────\u001b[39m\n",
      "\u001b[1mDelimiter:\u001b[22m \",\"\n",
      "\u001b[31mchr\u001b[39m  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...\n",
      "\u001b[32mdbl\u001b[39m  (4): start_lat, start_lng, end_lat, end_lng\n",
      "\u001b[34mdttm\u001b[39m (2): started_at, ended_at\n",
      "\n",
      "\u001b[36mℹ\u001b[39m Use `spec()` to retrieve the full column specification for this data.\n",
      "\u001b[36mℹ\u001b[39m Specify the column types or set `show_col_types = FALSE` to quiet this message.\n",
      "\u001b[1mRows: \u001b[22m\u001b[34m634858\u001b[39m \u001b[1mColumns: \u001b[22m\u001b[34m13\u001b[39m\n",
      "\u001b[36m──\u001b[39m \u001b[1mColumn specification\u001b[22m \u001b[36m────────────────────────────────────────────────────────\u001b[39m\n",
      "\u001b[1mDelimiter:\u001b[22m \",\"\n",
      "\u001b[31mchr\u001b[39m  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...\n",
      "\u001b[32mdbl\u001b[39m  (4): start_lat, start_lng, end_lat, end_lng\n",
      "\u001b[34mdttm\u001b[39m (2): started_at, ended_at\n",
      "\n",
      "\u001b[36mℹ\u001b[39m Use `spec()` to retrieve the full column specification for this data.\n",
      "\u001b[36mℹ\u001b[39m Specify the column types or set `show_col_types = FALSE` to quiet this message.\n"
     ]
    }
   ],
   "source": [
    "# Merging all CSV files into one.\n",
    "bike_trip_df <- list.files(path = \"../input/google-data-analytics-case-study-1-jianhui\", full.names = TRUE) %>%\n",
    "  lapply(read_csv) %>%\n",
    "  bind_rows"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 3,
   "id": "2883317f",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:52:51.573425Z",
     "iopub.status.busy": "2022-07-26T13:52:51.571918Z",
     "iopub.status.idle": "2022-07-26T13:52:51.610802Z",
     "shell.execute_reply": "2022-07-26T13:52:51.609109Z"
    },
    "papermill": {
     "duration": 0.052898,
     "end_time": "2022-07-26T13:52:51.613275",
     "exception": false,
     "start_time": "2022-07-26T13:52:51.560377",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<style>\n",
       ".list-inline {list-style: none; margin:0; padding: 0}\n",
       ".list-inline>li {display: inline-block}\n",
       ".list-inline>li:not(:last-child)::after {content: \"\\00b7\"; padding: 0 .5ex}\n",
       "</style>\n",
       "<ol class=list-inline><li>'ride_id'</li><li>'rideable_type'</li><li>'started_at'</li><li>'ended_at'</li><li>'start_station_name'</li><li>'start_station_id'</li><li>'end_station_name'</li><li>'end_station_id'</li><li>'start_lat'</li><li>'start_lng'</li><li>'end_lat'</li><li>'end_lng'</li><li>'member_casual'</li></ol>\n"
      ],
      "text/latex": [
       "\\begin{enumerate*}\n",
       "\\item 'ride\\_id'\n",
       "\\item 'rideable\\_type'\n",
       "\\item 'started\\_at'\n",
       "\\item 'ended\\_at'\n",
       "\\item 'start\\_station\\_name'\n",
       "\\item 'start\\_station\\_id'\n",
       "\\item 'end\\_station\\_name'\n",
       "\\item 'end\\_station\\_id'\n",
       "\\item 'start\\_lat'\n",
       "\\item 'start\\_lng'\n",
       "\\item 'end\\_lat'\n",
       "\\item 'end\\_lng'\n",
       "\\item 'member\\_casual'\n",
       "\\end{enumerate*}\n"
      ],
      "text/markdown": [
       "1. 'ride_id'\n",
       "2. 'rideable_type'\n",
       "3. 'started_at'\n",
       "4. 'ended_at'\n",
       "5. 'start_station_name'\n",
       "6. 'start_station_id'\n",
       "7. 'end_station_name'\n",
       "8. 'end_station_id'\n",
       "9. 'start_lat'\n",
       "10. 'start_lng'\n",
       "11. 'end_lat'\n",
       "12. 'end_lng'\n",
       "13. 'member_casual'\n",
       "\n",
       "\n"
      ],
      "text/plain": [
       " [1] \"ride_id\"            \"rideable_type\"      \"started_at\"        \n",
       " [4] \"ended_at\"           \"start_station_name\" \"start_station_id\"  \n",
       " [7] \"end_station_name\"   \"end_station_id\"     \"start_lat\"         \n",
       "[10] \"start_lng\"          \"end_lat\"            \"end_lng\"           \n",
       "[13] \"member_casual\"     "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A tibble: 6 × 13</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>ride_id</th><th scope=col>rideable_type</th><th scope=col>started_at</th><th scope=col>ended_at</th><th scope=col>start_station_name</th><th scope=col>start_station_id</th><th scope=col>end_station_name</th><th scope=col>end_station_id</th><th scope=col>start_lat</th><th scope=col>start_lng</th><th scope=col>end_lat</th><th scope=col>end_lng</th><th scope=col>member_casual</th></tr>\n",
       "\t<tr><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dttm&gt;</th><th scope=col>&lt;dttm&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>99FEC93BA843FB20</td><td>electric_bike</td><td>2021-06-13 14:31:28</td><td>2021-06-13 14:34:11</td><td>NA</td><td>NA</td><td>NA</td><td>NA</td><td>41.80</td><td>-87.59</td><td>41.80</td><td>-87.60</td><td>member</td></tr>\n",
       "\t<tr><td>06048DCFC8520CAF</td><td>electric_bike</td><td>2021-06-04 11:18:02</td><td>2021-06-04 11:24:19</td><td>NA</td><td>NA</td><td>NA</td><td>NA</td><td>41.79</td><td>-87.59</td><td>41.80</td><td>-87.60</td><td>member</td></tr>\n",
       "\t<tr><td>9598066F68045DF2</td><td>electric_bike</td><td>2021-06-04 09:49:35</td><td>2021-06-04 09:55:34</td><td>NA</td><td>NA</td><td>NA</td><td>NA</td><td>41.80</td><td>-87.60</td><td>41.79</td><td>-87.59</td><td>member</td></tr>\n",
       "\t<tr><td>B03C0FE48C412214</td><td>electric_bike</td><td>2021-06-03 19:56:05</td><td>2021-06-03 20:21:55</td><td>NA</td><td>NA</td><td>NA</td><td>NA</td><td>41.78</td><td>-87.58</td><td>41.80</td><td>-87.60</td><td>member</td></tr>\n",
       "\t<tr><td>B9EEA89F8FEE73B7</td><td>electric_bike</td><td>2021-06-04 14:05:51</td><td>2021-06-04 14:09:59</td><td>NA</td><td>NA</td><td>NA</td><td>NA</td><td>41.80</td><td>-87.59</td><td>41.79</td><td>-87.59</td><td>member</td></tr>\n",
       "\t<tr><td>62B943CEAAA420BA</td><td>electric_bike</td><td>2021-06-03 19:32:01</td><td>2021-06-03 19:38:46</td><td>NA</td><td>NA</td><td>NA</td><td>NA</td><td>41.78</td><td>-87.58</td><td>41.78</td><td>-87.58</td><td>member</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A tibble: 6 × 13\n",
       "\\begin{tabular}{lllllllllllll}\n",
       " ride\\_id & rideable\\_type & started\\_at & ended\\_at & start\\_station\\_name & start\\_station\\_id & end\\_station\\_name & end\\_station\\_id & start\\_lat & start\\_lng & end\\_lat & end\\_lng & member\\_casual\\\\\n",
       " <chr> & <chr> & <dttm> & <dttm> & <chr> & <chr> & <chr> & <chr> & <dbl> & <dbl> & <dbl> & <dbl> & <chr>\\\\\n",
       "\\hline\n",
       "\t 99FEC93BA843FB20 & electric\\_bike & 2021-06-13 14:31:28 & 2021-06-13 14:34:11 & NA & NA & NA & NA & 41.80 & -87.59 & 41.80 & -87.60 & member\\\\\n",
       "\t 06048DCFC8520CAF & electric\\_bike & 2021-06-04 11:18:02 & 2021-06-04 11:24:19 & NA & NA & NA & NA & 41.79 & -87.59 & 41.80 & -87.60 & member\\\\\n",
       "\t 9598066F68045DF2 & electric\\_bike & 2021-06-04 09:49:35 & 2021-06-04 09:55:34 & NA & NA & NA & NA & 41.80 & -87.60 & 41.79 & -87.59 & member\\\\\n",
       "\t B03C0FE48C412214 & electric\\_bike & 2021-06-03 19:56:05 & 2021-06-03 20:21:55 & NA & NA & NA & NA & 41.78 & -87.58 & 41.80 & -87.60 & member\\\\\n",
       "\t B9EEA89F8FEE73B7 & electric\\_bike & 2021-06-04 14:05:51 & 2021-06-04 14:09:59 & NA & NA & NA & NA & 41.80 & -87.59 & 41.79 & -87.59 & member\\\\\n",
       "\t 62B943CEAAA420BA & electric\\_bike & 2021-06-03 19:32:01 & 2021-06-03 19:38:46 & NA & NA & NA & NA & 41.78 & -87.58 & 41.78 & -87.58 & member\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A tibble: 6 × 13\n",
       "\n",
       "| ride_id &lt;chr&gt; | rideable_type &lt;chr&gt; | started_at &lt;dttm&gt; | ended_at &lt;dttm&gt; | start_station_name &lt;chr&gt; | start_station_id &lt;chr&gt; | end_station_name &lt;chr&gt; | end_station_id &lt;chr&gt; | start_lat &lt;dbl&gt; | start_lng &lt;dbl&gt; | end_lat &lt;dbl&gt; | end_lng &lt;dbl&gt; | member_casual &lt;chr&gt; |\n",
       "|---|---|---|---|---|---|---|---|---|---|---|---|---|\n",
       "| 99FEC93BA843FB20 | electric_bike | 2021-06-13 14:31:28 | 2021-06-13 14:34:11 | NA | NA | NA | NA | 41.80 | -87.59 | 41.80 | -87.60 | member |\n",
       "| 06048DCFC8520CAF | electric_bike | 2021-06-04 11:18:02 | 2021-06-04 11:24:19 | NA | NA | NA | NA | 41.79 | -87.59 | 41.80 | -87.60 | member |\n",
       "| 9598066F68045DF2 | electric_bike | 2021-06-04 09:49:35 | 2021-06-04 09:55:34 | NA | NA | NA | NA | 41.80 | -87.60 | 41.79 | -87.59 | member |\n",
       "| B03C0FE48C412214 | electric_bike | 2021-06-03 19:56:05 | 2021-06-03 20:21:55 | NA | NA | NA | NA | 41.78 | -87.58 | 41.80 | -87.60 | member |\n",
       "| B9EEA89F8FEE73B7 | electric_bike | 2021-06-04 14:05:51 | 2021-06-04 14:09:59 | NA | NA | NA | NA | 41.80 | -87.59 | 41.79 | -87.59 | member |\n",
       "| 62B943CEAAA420BA | electric_bike | 2021-06-03 19:32:01 | 2021-06-03 19:38:46 | NA | NA | NA | NA | 41.78 | -87.58 | 41.78 | -87.58 | member |\n",
       "\n"
      ],
      "text/plain": [
       "  ride_id          rideable_type started_at          ended_at           \n",
       "1 99FEC93BA843FB20 electric_bike 2021-06-13 14:31:28 2021-06-13 14:34:11\n",
       "2 06048DCFC8520CAF electric_bike 2021-06-04 11:18:02 2021-06-04 11:24:19\n",
       "3 9598066F68045DF2 electric_bike 2021-06-04 09:49:35 2021-06-04 09:55:34\n",
       "4 B03C0FE48C412214 electric_bike 2021-06-03 19:56:05 2021-06-03 20:21:55\n",
       "5 B9EEA89F8FEE73B7 electric_bike 2021-06-04 14:05:51 2021-06-04 14:09:59\n",
       "6 62B943CEAAA420BA electric_bike 2021-06-03 19:32:01 2021-06-03 19:38:46\n",
       "  start_station_name start_station_id end_station_name end_station_id start_lat\n",
       "1 NA                 NA               NA               NA             41.80    \n",
       "2 NA                 NA               NA               NA             41.79    \n",
       "3 NA                 NA               NA               NA             41.80    \n",
       "4 NA                 NA               NA               NA             41.78    \n",
       "5 NA                 NA               NA               NA             41.80    \n",
       "6 NA                 NA               NA               NA             41.78    \n",
       "  start_lng end_lat end_lng member_casual\n",
       "1 -87.59    41.80   -87.60  member       \n",
       "2 -87.59    41.80   -87.60  member       \n",
       "3 -87.60    41.79   -87.59  member       \n",
       "4 -87.58    41.80   -87.60  member       \n",
       "5 -87.59    41.79   -87.59  member       \n",
       "6 -87.58    41.78   -87.58  member       "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Display the column names of the dataframe.\n",
    "colnames(bike_trip_df)\n",
    "\n",
    "# Display the first 6 rows of the dataframe.\n",
    "head(bike_trip_df)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 4,
   "id": "383bd519",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:52:51.637492Z",
     "iopub.status.busy": "2022-07-26T13:52:51.635867Z",
     "iopub.status.idle": "2022-07-26T13:52:55.568022Z",
     "shell.execute_reply": "2022-07-26T13:52:55.566304Z"
    },
    "papermill": {
     "duration": 3.946752,
     "end_time": "2022-07-26T13:52:55.570411",
     "exception": false,
     "start_time": "2022-07-26T13:52:51.623659",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/plain": [
       "   ride_id          rideable_type        started_at                 \n",
       " Length:5860776     Length:5860776     Min.   :2021-06-01 00:00:38  \n",
       " Class :character   Class :character   1st Qu.:2021-07-29 10:43:32  \n",
       " Mode  :character   Mode  :character   Median :2021-09-23 17:33:23  \n",
       "                                       Mean   :2021-10-26 03:44:54  \n",
       "                                       3rd Qu.:2022-01-14 10:59:12  \n",
       "                                       Max.   :2022-05-31 23:59:56  \n",
       "                                                                    \n",
       "    ended_at                   start_station_name start_station_id  \n",
       " Min.   :2021-06-01 00:06:22   Length:5860776     Length:5860776    \n",
       " 1st Qu.:2021-07-29 11:02:56   Class :character   Class :character  \n",
       " Median :2021-09-23 17:49:29   Mode  :character   Mode  :character  \n",
       " Mean   :2021-10-26 04:05:36                                        \n",
       " 3rd Qu.:2022-01-14 11:14:48                                        \n",
       " Max.   :2022-06-02 11:35:01                                        \n",
       "                                                                    \n",
       " end_station_name   end_station_id       start_lat       start_lng     \n",
       " Length:5860776     Length:5860776     Min.   :41.64   Min.   :-87.84  \n",
       " Class :character   Class :character   1st Qu.:41.88   1st Qu.:-87.66  \n",
       " Mode  :character   Mode  :character   Median :41.90   Median :-87.64  \n",
       "                                       Mean   :41.90   Mean   :-87.65  \n",
       "                                       3rd Qu.:41.93   3rd Qu.:-87.63  \n",
       "                                       Max.   :45.64   Max.   :-73.80  \n",
       "                                                                       \n",
       "    end_lat         end_lng       member_casual     \n",
       " Min.   :41.39   Min.   :-88.97   Length:5860776    \n",
       " 1st Qu.:41.88   1st Qu.:-87.66   Class :character  \n",
       " Median :41.90   Median :-87.64   Mode  :character  \n",
       " Mean   :41.90   Mean   :-87.65                     \n",
       " 3rd Qu.:41.93   3rd Qu.:-87.63                     \n",
       " Max.   :42.17   Max.   :-87.49                     \n",
       " NA's   :5036    NA's   :5036                       "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Produce a summary of the dataframe.\n",
    "summary(bike_trip_df)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 5,
   "id": "f0a602c7",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:52:55.594391Z",
     "iopub.status.busy": "2022-07-26T13:52:55.592779Z",
     "iopub.status.idle": "2022-07-26T13:52:58.640692Z",
     "shell.execute_reply": "2022-07-26T13:52:58.638968Z"
    },
    "papermill": {
     "duration": 3.062423,
     "end_time": "2022-07-26T13:52:58.643093",
     "exception": false,
     "start_time": "2022-07-26T13:52:55.580670",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# Sort the started_at (Date and time when ride started) column by descending order so the most recent dates appear first.\n",
    "bike_trip_df_cleaned_v0 <- arrange(bike_trip_df, desc(started_at))\n",
    "\n",
    "# Remove latitudes and longitudes because I won't be using geographic data.\n",
    "bike_trip_df_cleaned_v1 <- select(bike_trip_df_cleaned_v0, -c(start_lat, start_lng, end_lat, end_lng))\n",
    "\n",
    "# Rename columns.\n",
    "bike_trip_df_cleaned_v2 <- rename(bike_trip_df_cleaned_v1, from_station = start_station_name, from_station_id = start_station_id, to_station = end_station_name, to_station_id = end_station_id, casual_or_member = member_casual)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 6,
   "id": "1a488968",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:52:58.666667Z",
     "iopub.status.busy": "2022-07-26T13:52:58.665144Z",
     "iopub.status.idle": "2022-07-26T13:52:58.690257Z",
     "shell.execute_reply": "2022-07-26T13:52:58.688643Z"
    },
    "papermill": {
     "duration": 0.039407,
     "end_time": "2022-07-26T13:52:58.692602",
     "exception": false,
     "start_time": "2022-07-26T13:52:58.653195",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A tibble: 6 × 9</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>ride_id</th><th scope=col>rideable_type</th><th scope=col>started_at</th><th scope=col>ended_at</th><th scope=col>from_station</th><th scope=col>from_station_id</th><th scope=col>to_station</th><th scope=col>to_station_id</th><th scope=col>casual_or_member</th></tr>\n",
       "\t<tr><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dttm&gt;</th><th scope=col>&lt;dttm&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>761981AEEA662B35</td><td>classic_bike </td><td>2022-05-31 23:59:56</td><td>2022-06-01 00:04:04</td><td>Lincoln Ave &amp; Fullerton Ave</td><td>TA1309000058</td><td>Sedgwick St &amp; Webster Ave</td><td><span style=white-space:pre-wrap>13191       </span></td><td>casual</td></tr>\n",
       "\t<tr><td>C4E039D12FA2F959</td><td>electric_bike</td><td>2022-05-31 23:59:38</td><td>2022-06-01 00:05:02</td><td>NA                         </td><td>NA          </td><td>NA                       </td><td>NA          </td><td>member</td></tr>\n",
       "\t<tr><td>A904966008DE7AF1</td><td>electric_bike</td><td>2022-05-31 23:59:23</td><td>2022-06-01 00:00:20</td><td><span style=white-space:pre-wrap>Elston Ave &amp; Wabansia Ave  </span></td><td>TA1309000032</td><td>Elston Ave &amp; Wabansia Ave</td><td>TA1309000032</td><td>member</td></tr>\n",
       "\t<tr><td>6F542133C328A000</td><td>classic_bike </td><td>2022-05-31 23:59:19</td><td>2022-06-01 00:22:53</td><td><span style=white-space:pre-wrap>Emerald Ave &amp; 31st St      </span></td><td>TA1309000055</td><td><span style=white-space:pre-wrap>Federal St &amp; Polk St     </span></td><td><span style=white-space:pre-wrap>SL-008      </span></td><td>member</td></tr>\n",
       "\t<tr><td>02C62B16DD557A08</td><td>electric_bike</td><td>2022-05-31 23:59:19</td><td>2022-06-01 00:04:12</td><td><span style=white-space:pre-wrap>NA                         </span></td><td><span style=white-space:pre-wrap>NA          </span></td><td><span style=white-space:pre-wrap>Clark St &amp; Grace St      </span></td><td>TA1307000127</td><td>casual</td></tr>\n",
       "\t<tr><td>FA9799B96E4FE352</td><td>electric_bike</td><td>2022-05-31 23:59:13</td><td>2022-06-01 00:05:38</td><td><span style=white-space:pre-wrap>NA                         </span></td><td><span style=white-space:pre-wrap>NA          </span></td><td><span style=white-space:pre-wrap>Halsted St &amp; Roscoe St   </span></td><td>TA1309000025</td><td>casual</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A tibble: 6 × 9\n",
       "\\begin{tabular}{lllllllll}\n",
       " ride\\_id & rideable\\_type & started\\_at & ended\\_at & from\\_station & from\\_station\\_id & to\\_station & to\\_station\\_id & casual\\_or\\_member\\\\\n",
       " <chr> & <chr> & <dttm> & <dttm> & <chr> & <chr> & <chr> & <chr> & <chr>\\\\\n",
       "\\hline\n",
       "\t 761981AEEA662B35 & classic\\_bike  & 2022-05-31 23:59:56 & 2022-06-01 00:04:04 & Lincoln Ave \\& Fullerton Ave & TA1309000058 & Sedgwick St \\& Webster Ave & 13191        & casual\\\\\n",
       "\t C4E039D12FA2F959 & electric\\_bike & 2022-05-31 23:59:38 & 2022-06-01 00:05:02 & NA                          & NA           & NA                        & NA           & member\\\\\n",
       "\t A904966008DE7AF1 & electric\\_bike & 2022-05-31 23:59:23 & 2022-06-01 00:00:20 & Elston Ave \\& Wabansia Ave   & TA1309000032 & Elston Ave \\& Wabansia Ave & TA1309000032 & member\\\\\n",
       "\t 6F542133C328A000 & classic\\_bike  & 2022-05-31 23:59:19 & 2022-06-01 00:22:53 & Emerald Ave \\& 31st St       & TA1309000055 & Federal St \\& Polk St      & SL-008       & member\\\\\n",
       "\t 02C62B16DD557A08 & electric\\_bike & 2022-05-31 23:59:19 & 2022-06-01 00:04:12 & NA                          & NA           & Clark St \\& Grace St       & TA1307000127 & casual\\\\\n",
       "\t FA9799B96E4FE352 & electric\\_bike & 2022-05-31 23:59:13 & 2022-06-01 00:05:38 & NA                          & NA           & Halsted St \\& Roscoe St    & TA1309000025 & casual\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A tibble: 6 × 9\n",
       "\n",
       "| ride_id &lt;chr&gt; | rideable_type &lt;chr&gt; | started_at &lt;dttm&gt; | ended_at &lt;dttm&gt; | from_station &lt;chr&gt; | from_station_id &lt;chr&gt; | to_station &lt;chr&gt; | to_station_id &lt;chr&gt; | casual_or_member &lt;chr&gt; |\n",
       "|---|---|---|---|---|---|---|---|---|\n",
       "| 761981AEEA662B35 | classic_bike  | 2022-05-31 23:59:56 | 2022-06-01 00:04:04 | Lincoln Ave &amp; Fullerton Ave | TA1309000058 | Sedgwick St &amp; Webster Ave | 13191        | casual |\n",
       "| C4E039D12FA2F959 | electric_bike | 2022-05-31 23:59:38 | 2022-06-01 00:05:02 | NA                          | NA           | NA                        | NA           | member |\n",
       "| A904966008DE7AF1 | electric_bike | 2022-05-31 23:59:23 | 2022-06-01 00:00:20 | Elston Ave &amp; Wabansia Ave   | TA1309000032 | Elston Ave &amp; Wabansia Ave | TA1309000032 | member |\n",
       "| 6F542133C328A000 | classic_bike  | 2022-05-31 23:59:19 | 2022-06-01 00:22:53 | Emerald Ave &amp; 31st St       | TA1309000055 | Federal St &amp; Polk St      | SL-008       | member |\n",
       "| 02C62B16DD557A08 | electric_bike | 2022-05-31 23:59:19 | 2022-06-01 00:04:12 | NA                          | NA           | Clark St &amp; Grace St       | TA1307000127 | casual |\n",
       "| FA9799B96E4FE352 | electric_bike | 2022-05-31 23:59:13 | 2022-06-01 00:05:38 | NA                          | NA           | Halsted St &amp; Roscoe St    | TA1309000025 | casual |\n",
       "\n"
      ],
      "text/plain": [
       "  ride_id          rideable_type started_at          ended_at           \n",
       "1 761981AEEA662B35 classic_bike  2022-05-31 23:59:56 2022-06-01 00:04:04\n",
       "2 C4E039D12FA2F959 electric_bike 2022-05-31 23:59:38 2022-06-01 00:05:02\n",
       "3 A904966008DE7AF1 electric_bike 2022-05-31 23:59:23 2022-06-01 00:00:20\n",
       "4 6F542133C328A000 classic_bike  2022-05-31 23:59:19 2022-06-01 00:22:53\n",
       "5 02C62B16DD557A08 electric_bike 2022-05-31 23:59:19 2022-06-01 00:04:12\n",
       "6 FA9799B96E4FE352 electric_bike 2022-05-31 23:59:13 2022-06-01 00:05:38\n",
       "  from_station                from_station_id to_station               \n",
       "1 Lincoln Ave & Fullerton Ave TA1309000058    Sedgwick St & Webster Ave\n",
       "2 NA                          NA              NA                       \n",
       "3 Elston Ave & Wabansia Ave   TA1309000032    Elston Ave & Wabansia Ave\n",
       "4 Emerald Ave & 31st St       TA1309000055    Federal St & Polk St     \n",
       "5 NA                          NA              Clark St & Grace St      \n",
       "6 NA                          NA              Halsted St & Roscoe St   \n",
       "  to_station_id casual_or_member\n",
       "1 13191         casual          \n",
       "2 NA            member          \n",
       "3 TA1309000032  member          \n",
       "4 SL-008        member          \n",
       "5 TA1307000127  casual          \n",
       "6 TA1309000025  casual          "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "head(bike_trip_df_cleaned_v2)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 7,
   "id": "2836ec14",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:52:58.718757Z",
     "iopub.status.busy": "2022-07-26T13:52:58.717165Z",
     "iopub.status.idle": "2022-07-26T13:53:11.777735Z",
     "shell.execute_reply": "2022-07-26T13:53:11.775947Z"
    },
    "papermill": {
     "duration": 13.076723,
     "end_time": "2022-07-26T13:53:11.780914",
     "exception": false,
     "start_time": "2022-07-26T13:52:58.704191",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# Add ride_length, day_of_week, month, season, and time_of_day columns to provide more ways to aggregate data.\n",
    "bike_trip_df_cleaned_v3 <- bike_trip_df_cleaned_v2 %>%\n",
    "  mutate(ride_length = round(difftime(ended_at, started_at, units = \"mins\"), 2))\n",
    "\n",
    "bike_trip_df_cleaned_v3$day_of_week <- weekdays(as.Date(bike_trip_df_cleaned_v3$started_at))\n",
    "#bike_trip_df_cleaned_v3$date <- as.Date(bike_trip_df_cleaned_v4$started_at)\n",
    "#bike_trip_df_cleaned_v3$year <- format(as.Date(bike_trip_df_cleaned_v4$date), \"%Y\")\n",
    "#bike_trip_df_cleaned_v3$month <- format(as.Date(bike_trip_df_cleaned_v3$started_at), \"%m\")\n",
    "\n",
    "seasons <- c(\n",
    "  \"01\" = \"Winter\", \"02\" = \"Winter\",\n",
    "  \"03\" = \"Spring\", \"04\" = \"Spring\", \"05\" = \"Spring\",\n",
    "  \"06\" = \"Summer\", \"07\" = \"Summer\", \"08\" = \"Summer\",\n",
    "  \"09\" = \"Fall\", \"10\" = \"Fall\", \"11\" = \"Fall\",\n",
    "  \"12\" = \"Winter\")\n",
    "bike_trip_df_cleaned_v3$season <- seasons[format(as.Date(bike_trip_df_cleaned_v3$started_at), \"%m\")]\n",
    "\n",
    "breaks <- hour(hm(\"00:00\", \"5:00\", \"11:00\", \"17:00\", \"20:00\", \"23:59\"))\n",
    "labels <- c(\"Night\", \"Morning\", \"Afternoon\", \"Evening\", \"Late_Evening\")\n",
    "bike_trip_df_cleaned_v3$time_of_day <- cut(x=hour(bike_trip_df_cleaned_v3$started_at), breaks = breaks, labels = labels, include.lowest=TRUE)\n",
    "# 00:00 - 06:00 is night\n",
    "# 06:00 - 12:00 is morning\n",
    "# 12:00 - 18:00 is afternoon\n",
    "# 18:00 - 21:00 is evening\n",
    "# 21:00 - 23:59 is late evening"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 8,
   "id": "a19e6a6c",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:11.806422Z",
     "iopub.status.busy": "2022-07-26T13:53:11.804865Z",
     "iopub.status.idle": "2022-07-26T13:53:11.840094Z",
     "shell.execute_reply": "2022-07-26T13:53:11.838368Z"
    },
    "papermill": {
     "duration": 0.050256,
     "end_time": "2022-07-26T13:53:11.842446",
     "exception": false,
     "start_time": "2022-07-26T13:53:11.792190",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<style>\n",
       ".list-inline {list-style: none; margin:0; padding: 0}\n",
       ".list-inline>li {display: inline-block}\n",
       ".list-inline>li:not(:last-child)::after {content: \"\\00b7\"; padding: 0 .5ex}\n",
       "</style>\n",
       "<ol class=list-inline><li>'ride_id'</li><li>'rideable_type'</li><li>'started_at'</li><li>'ended_at'</li><li>'from_station'</li><li>'from_station_id'</li><li>'to_station'</li><li>'to_station_id'</li><li>'casual_or_member'</li><li>'ride_length'</li><li>'day_of_week'</li><li>'season'</li><li>'time_of_day'</li></ol>\n"
      ],
      "text/latex": [
       "\\begin{enumerate*}\n",
       "\\item 'ride\\_id'\n",
       "\\item 'rideable\\_type'\n",
       "\\item 'started\\_at'\n",
       "\\item 'ended\\_at'\n",
       "\\item 'from\\_station'\n",
       "\\item 'from\\_station\\_id'\n",
       "\\item 'to\\_station'\n",
       "\\item 'to\\_station\\_id'\n",
       "\\item 'casual\\_or\\_member'\n",
       "\\item 'ride\\_length'\n",
       "\\item 'day\\_of\\_week'\n",
       "\\item 'season'\n",
       "\\item 'time\\_of\\_day'\n",
       "\\end{enumerate*}\n"
      ],
      "text/markdown": [
       "1. 'ride_id'\n",
       "2. 'rideable_type'\n",
       "3. 'started_at'\n",
       "4. 'ended_at'\n",
       "5. 'from_station'\n",
       "6. 'from_station_id'\n",
       "7. 'to_station'\n",
       "8. 'to_station_id'\n",
       "9. 'casual_or_member'\n",
       "10. 'ride_length'\n",
       "11. 'day_of_week'\n",
       "12. 'season'\n",
       "13. 'time_of_day'\n",
       "\n",
       "\n"
      ],
      "text/plain": [
       " [1] \"ride_id\"          \"rideable_type\"    \"started_at\"       \"ended_at\"        \n",
       " [5] \"from_station\"     \"from_station_id\"  \"to_station\"       \"to_station_id\"   \n",
       " [9] \"casual_or_member\" \"ride_length\"      \"day_of_week\"      \"season\"          \n",
       "[13] \"time_of_day\"     "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A tibble: 6 × 13</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>ride_id</th><th scope=col>rideable_type</th><th scope=col>started_at</th><th scope=col>ended_at</th><th scope=col>from_station</th><th scope=col>from_station_id</th><th scope=col>to_station</th><th scope=col>to_station_id</th><th scope=col>casual_or_member</th><th scope=col>ride_length</th><th scope=col>day_of_week</th><th scope=col>season</th><th scope=col>time_of_day</th></tr>\n",
       "\t<tr><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dttm&gt;</th><th scope=col>&lt;dttm&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;drtn&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;fct&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>761981AEEA662B35</td><td>classic_bike </td><td>2022-05-31 23:59:56</td><td>2022-06-01 00:04:04</td><td>Lincoln Ave &amp; Fullerton Ave</td><td>TA1309000058</td><td>Sedgwick St &amp; Webster Ave</td><td><span style=white-space:pre-wrap>13191       </span></td><td>casual</td><td> 4.13 mins</td><td>Tuesday</td><td>Spring</td><td>Late_Evening</td></tr>\n",
       "\t<tr><td>C4E039D12FA2F959</td><td>electric_bike</td><td>2022-05-31 23:59:38</td><td>2022-06-01 00:05:02</td><td>NA                         </td><td>NA          </td><td>NA                       </td><td>NA          </td><td>member</td><td> 5.40 mins</td><td>Tuesday</td><td>Spring</td><td>Late_Evening</td></tr>\n",
       "\t<tr><td>A904966008DE7AF1</td><td>electric_bike</td><td>2022-05-31 23:59:23</td><td>2022-06-01 00:00:20</td><td><span style=white-space:pre-wrap>Elston Ave &amp; Wabansia Ave  </span></td><td>TA1309000032</td><td>Elston Ave &amp; Wabansia Ave</td><td>TA1309000032</td><td>member</td><td> 0.95 mins</td><td>Tuesday</td><td>Spring</td><td>Late_Evening</td></tr>\n",
       "\t<tr><td>6F542133C328A000</td><td>classic_bike </td><td>2022-05-31 23:59:19</td><td>2022-06-01 00:22:53</td><td><span style=white-space:pre-wrap>Emerald Ave &amp; 31st St      </span></td><td>TA1309000055</td><td><span style=white-space:pre-wrap>Federal St &amp; Polk St     </span></td><td><span style=white-space:pre-wrap>SL-008      </span></td><td>member</td><td>23.57 mins</td><td>Tuesday</td><td>Spring</td><td>Late_Evening</td></tr>\n",
       "\t<tr><td>02C62B16DD557A08</td><td>electric_bike</td><td>2022-05-31 23:59:19</td><td>2022-06-01 00:04:12</td><td><span style=white-space:pre-wrap>NA                         </span></td><td><span style=white-space:pre-wrap>NA          </span></td><td><span style=white-space:pre-wrap>Clark St &amp; Grace St      </span></td><td>TA1307000127</td><td>casual</td><td> 4.88 mins</td><td>Tuesday</td><td>Spring</td><td>Late_Evening</td></tr>\n",
       "\t<tr><td>FA9799B96E4FE352</td><td>electric_bike</td><td>2022-05-31 23:59:13</td><td>2022-06-01 00:05:38</td><td><span style=white-space:pre-wrap>NA                         </span></td><td><span style=white-space:pre-wrap>NA          </span></td><td><span style=white-space:pre-wrap>Halsted St &amp; Roscoe St   </span></td><td>TA1309000025</td><td>casual</td><td> 6.42 mins</td><td>Tuesday</td><td>Spring</td><td>Late_Evening</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A tibble: 6 × 13\n",
       "\\begin{tabular}{lllllllllllll}\n",
       " ride\\_id & rideable\\_type & started\\_at & ended\\_at & from\\_station & from\\_station\\_id & to\\_station & to\\_station\\_id & casual\\_or\\_member & ride\\_length & day\\_of\\_week & season & time\\_of\\_day\\\\\n",
       " <chr> & <chr> & <dttm> & <dttm> & <chr> & <chr> & <chr> & <chr> & <chr> & <drtn> & <chr> & <chr> & <fct>\\\\\n",
       "\\hline\n",
       "\t 761981AEEA662B35 & classic\\_bike  & 2022-05-31 23:59:56 & 2022-06-01 00:04:04 & Lincoln Ave \\& Fullerton Ave & TA1309000058 & Sedgwick St \\& Webster Ave & 13191        & casual &  4.13 mins & Tuesday & Spring & Late\\_Evening\\\\\n",
       "\t C4E039D12FA2F959 & electric\\_bike & 2022-05-31 23:59:38 & 2022-06-01 00:05:02 & NA                          & NA           & NA                        & NA           & member &  5.40 mins & Tuesday & Spring & Late\\_Evening\\\\\n",
       "\t A904966008DE7AF1 & electric\\_bike & 2022-05-31 23:59:23 & 2022-06-01 00:00:20 & Elston Ave \\& Wabansia Ave   & TA1309000032 & Elston Ave \\& Wabansia Ave & TA1309000032 & member &  0.95 mins & Tuesday & Spring & Late\\_Evening\\\\\n",
       "\t 6F542133C328A000 & classic\\_bike  & 2022-05-31 23:59:19 & 2022-06-01 00:22:53 & Emerald Ave \\& 31st St       & TA1309000055 & Federal St \\& Polk St      & SL-008       & member & 23.57 mins & Tuesday & Spring & Late\\_Evening\\\\\n",
       "\t 02C62B16DD557A08 & electric\\_bike & 2022-05-31 23:59:19 & 2022-06-01 00:04:12 & NA                          & NA           & Clark St \\& Grace St       & TA1307000127 & casual &  4.88 mins & Tuesday & Spring & Late\\_Evening\\\\\n",
       "\t FA9799B96E4FE352 & electric\\_bike & 2022-05-31 23:59:13 & 2022-06-01 00:05:38 & NA                          & NA           & Halsted St \\& Roscoe St    & TA1309000025 & casual &  6.42 mins & Tuesday & Spring & Late\\_Evening\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A tibble: 6 × 13\n",
       "\n",
       "| ride_id &lt;chr&gt; | rideable_type &lt;chr&gt; | started_at &lt;dttm&gt; | ended_at &lt;dttm&gt; | from_station &lt;chr&gt; | from_station_id &lt;chr&gt; | to_station &lt;chr&gt; | to_station_id &lt;chr&gt; | casual_or_member &lt;chr&gt; | ride_length &lt;drtn&gt; | day_of_week &lt;chr&gt; | season &lt;chr&gt; | time_of_day &lt;fct&gt; |\n",
       "|---|---|---|---|---|---|---|---|---|---|---|---|---|\n",
       "| 761981AEEA662B35 | classic_bike  | 2022-05-31 23:59:56 | 2022-06-01 00:04:04 | Lincoln Ave &amp; Fullerton Ave | TA1309000058 | Sedgwick St &amp; Webster Ave | 13191        | casual |  4.13 mins | Tuesday | Spring | Late_Evening |\n",
       "| C4E039D12FA2F959 | electric_bike | 2022-05-31 23:59:38 | 2022-06-01 00:05:02 | NA                          | NA           | NA                        | NA           | member |  5.40 mins | Tuesday | Spring | Late_Evening |\n",
       "| A904966008DE7AF1 | electric_bike | 2022-05-31 23:59:23 | 2022-06-01 00:00:20 | Elston Ave &amp; Wabansia Ave   | TA1309000032 | Elston Ave &amp; Wabansia Ave | TA1309000032 | member |  0.95 mins | Tuesday | Spring | Late_Evening |\n",
       "| 6F542133C328A000 | classic_bike  | 2022-05-31 23:59:19 | 2022-06-01 00:22:53 | Emerald Ave &amp; 31st St       | TA1309000055 | Federal St &amp; Polk St      | SL-008       | member | 23.57 mins | Tuesday | Spring | Late_Evening |\n",
       "| 02C62B16DD557A08 | electric_bike | 2022-05-31 23:59:19 | 2022-06-01 00:04:12 | NA                          | NA           | Clark St &amp; Grace St       | TA1307000127 | casual |  4.88 mins | Tuesday | Spring | Late_Evening |\n",
       "| FA9799B96E4FE352 | electric_bike | 2022-05-31 23:59:13 | 2022-06-01 00:05:38 | NA                          | NA           | Halsted St &amp; Roscoe St    | TA1309000025 | casual |  6.42 mins | Tuesday | Spring | Late_Evening |\n",
       "\n"
      ],
      "text/plain": [
       "  ride_id          rideable_type started_at          ended_at           \n",
       "1 761981AEEA662B35 classic_bike  2022-05-31 23:59:56 2022-06-01 00:04:04\n",
       "2 C4E039D12FA2F959 electric_bike 2022-05-31 23:59:38 2022-06-01 00:05:02\n",
       "3 A904966008DE7AF1 electric_bike 2022-05-31 23:59:23 2022-06-01 00:00:20\n",
       "4 6F542133C328A000 classic_bike  2022-05-31 23:59:19 2022-06-01 00:22:53\n",
       "5 02C62B16DD557A08 electric_bike 2022-05-31 23:59:19 2022-06-01 00:04:12\n",
       "6 FA9799B96E4FE352 electric_bike 2022-05-31 23:59:13 2022-06-01 00:05:38\n",
       "  from_station                from_station_id to_station               \n",
       "1 Lincoln Ave & Fullerton Ave TA1309000058    Sedgwick St & Webster Ave\n",
       "2 NA                          NA              NA                       \n",
       "3 Elston Ave & Wabansia Ave   TA1309000032    Elston Ave & Wabansia Ave\n",
       "4 Emerald Ave & 31st St       TA1309000055    Federal St & Polk St     \n",
       "5 NA                          NA              Clark St & Grace St      \n",
       "6 NA                          NA              Halsted St & Roscoe St   \n",
       "  to_station_id casual_or_member ride_length day_of_week season time_of_day \n",
       "1 13191         casual            4.13 mins  Tuesday     Spring Late_Evening\n",
       "2 NA            member            5.40 mins  Tuesday     Spring Late_Evening\n",
       "3 TA1309000032  member            0.95 mins  Tuesday     Spring Late_Evening\n",
       "4 SL-008        member           23.57 mins  Tuesday     Spring Late_Evening\n",
       "5 TA1307000127  casual            4.88 mins  Tuesday     Spring Late_Evening\n",
       "6 TA1309000025  casual            6.42 mins  Tuesday     Spring Late_Evening"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "colnames(bike_trip_df_cleaned_v3)\n",
    "\n",
    "head(bike_trip_df_cleaned_v3)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 9,
   "id": "36f597f6",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:11.867654Z",
     "iopub.status.busy": "2022-07-26T13:53:11.866106Z",
     "iopub.status.idle": "2022-07-26T13:53:11.910629Z",
     "shell.execute_reply": "2022-07-26T13:53:11.908457Z"
    },
    "papermill": {
     "duration": 0.060366,
     "end_time": "2022-07-26T13:53:11.913829",
     "exception": false,
     "start_time": "2022-07-26T13:53:11.853463",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "tibble [5,860,776 × 13] (S3: tbl_df/tbl/data.frame)\n",
      " $ ride_id         : chr [1:5860776] \"761981AEEA662B35\" \"C4E039D12FA2F959\" \"A904966008DE7AF1\" \"6F542133C328A000\" ...\n",
      " $ rideable_type   : chr [1:5860776] \"classic_bike\" \"electric_bike\" \"electric_bike\" \"classic_bike\" ...\n",
      " $ started_at      : POSIXct[1:5860776], format: \"2022-05-31 23:59:56\" \"2022-05-31 23:59:38\" ...\n",
      " $ ended_at        : POSIXct[1:5860776], format: \"2022-06-01 00:04:04\" \"2022-06-01 00:05:02\" ...\n",
      " $ from_station    : chr [1:5860776] \"Lincoln Ave & Fullerton Ave\" NA \"Elston Ave & Wabansia Ave\" \"Emerald Ave & 31st St\" ...\n",
      " $ from_station_id : chr [1:5860776] \"TA1309000058\" NA \"TA1309000032\" \"TA1309000055\" ...\n",
      " $ to_station      : chr [1:5860776] \"Sedgwick St & Webster Ave\" NA \"Elston Ave & Wabansia Ave\" \"Federal St & Polk St\" ...\n",
      " $ to_station_id   : chr [1:5860776] \"13191\" NA \"TA1309000032\" \"SL-008\" ...\n",
      " $ casual_or_member: chr [1:5860776] \"casual\" \"member\" \"member\" \"member\" ...\n",
      " $ ride_length     : 'difftime' num [1:5860776] 4.13 5.4 0.95 23.57 ...\n",
      "  ..- attr(*, \"units\")= chr \"mins\"\n",
      " $ day_of_week     : chr [1:5860776] \"Tuesday\" \"Tuesday\" \"Tuesday\" \"Tuesday\" ...\n",
      " $ season          : Named chr [1:5860776] \"Spring\" \"Spring\" \"Spring\" \"Spring\" ...\n",
      "  ..- attr(*, \"names\")= chr [1:5860776] \"05\" \"05\" \"05\" \"05\" ...\n",
      " $ time_of_day     : Factor w/ 5 levels \"Night\",\"Morning\",..: 5 5 5 5 5 5 5 5 5 5 ...\n"
     ]
    }
   ],
   "source": [
    "# Structure of the dataframe.\n",
    "str(bike_trip_df_cleaned_v3)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 10,
   "id": "85bfdc6e",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:11.939858Z",
     "iopub.status.busy": "2022-07-26T13:53:11.938268Z",
     "iopub.status.idle": "2022-07-26T13:53:13.952641Z",
     "shell.execute_reply": "2022-07-26T13:53:13.950931Z"
    },
    "papermill": {
     "duration": 2.030033,
     "end_time": "2022-07-26T13:53:13.955193",
     "exception": false,
     "start_time": "2022-07-26T13:53:11.925160",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# Change the data type of rideable_type, casual_or_member, day_of_week, and season columns to factor because they are categorical data.\n",
    "bike_trip_df_cleaned_v3$rideable_type <- as.factor(bike_trip_df_cleaned_v3$rideable_type)\n",
    "bike_trip_df_cleaned_v3$casual_or_member <- as.factor(bike_trip_df_cleaned_v3$casual_or_member)\n",
    "bike_trip_df_cleaned_v3$day_of_week <- as.factor(bike_trip_df_cleaned_v3$day_of_week)\n",
    "bike_trip_df_cleaned_v3$season <- as.factor(bike_trip_df_cleaned_v3$season)\n",
    "\n",
    "# Order the categorical levels of day_of_week, season and time_of_day columns.\n",
    "bike_trip_df_cleaned_v3$day_of_week <- ordered(bike_trip_df_cleaned_v3$day_of_week, levels=c(\"Monday\", \"Tuesday\", \"Wednesday\", \"Thursday\", \"Friday\", \"Saturday\", \"Sunday\"))\n",
    "bike_trip_df_cleaned_v3$season <- ordered(bike_trip_df_cleaned_v3$season, levels=c(\"Spring\", \"Summer\", \"Fall\", \"Winter\"))\n",
    "bike_trip_df_cleaned_v3$time_of_day <- ordered(bike_trip_df_cleaned_v3$time_of_day, levels=c(\"Morning\", \"Afternoon\", \"Evening\", \"Late_Evening\", \"Night\"))\n",
    "\n",
    "# Change the data type of the ride_length column to numeric and rename it.\n",
    "bike_trip_df_cleaned_v3$ride_length <- as.numeric(bike_trip_df_cleaned_v3$ride_length)\n",
    "bike_trip_df_cleaned_v3 <- rename(bike_trip_df_cleaned_v3, ride_length_in_mins = ride_length)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 11,
   "id": "a289d098",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:13.981959Z",
     "iopub.status.busy": "2022-07-26T13:53:13.980438Z",
     "iopub.status.idle": "2022-07-26T13:53:14.018963Z",
     "shell.execute_reply": "2022-07-26T13:53:14.016589Z"
    },
    "papermill": {
     "duration": 0.054933,
     "end_time": "2022-07-26T13:53:14.022083",
     "exception": false,
     "start_time": "2022-07-26T13:53:13.967150",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "tibble [5,860,776 × 13] (S3: tbl_df/tbl/data.frame)\n",
      " $ ride_id            : chr [1:5860776] \"761981AEEA662B35\" \"C4E039D12FA2F959\" \"A904966008DE7AF1\" \"6F542133C328A000\" ...\n",
      " $ rideable_type      : Factor w/ 3 levels \"classic_bike\",..: 1 3 3 1 3 3 3 3 1 3 ...\n",
      " $ started_at         : POSIXct[1:5860776], format: \"2022-05-31 23:59:56\" \"2022-05-31 23:59:38\" ...\n",
      " $ ended_at           : POSIXct[1:5860776], format: \"2022-06-01 00:04:04\" \"2022-06-01 00:05:02\" ...\n",
      " $ from_station       : chr [1:5860776] \"Lincoln Ave & Fullerton Ave\" NA \"Elston Ave & Wabansia Ave\" \"Emerald Ave & 31st St\" ...\n",
      " $ from_station_id    : chr [1:5860776] \"TA1309000058\" NA \"TA1309000032\" \"TA1309000055\" ...\n",
      " $ to_station         : chr [1:5860776] \"Sedgwick St & Webster Ave\" NA \"Elston Ave & Wabansia Ave\" \"Federal St & Polk St\" ...\n",
      " $ to_station_id      : chr [1:5860776] \"13191\" NA \"TA1309000032\" \"SL-008\" ...\n",
      " $ casual_or_member   : Factor w/ 2 levels \"casual\",\"member\": 1 2 2 2 1 1 2 1 2 1 ...\n",
      " $ ride_length_in_mins: num [1:5860776] 4.13 5.4 0.95 23.57 4.88 ...\n",
      " $ day_of_week        : Ord.factor w/ 7 levels \"Monday\"<\"Tuesday\"<..: 2 2 2 2 2 2 2 2 2 2 ...\n",
      " $ season             : Ord.factor w/ 4 levels \"Spring\"<\"Summer\"<..: 1 1 1 1 1 1 1 1 1 1 ...\n",
      "  ..- attr(*, \"names\")= chr [1:5860776] \"05\" \"05\" \"05\" \"05\" ...\n",
      " $ time_of_day        : Ord.factor w/ 5 levels \"Morning\"<\"Afternoon\"<..: 4 4 4 4 4 4 4 4 4 4 ...\n"
     ]
    }
   ],
   "source": [
    "str(bike_trip_df_cleaned_v3)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 12,
   "id": "bf9ae69f",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:14.048015Z",
     "iopub.status.busy": "2022-07-26T13:53:14.046510Z",
     "iopub.status.idle": "2022-07-26T13:53:17.065644Z",
     "shell.execute_reply": "2022-07-26T13:53:17.063956Z"
    },
    "papermill": {
     "duration": 3.034351,
     "end_time": "2022-07-26T13:53:17.067931",
     "exception": false,
     "start_time": "2022-07-26T13:53:14.033580",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/plain": [
       "   ride_id                rideable_type       started_at                 \n",
       " Length:5860776     classic_bike :3217737   Min.   :2021-06-01 00:00:38  \n",
       " Class :character   docked_bike  : 274447   1st Qu.:2021-07-29 10:43:32  \n",
       " Mode  :character   electric_bike:2368592   Median :2021-09-23 17:33:23  \n",
       "                                            Mean   :2021-10-26 03:44:54  \n",
       "                                            3rd Qu.:2022-01-14 10:59:12  \n",
       "                                            Max.   :2022-05-31 23:59:56  \n",
       "                                                                         \n",
       "    ended_at                   from_station       from_station_id   \n",
       " Min.   :2021-06-01 00:06:22   Length:5860776     Length:5860776    \n",
       " 1st Qu.:2021-07-29 11:02:56   Class :character   Class :character  \n",
       " Median :2021-09-23 17:49:29   Mode  :character   Mode  :character  \n",
       " Mean   :2021-10-26 04:05:36                                        \n",
       " 3rd Qu.:2022-01-14 11:14:48                                        \n",
       " Max.   :2022-06-02 11:35:01                                        \n",
       "                                                                    \n",
       "  to_station        to_station_id      casual_or_member ride_length_in_mins\n",
       " Length:5860776     Length:5860776     casual:2559857   Min.   :  -58.03   \n",
       " Class :character   Class :character   member:3300919   1st Qu.:    6.37   \n",
       " Mode  :character   Mode  :character                    Median :   11.33   \n",
       "                                                        Mean   :   20.69   \n",
       "                                                        3rd Qu.:   20.60   \n",
       "                                                        Max.   :55944.15   \n",
       "                                                                           \n",
       "    day_of_week        season              time_of_day     \n",
       " Monday   :768193   Spring:1290149   Morning     :1370714  \n",
       " Tuesday  :811829   Summer:2356357   Afternoon   :2541908  \n",
       " Wednesday:798404   Fall  :1747351   Evening     :1142678  \n",
       " Thursday :810424   Winter: 466919   Late_Evening: 526055  \n",
       " Friday   :819813                    Night       : 279421  \n",
       " Saturday :987206                                          \n",
       " Sunday   :864907                                          "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "summary(bike_trip_df_cleaned_v3)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 13,
   "id": "69144518",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:17.094573Z",
     "iopub.status.busy": "2022-07-26T13:53:17.093028Z",
     "iopub.status.idle": "2022-07-26T13:53:23.000533Z",
     "shell.execute_reply": "2022-07-26T13:53:22.998650Z"
    },
    "papermill": {
     "duration": 5.92346,
     "end_time": "2022-07-26T13:53:23.003209",
     "exception": false,
     "start_time": "2022-07-26T13:53:17.079749",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# I noticed the minimum of ride length is negative which could be caused when start_time > end_time. Therefore, I am going to remove rows where the started_at date is greater than the ended_at date.\n",
    "bike_trip_df_cleaned_v4 <- filter(bike_trip_df_cleaned_v3, !started_at > ended_at)\n",
    "\n",
    "# Also remove rows where ride_length is equal to 0 minutes.\n",
    "bike_trip_df_cleaned_v4 <- filter(bike_trip_df_cleaned_v4, ride_length_in_mins != 0)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 14,
   "id": "4313ae7d",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:23.030278Z",
     "iopub.status.busy": "2022-07-26T13:53:23.028742Z",
     "iopub.status.idle": "2022-07-26T13:53:28.815207Z",
     "shell.execute_reply": "2022-07-26T13:53:28.813373Z"
    },
    "papermill": {
     "duration": 5.803188,
     "end_time": "2022-07-26T13:53:28.818313",
     "exception": false,
     "start_time": "2022-07-26T13:53:23.015125",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/plain": [
       "   ride_id                rideable_type       started_at                 \n",
       " Length:5860130     classic_bike :3217479   Min.   :2021-06-01 00:00:38  \n",
       " Class :character   docked_bike  : 274440   1st Qu.:2021-07-29 10:42:03  \n",
       " Mode  :character   electric_bike:2368211   Median :2021-09-23 17:33:16  \n",
       "                                            Mean   :2021-10-26 03:46:57  \n",
       "                                            3rd Qu.:2022-01-14 11:14:06  \n",
       "                                            Max.   :2022-05-31 23:59:56  \n",
       "                                                                         \n",
       "    ended_at                   from_station       from_station_id   \n",
       " Min.   :2021-06-01 00:06:22   Length:5860130     Length:5860130    \n",
       " 1st Qu.:2021-07-29 11:02:00   Class :character   Class :character  \n",
       " Median :2021-09-23 17:49:24   Mode  :character   Mode  :character  \n",
       " Mean   :2021-10-26 04:07:39                                        \n",
       " 3rd Qu.:2022-01-14 11:29:08                                        \n",
       " Max.   :2022-06-02 11:35:01                                        \n",
       "                                                                    \n",
       "  to_station        to_station_id      casual_or_member ride_length_in_mins\n",
       " Length:5860130     Length:5860130     casual:2559501   Min.   :    0.02   \n",
       " Class :character   Class :character   member:3300629   1st Qu.:    6.37   \n",
       " Mode  :character   Mode  :character                    Median :   11.35   \n",
       "                                                        Mean   :   20.69   \n",
       "                                                        3rd Qu.:   20.60   \n",
       "                                                        Max.   :55944.15   \n",
       "                                                                           \n",
       "    day_of_week        season              time_of_day     \n",
       " Monday   :768128   Spring:1290052   Morning     :1370601  \n",
       " Tuesday  :811755   Summer:2356102   Afternoon   :2541647  \n",
       " Wednesday:798297   Fall  :1747088   Evening     :1142543  \n",
       " Thursday :810362   Winter: 466888   Late_Evening: 525997  \n",
       " Friday   :819735                    Night       : 279342  \n",
       " Saturday :987105                                          \n",
       " Sunday   :864748                                          "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "summary(bike_trip_df_cleaned_v4)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 15,
   "id": "e44c902d",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:28.845510Z",
     "iopub.status.busy": "2022-07-26T13:53:28.843795Z",
     "iopub.status.idle": "2022-07-26T13:53:28.859083Z",
     "shell.execute_reply": "2022-07-26T13:53:28.857283Z"
    },
    "papermill": {
     "duration": 0.031585,
     "end_time": "2022-07-26T13:53:28.862104",
     "exception": false,
     "start_time": "2022-07-26T13:53:28.830519",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# Disable warming from summarize/summaries since it doesn't affect our result.\n",
    "options(dplyr.summarise.inform = FALSE)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 16,
   "id": "68a6124f",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:28.897006Z",
     "iopub.status.busy": "2022-07-26T13:53:28.895514Z",
     "iopub.status.idle": "2022-07-26T13:53:29.700716Z",
     "shell.execute_reply": "2022-07-26T13:53:29.698634Z"
    },
    "papermill": {
     "duration": 0.830322,
     "end_time": "2022-07-26T13:53:29.703698",
     "exception": false,
     "start_time": "2022-07-26T13:53:28.873376",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/plain": [
       "    Min.  1st Qu.   Median     Mean  3rd Qu.     Max. \n",
       "    0.02     6.37    11.35    20.69    20.60 55944.15 "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Summary of the ride_length_in_mins column.\n",
    "summary(bike_trip_df_cleaned_v4$ride_length_in_mins)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 17,
   "id": "d2184f99",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:29.730154Z",
     "iopub.status.busy": "2022-07-26T13:53:29.728591Z",
     "iopub.status.idle": "2022-07-26T13:53:29.748347Z",
     "shell.execute_reply": "2022-07-26T13:53:29.746109Z"
    },
    "papermill": {
     "duration": 0.03633,
     "end_time": "2022-07-26T13:53:29.751412",
     "exception": false,
     "start_time": "2022-07-26T13:53:29.715082",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "41.945"
      ],
      "text/latex": [
       "41.945"
      ],
      "text/markdown": [
       "41.945"
      ],
      "text/plain": [
       "[1] 41.945"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# From the previous results, we can see the maximum ride length is 55944.15 minutes (about 932 hours) which is unrealistic. Therefore, I decided to use the interquartile range method to define outliers and remove them. Any value above the upper fence will be considered outliers.\n",
    "# Upper fence: Q3 + (1.5 * IQR)\n",
    "# IQR = Q3 - Q1\n",
    "20.60 + (1.5 * (20.60 - 6.37)) # Upper limit for ride length"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 18,
   "id": "3d1dd642",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:29.779243Z",
     "iopub.status.busy": "2022-07-26T13:53:29.777724Z",
     "iopub.status.idle": "2022-07-26T13:53:29.902281Z",
     "shell.execute_reply": "2022-07-26T13:53:29.899994Z"
    },
    "papermill": {
     "duration": 0.142017,
     "end_time": "2022-07-26T13:53:29.905224",
     "exception": false,
     "start_time": "2022-07-26T13:53:29.763207",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<strong>2.5%:</strong> 1.68"
      ],
      "text/latex": [
       "\\textbf{2.5\\textbackslash{}\\%:} 1.68"
      ],
      "text/markdown": [
       "**2.5%:** 1.68"
      ],
      "text/plain": [
       "2.5% \n",
       "1.68 "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Also, the minimum ride length is 0.02 minutes or 1.2 seconds which is unrealistic as well. The interquartile range method doesn't work for the lower fence because I will get a negative number. Hence, I will take the simple approach. Any value less than 0.025 percentile (bottom 2.5%) will be considered as outliers.\n",
    "quantile(bike_trip_df_cleaned_v4$ride_length_in_mins, 0.025)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 19,
   "id": "7535409a",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:29.934042Z",
     "iopub.status.busy": "2022-07-26T13:53:29.932527Z",
     "iopub.status.idle": "2022-07-26T13:53:30.755146Z",
     "shell.execute_reply": "2022-07-26T13:53:30.753341Z"
    },
    "papermill": {
     "duration": 0.840413,
     "end_time": "2022-07-26T13:53:30.757830",
     "exception": false,
     "start_time": "2022-07-26T13:53:29.917417",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# Based on value from previous steps and some research on the company's bike usage time limit, It's safe to assume that ride length more than 45 minutes or less than 1.68 minutes are outliers and will be removed and saved to another dataframe.\n",
    "ride_length_outliers <- filter(bike_trip_df_cleaned_v4, ride_length_in_mins > 45 | ride_length_in_mins < 1.68)\n",
    "bike_trip_df_final <- filter(bike_trip_df_cleaned_v4, ride_length_in_mins <= 45 & ride_length_in_mins >= 1.68)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 20,
   "id": "12dbc2c3",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:30.785137Z",
     "iopub.status.busy": "2022-07-26T13:53:30.783522Z",
     "iopub.status.idle": "2022-07-26T13:53:31.137556Z",
     "shell.execute_reply": "2022-07-26T13:53:31.135813Z"
    },
    "papermill": {
     "duration": 0.37011,
     "end_time": "2022-07-26T13:53:31.139854",
     "exception": false,
     "start_time": "2022-07-26T13:53:30.769744",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A tibble: 2 × 6</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>casual_or_member</th><th scope=col>number_of_rides</th><th scope=col>average_ride_length</th><th scope=col>minimum_ride_length</th><th scope=col>median_ride_length</th><th scope=col>maximum_ride_length</th></tr>\n",
       "\t<tr><th scope=col>&lt;fct&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>casual</td><td>2189030</td><td>16.15968</td><td>1.68</td><td>13.63</td><td>45</td></tr>\n",
       "\t<tr><td>member</td><td>3150040</td><td>11.85977</td><td>1.68</td><td> 9.22</td><td>45</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A tibble: 2 × 6\n",
       "\\begin{tabular}{llllll}\n",
       " casual\\_or\\_member & number\\_of\\_rides & average\\_ride\\_length & minimum\\_ride\\_length & median\\_ride\\_length & maximum\\_ride\\_length\\\\\n",
       " <fct> & <int> & <dbl> & <dbl> & <dbl> & <dbl>\\\\\n",
       "\\hline\n",
       "\t casual & 2189030 & 16.15968 & 1.68 & 13.63 & 45\\\\\n",
       "\t member & 3150040 & 11.85977 & 1.68 &  9.22 & 45\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A tibble: 2 × 6\n",
       "\n",
       "| casual_or_member &lt;fct&gt; | number_of_rides &lt;int&gt; | average_ride_length &lt;dbl&gt; | minimum_ride_length &lt;dbl&gt; | median_ride_length &lt;dbl&gt; | maximum_ride_length &lt;dbl&gt; |\n",
       "|---|---|---|---|---|---|\n",
       "| casual | 2189030 | 16.15968 | 1.68 | 13.63 | 45 |\n",
       "| member | 3150040 | 11.85977 | 1.68 |  9.22 | 45 |\n",
       "\n"
      ],
      "text/plain": [
       "  casual_or_member number_of_rides average_ride_length minimum_ride_length\n",
       "1 casual           2189030         16.15968            1.68               \n",
       "2 member           3150040         11.85977            1.68               \n",
       "  median_ride_length maximum_ride_length\n",
       "1 13.63              45                 \n",
       "2  9.22              45                 "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Number of rides, average, minimum, median, and maximum of ride length in minutes by customer type.\n",
    "bike_trip_df_final %>%\n",
    "  group_by(casual_or_member) %>%\n",
    "  summarize(number_of_rides = n(),\n",
    "            average_ride_length = mean(ride_length_in_mins),\n",
    "            minimum_ride_length = min(ride_length_in_mins),\n",
    "            median_ride_length = median(ride_length_in_mins),\n",
    "            maximum_ride_length = max(ride_length_in_mins))"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 21,
   "id": "0508c15c",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:31.167844Z",
     "iopub.status.busy": "2022-07-26T13:53:31.166263Z",
     "iopub.status.idle": "2022-07-26T13:53:31.900997Z",
     "shell.execute_reply": "2022-07-26T13:53:31.899334Z"
    },
    "papermill": {
     "duration": 0.751554,
     "end_time": "2022-07-26T13:53:31.903441",
     "exception": false,
     "start_time": "2022-07-26T13:53:31.151887",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A grouped_df: 8 × 4</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>season</th><th scope=col>casual_or_member</th><th scope=col>number_of_rides</th><th scope=col>average_ride_length</th></tr>\n",
       "\t<tr><th scope=col>&lt;ord&gt;</th><th scope=col>&lt;fct&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>Spring</td><td>casual</td><td> 423099</td><td>15.85046</td></tr>\n",
       "\t<tr><td>Spring</td><td>member</td><td> 754447</td><td>11.40701</td></tr>\n",
       "\t<tr><td>Summer</td><td>casual</td><td>1028024</td><td>17.00123</td></tr>\n",
       "\t<tr><td>Summer</td><td>member</td><td>1078923</td><td>12.99853</td></tr>\n",
       "\t<tr><td>Fall  </td><td>casual</td><td> 637486</td><td>15.48214</td></tr>\n",
       "\t<tr><td>Fall  </td><td>member</td><td> 974928</td><td>11.53999</td></tr>\n",
       "\t<tr><td>Winter</td><td>casual</td><td> 100421</td><td>13.14868</td></tr>\n",
       "\t<tr><td>Winter</td><td>member</td><td> 341742</td><td>10.17637</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A grouped\\_df: 8 × 4\n",
       "\\begin{tabular}{llll}\n",
       " season & casual\\_or\\_member & number\\_of\\_rides & average\\_ride\\_length\\\\\n",
       " <ord> & <fct> & <int> & <dbl>\\\\\n",
       "\\hline\n",
       "\t Spring & casual &  423099 & 15.85046\\\\\n",
       "\t Spring & member &  754447 & 11.40701\\\\\n",
       "\t Summer & casual & 1028024 & 17.00123\\\\\n",
       "\t Summer & member & 1078923 & 12.99853\\\\\n",
       "\t Fall   & casual &  637486 & 15.48214\\\\\n",
       "\t Fall   & member &  974928 & 11.53999\\\\\n",
       "\t Winter & casual &  100421 & 13.14868\\\\\n",
       "\t Winter & member &  341742 & 10.17637\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A grouped_df: 8 × 4\n",
       "\n",
       "| season &lt;ord&gt; | casual_or_member &lt;fct&gt; | number_of_rides &lt;int&gt; | average_ride_length &lt;dbl&gt; |\n",
       "|---|---|---|---|\n",
       "| Spring | casual |  423099 | 15.85046 |\n",
       "| Spring | member |  754447 | 11.40701 |\n",
       "| Summer | casual | 1028024 | 17.00123 |\n",
       "| Summer | member | 1078923 | 12.99853 |\n",
       "| Fall   | casual |  637486 | 15.48214 |\n",
       "| Fall   | member |  974928 | 11.53999 |\n",
       "| Winter | casual |  100421 | 13.14868 |\n",
       "| Winter | member |  341742 | 10.17637 |\n",
       "\n"
      ],
      "text/plain": [
       "  season casual_or_member number_of_rides average_ride_length\n",
       "1 Spring casual            423099         15.85046           \n",
       "2 Spring member            754447         11.40701           \n",
       "3 Summer casual           1028024         17.00123           \n",
       "4 Summer member           1078923         12.99853           \n",
       "5 Fall   casual            637486         15.48214           \n",
       "6 Fall   member            974928         11.53999           \n",
       "7 Winter casual            100421         13.14868           \n",
       "8 Winter member            341742         10.17637           "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Number of rides, average, minimum, median, and maximum of ride length in minutes by customer type per season.\n",
    "bike_trip_df_final %>%\n",
    "  group_by(season, casual_or_member) %>%\n",
    "  summarize(number_of_rides = n(),\n",
    "            average_ride_length = mean(ride_length_in_mins))"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 22,
   "id": "4e80629c",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:31.932511Z",
     "iopub.status.busy": "2022-07-26T13:53:31.930972Z",
     "iopub.status.idle": "2022-07-26T13:53:32.896214Z",
     "shell.execute_reply": "2022-07-26T13:53:32.894538Z"
    },
    "papermill": {
     "duration": 0.982431,
     "end_time": "2022-07-26T13:53:32.898444",
     "exception": false,
     "start_time": "2022-07-26T13:53:31.916013",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A grouped_df: 24 × 4</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>month</th><th scope=col>casual_or_member</th><th scope=col>count</th><th scope=col>average_ride_length</th></tr>\n",
       "\t<tr><th scope=col>&lt;dttm&gt;</th><th scope=col>&lt;fct&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>2021-06-01</td><td>casual</td><td>305291</td><td>17.32524</td></tr>\n",
       "\t<tr><td>2021-06-01</td><td>member</td><td>342197</td><td>13.22403</td></tr>\n",
       "\t<tr><td>2021-07-01</td><td>casual</td><td>371109</td><td>17.02258</td></tr>\n",
       "\t<tr><td>2021-07-01</td><td>member</td><td>362854</td><td>12.99189</td></tr>\n",
       "\t<tr><td>2021-08-01</td><td>casual</td><td>351624</td><td>16.69737</td></tr>\n",
       "\t<tr><td>2021-08-01</td><td>member</td><td>373872</td><td>12.79857</td></tr>\n",
       "\t<tr><td>2021-09-01</td><td>casual</td><td>313148</td><td>16.26535</td></tr>\n",
       "\t<tr><td>2021-09-01</td><td>member</td><td>375061</td><td>12.46958</td></tr>\n",
       "\t<tr><td>2021-10-01</td><td>casual</td><td>226703</td><td>15.24888</td></tr>\n",
       "\t<tr><td>2021-10-01</td><td>member</td><td>357505</td><td>11.37615</td></tr>\n",
       "\t<tr><td>2021-11-01</td><td>casual</td><td> 97635</td><td>13.51174</td></tr>\n",
       "\t<tr><td>2021-11-01</td><td>member</td><td>242362</td><td>10.34312</td></tr>\n",
       "\t<tr><td>2021-12-01</td><td>casual</td><td> 64087</td><td>13.33295</td></tr>\n",
       "\t<tr><td>2021-12-01</td><td>member</td><td>170411</td><td>10.23759</td></tr>\n",
       "\t<tr><td>2022-01-01</td><td>casual</td><td> 17049</td><td>12.43141</td></tr>\n",
       "\t<tr><td>2022-01-01</td><td>member</td><td> 81606</td><td>10.02812</td></tr>\n",
       "\t<tr><td>2022-02-01</td><td>casual</td><td> 19285</td><td>13.17046</td></tr>\n",
       "\t<tr><td>2022-02-01</td><td>member</td><td> 89725</td><td>10.19494</td></tr>\n",
       "\t<tr><td>2022-03-01</td><td>casual</td><td> 77268</td><td>15.56127</td></tr>\n",
       "\t<tr><td>2022-03-01</td><td>member</td><td>185217</td><td>10.83356</td></tr>\n",
       "\t<tr><td>2022-04-01</td><td>casual</td><td>109440</td><td>15.33841</td></tr>\n",
       "\t<tr><td>2022-04-01</td><td>member</td><td>233034</td><td>10.70114</td></tr>\n",
       "\t<tr><td>2022-05-01</td><td>casual</td><td>236391</td><td>16.18205</td></tr>\n",
       "\t<tr><td>2022-05-01</td><td>member</td><td>336196</td><td>12.21220</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A grouped\\_df: 24 × 4\n",
       "\\begin{tabular}{llll}\n",
       " month & casual\\_or\\_member & count & average\\_ride\\_length\\\\\n",
       " <dttm> & <fct> & <int> & <dbl>\\\\\n",
       "\\hline\n",
       "\t 2021-06-01 & casual & 305291 & 17.32524\\\\\n",
       "\t 2021-06-01 & member & 342197 & 13.22403\\\\\n",
       "\t 2021-07-01 & casual & 371109 & 17.02258\\\\\n",
       "\t 2021-07-01 & member & 362854 & 12.99189\\\\\n",
       "\t 2021-08-01 & casual & 351624 & 16.69737\\\\\n",
       "\t 2021-08-01 & member & 373872 & 12.79857\\\\\n",
       "\t 2021-09-01 & casual & 313148 & 16.26535\\\\\n",
       "\t 2021-09-01 & member & 375061 & 12.46958\\\\\n",
       "\t 2021-10-01 & casual & 226703 & 15.24888\\\\\n",
       "\t 2021-10-01 & member & 357505 & 11.37615\\\\\n",
       "\t 2021-11-01 & casual &  97635 & 13.51174\\\\\n",
       "\t 2021-11-01 & member & 242362 & 10.34312\\\\\n",
       "\t 2021-12-01 & casual &  64087 & 13.33295\\\\\n",
       "\t 2021-12-01 & member & 170411 & 10.23759\\\\\n",
       "\t 2022-01-01 & casual &  17049 & 12.43141\\\\\n",
       "\t 2022-01-01 & member &  81606 & 10.02812\\\\\n",
       "\t 2022-02-01 & casual &  19285 & 13.17046\\\\\n",
       "\t 2022-02-01 & member &  89725 & 10.19494\\\\\n",
       "\t 2022-03-01 & casual &  77268 & 15.56127\\\\\n",
       "\t 2022-03-01 & member & 185217 & 10.83356\\\\\n",
       "\t 2022-04-01 & casual & 109440 & 15.33841\\\\\n",
       "\t 2022-04-01 & member & 233034 & 10.70114\\\\\n",
       "\t 2022-05-01 & casual & 236391 & 16.18205\\\\\n",
       "\t 2022-05-01 & member & 336196 & 12.21220\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A grouped_df: 24 × 4\n",
       "\n",
       "| month &lt;dttm&gt; | casual_or_member &lt;fct&gt; | count &lt;int&gt; | average_ride_length &lt;dbl&gt; |\n",
       "|---|---|---|---|\n",
       "| 2021-06-01 | casual | 305291 | 17.32524 |\n",
       "| 2021-06-01 | member | 342197 | 13.22403 |\n",
       "| 2021-07-01 | casual | 371109 | 17.02258 |\n",
       "| 2021-07-01 | member | 362854 | 12.99189 |\n",
       "| 2021-08-01 | casual | 351624 | 16.69737 |\n",
       "| 2021-08-01 | member | 373872 | 12.79857 |\n",
       "| 2021-09-01 | casual | 313148 | 16.26535 |\n",
       "| 2021-09-01 | member | 375061 | 12.46958 |\n",
       "| 2021-10-01 | casual | 226703 | 15.24888 |\n",
       "| 2021-10-01 | member | 357505 | 11.37615 |\n",
       "| 2021-11-01 | casual |  97635 | 13.51174 |\n",
       "| 2021-11-01 | member | 242362 | 10.34312 |\n",
       "| 2021-12-01 | casual |  64087 | 13.33295 |\n",
       "| 2021-12-01 | member | 170411 | 10.23759 |\n",
       "| 2022-01-01 | casual |  17049 | 12.43141 |\n",
       "| 2022-01-01 | member |  81606 | 10.02812 |\n",
       "| 2022-02-01 | casual |  19285 | 13.17046 |\n",
       "| 2022-02-01 | member |  89725 | 10.19494 |\n",
       "| 2022-03-01 | casual |  77268 | 15.56127 |\n",
       "| 2022-03-01 | member | 185217 | 10.83356 |\n",
       "| 2022-04-01 | casual | 109440 | 15.33841 |\n",
       "| 2022-04-01 | member | 233034 | 10.70114 |\n",
       "| 2022-05-01 | casual | 236391 | 16.18205 |\n",
       "| 2022-05-01 | member | 336196 | 12.21220 |\n",
       "\n"
      ],
      "text/plain": [
       "   month      casual_or_member count  average_ride_length\n",
       "1  2021-06-01 casual           305291 17.32524           \n",
       "2  2021-06-01 member           342197 13.22403           \n",
       "3  2021-07-01 casual           371109 17.02258           \n",
       "4  2021-07-01 member           362854 12.99189           \n",
       "5  2021-08-01 casual           351624 16.69737           \n",
       "6  2021-08-01 member           373872 12.79857           \n",
       "7  2021-09-01 casual           313148 16.26535           \n",
       "8  2021-09-01 member           375061 12.46958           \n",
       "9  2021-10-01 casual           226703 15.24888           \n",
       "10 2021-10-01 member           357505 11.37615           \n",
       "11 2021-11-01 casual            97635 13.51174           \n",
       "12 2021-11-01 member           242362 10.34312           \n",
       "13 2021-12-01 casual            64087 13.33295           \n",
       "14 2021-12-01 member           170411 10.23759           \n",
       "15 2022-01-01 casual            17049 12.43141           \n",
       "16 2022-01-01 member            81606 10.02812           \n",
       "17 2022-02-01 casual            19285 13.17046           \n",
       "18 2022-02-01 member            89725 10.19494           \n",
       "19 2022-03-01 casual            77268 15.56127           \n",
       "20 2022-03-01 member           185217 10.83356           \n",
       "21 2022-04-01 casual           109440 15.33841           \n",
       "22 2022-04-01 member           233034 10.70114           \n",
       "23 2022-05-01 casual           236391 16.18205           \n",
       "24 2022-05-01 member           336196 12.21220           "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Number of rides and average ride length in minutes by customer type per month.\n",
    "bike_trip_df_final %>%\n",
    "  group_by(month = lubridate::floor_date(started_at, 'month'), casual_or_member) %>% \n",
    "  summarize(count = n(),\n",
    "            average_ride_length = mean(ride_length_in_mins))"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 23,
   "id": "51562afc",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:32.926935Z",
     "iopub.status.busy": "2022-07-26T13:53:32.925311Z",
     "iopub.status.idle": "2022-07-26T13:53:33.262005Z",
     "shell.execute_reply": "2022-07-26T13:53:33.260255Z"
    },
    "papermill": {
     "duration": 0.353463,
     "end_time": "2022-07-26T13:53:33.264415",
     "exception": false,
     "start_time": "2022-07-26T13:53:32.910952",
     "status": "completed"
    },
    "scrolled": true,
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A grouped_df: 70 × 5</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>casual_or_member</th><th scope=col>day_of_week</th><th scope=col>time_of_day</th><th scope=col>number_of_rides</th><th scope=col>average_ride_length</th></tr>\n",
       "\t<tr><th scope=col>&lt;fct&gt;</th><th scope=col>&lt;ord&gt;</th><th scope=col>&lt;ord&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>casual</td><td>Monday   </td><td>Morning     </td><td> 48862</td><td>14.91957</td></tr>\n",
       "\t<tr><td>casual</td><td>Monday   </td><td>Afternoon   </td><td>114614</td><td>16.99062</td></tr>\n",
       "\t<tr><td>casual</td><td>Monday   </td><td>Evening     </td><td> 54993</td><td>15.81554</td></tr>\n",
       "\t<tr><td>casual</td><td>Monday   </td><td>Late_Evening</td><td> 24344</td><td>15.02706</td></tr>\n",
       "\t<tr><td>casual</td><td>Monday   </td><td>Night       </td><td> 13049</td><td>15.10274</td></tr>\n",
       "\t<tr><td>casual</td><td>Tuesday  </td><td>Morning     </td><td> 48715</td><td>13.71365</td></tr>\n",
       "\t<tr><td>casual</td><td>Tuesday  </td><td>Afternoon   </td><td>106722</td><td>15.85772</td></tr>\n",
       "\t<tr><td>casual</td><td>Tuesday  </td><td>Evening     </td><td> 60624</td><td>15.18945</td></tr>\n",
       "\t<tr><td>casual</td><td>Tuesday  </td><td>Late_Evening</td><td> 27566</td><td>14.28058</td></tr>\n",
       "\t<tr><td>casual</td><td>Tuesday  </td><td>Night       </td><td>  8492</td><td>13.93724</td></tr>\n",
       "\t<tr><td>casual</td><td>Wednesday</td><td>Morning     </td><td> 47684</td><td>13.60118</td></tr>\n",
       "\t<tr><td>casual</td><td>Wednesday</td><td>Afternoon   </td><td>103994</td><td>15.76926</td></tr>\n",
       "\t<tr><td>casual</td><td>Wednesday</td><td>Evening     </td><td> 61898</td><td>15.27095</td></tr>\n",
       "\t<tr><td>casual</td><td>Wednesday</td><td>Late_Evening</td><td> 30234</td><td>14.51392</td></tr>\n",
       "\t<tr><td>casual</td><td>Wednesday</td><td>Night       </td><td>  8639</td><td>14.34323</td></tr>\n",
       "\t<tr><td>casual</td><td>Thursday </td><td>Morning     </td><td> 49124</td><td>13.76908</td></tr>\n",
       "\t<tr><td>casual</td><td>Thursday </td><td>Afternoon   </td><td>108666</td><td>15.86603</td></tr>\n",
       "\t<tr><td>casual</td><td>Thursday </td><td>Evening     </td><td> 66882</td><td>15.31214</td></tr>\n",
       "\t<tr><td>casual</td><td>Thursday </td><td>Late_Evening</td><td> 37812</td><td>14.36372</td></tr>\n",
       "\t<tr><td>casual</td><td>Thursday </td><td>Night       </td><td>  9942</td><td>13.66186</td></tr>\n",
       "\t<tr><td>casual</td><td>Friday   </td><td>Morning     </td><td> 51826</td><td>14.64815</td></tr>\n",
       "\t<tr><td>casual</td><td>Friday   </td><td>Afternoon   </td><td>135719</td><td>16.52996</td></tr>\n",
       "\t<tr><td>casual</td><td>Friday   </td><td>Evening     </td><td> 68288</td><td>15.55834</td></tr>\n",
       "\t<tr><td>casual</td><td>Friday   </td><td>Late_Evening</td><td> 42438</td><td>15.29341</td></tr>\n",
       "\t<tr><td>casual</td><td>Friday   </td><td>Night       </td><td> 15591</td><td>14.07581</td></tr>\n",
       "\t<tr><td>casual</td><td>Saturday </td><td>Morning     </td><td> 82120</td><td>16.81210</td></tr>\n",
       "\t<tr><td>casual</td><td>Saturday </td><td>Afternoon   </td><td>207324</td><td>18.40535</td></tr>\n",
       "\t<tr><td>casual</td><td>Saturday </td><td>Evening     </td><td> 74795</td><td>16.88745</td></tr>\n",
       "\t<tr><td>casual</td><td>Saturday </td><td>Late_Evening</td><td> 54505</td><td>16.30990</td></tr>\n",
       "\t<tr><td>casual</td><td>Saturday </td><td>Night       </td><td> 37465</td><td>14.73304</td></tr>\n",
       "\t<tr><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td></tr>\n",
       "\t<tr><td>member</td><td>Tuesday  </td><td>Morning     </td><td>146455</td><td>10.90167</td></tr>\n",
       "\t<tr><td>member</td><td>Tuesday  </td><td>Afternoon   </td><td>206587</td><td>11.49013</td></tr>\n",
       "\t<tr><td>member</td><td>Tuesday  </td><td>Evening     </td><td>104937</td><td>11.83024</td></tr>\n",
       "\t<tr><td>member</td><td>Tuesday  </td><td>Late_Evening</td><td> 33523</td><td>11.11396</td></tr>\n",
       "\t<tr><td>member</td><td>Tuesday  </td><td>Night       </td><td> 12286</td><td>10.42465</td></tr>\n",
       "\t<tr><td>member</td><td>Wednesday</td><td>Morning     </td><td>143366</td><td>10.88422</td></tr>\n",
       "\t<tr><td>member</td><td>Wednesday</td><td>Afternoon   </td><td>198220</td><td>11.61243</td></tr>\n",
       "\t<tr><td>member</td><td>Wednesday</td><td>Evening     </td><td>102313</td><td>11.99325</td></tr>\n",
       "\t<tr><td>member</td><td>Wednesday</td><td>Late_Evening</td><td> 35168</td><td>11.49270</td></tr>\n",
       "\t<tr><td>member</td><td>Wednesday</td><td>Night       </td><td> 12369</td><td>10.71935</td></tr>\n",
       "\t<tr><td>member</td><td>Thursday </td><td>Morning     </td><td>137547</td><td>10.85412</td></tr>\n",
       "\t<tr><td>member</td><td>Thursday </td><td>Afternoon   </td><td>192165</td><td>11.58242</td></tr>\n",
       "\t<tr><td>member</td><td>Thursday </td><td>Evening     </td><td> 99026</td><td>12.17198</td></tr>\n",
       "\t<tr><td>member</td><td>Thursday </td><td>Late_Evening</td><td> 39609</td><td>11.55732</td></tr>\n",
       "\t<tr><td>member</td><td>Thursday </td><td>Night       </td><td> 12579</td><td>10.41841</td></tr>\n",
       "\t<tr><td>member</td><td>Friday   </td><td>Morning     </td><td>117911</td><td>10.97268</td></tr>\n",
       "\t<tr><td>member</td><td>Friday   </td><td>Afternoon   </td><td>186730</td><td>11.78898</td></tr>\n",
       "\t<tr><td>member</td><td>Friday   </td><td>Evening     </td><td> 82468</td><td>12.33947</td></tr>\n",
       "\t<tr><td>member</td><td>Friday   </td><td>Late_Evening</td><td> 37050</td><td>12.02247</td></tr>\n",
       "\t<tr><td>member</td><td>Friday   </td><td>Night       </td><td> 15136</td><td>10.75443</td></tr>\n",
       "\t<tr><td>member</td><td>Saturday </td><td>Morning     </td><td>105780</td><td>12.47958</td></tr>\n",
       "\t<tr><td>member</td><td>Saturday </td><td>Afternoon   </td><td>181854</td><td>13.51424</td></tr>\n",
       "\t<tr><td>member</td><td>Saturday </td><td>Evening     </td><td> 65454</td><td>12.94515</td></tr>\n",
       "\t<tr><td>member</td><td>Saturday </td><td>Late_Evening</td><td> 38863</td><td>12.64750</td></tr>\n",
       "\t<tr><td>member</td><td>Saturday </td><td>Night       </td><td> 24996</td><td>11.79738</td></tr>\n",
       "\t<tr><td>member</td><td>Sunday   </td><td>Morning     </td><td> 87604</td><td>12.67486</td></tr>\n",
       "\t<tr><td>member</td><td>Sunday   </td><td>Afternoon   </td><td>175164</td><td>13.52339</td></tr>\n",
       "\t<tr><td>member</td><td>Sunday   </td><td>Evening     </td><td> 58935</td><td>12.66489</td></tr>\n",
       "\t<tr><td>member</td><td>Sunday   </td><td>Late_Evening</td><td> 23788</td><td>11.96188</td></tr>\n",
       "\t<tr><td>member</td><td>Sunday   </td><td>Night       </td><td> 26780</td><td>12.10511</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A grouped\\_df: 70 × 5\n",
       "\\begin{tabular}{lllll}\n",
       " casual\\_or\\_member & day\\_of\\_week & time\\_of\\_day & number\\_of\\_rides & average\\_ride\\_length\\\\\n",
       " <fct> & <ord> & <ord> & <int> & <dbl>\\\\\n",
       "\\hline\n",
       "\t casual & Monday    & Morning      &  48862 & 14.91957\\\\\n",
       "\t casual & Monday    & Afternoon    & 114614 & 16.99062\\\\\n",
       "\t casual & Monday    & Evening      &  54993 & 15.81554\\\\\n",
       "\t casual & Monday    & Late\\_Evening &  24344 & 15.02706\\\\\n",
       "\t casual & Monday    & Night        &  13049 & 15.10274\\\\\n",
       "\t casual & Tuesday   & Morning      &  48715 & 13.71365\\\\\n",
       "\t casual & Tuesday   & Afternoon    & 106722 & 15.85772\\\\\n",
       "\t casual & Tuesday   & Evening      &  60624 & 15.18945\\\\\n",
       "\t casual & Tuesday   & Late\\_Evening &  27566 & 14.28058\\\\\n",
       "\t casual & Tuesday   & Night        &   8492 & 13.93724\\\\\n",
       "\t casual & Wednesday & Morning      &  47684 & 13.60118\\\\\n",
       "\t casual & Wednesday & Afternoon    & 103994 & 15.76926\\\\\n",
       "\t casual & Wednesday & Evening      &  61898 & 15.27095\\\\\n",
       "\t casual & Wednesday & Late\\_Evening &  30234 & 14.51392\\\\\n",
       "\t casual & Wednesday & Night        &   8639 & 14.34323\\\\\n",
       "\t casual & Thursday  & Morning      &  49124 & 13.76908\\\\\n",
       "\t casual & Thursday  & Afternoon    & 108666 & 15.86603\\\\\n",
       "\t casual & Thursday  & Evening      &  66882 & 15.31214\\\\\n",
       "\t casual & Thursday  & Late\\_Evening &  37812 & 14.36372\\\\\n",
       "\t casual & Thursday  & Night        &   9942 & 13.66186\\\\\n",
       "\t casual & Friday    & Morning      &  51826 & 14.64815\\\\\n",
       "\t casual & Friday    & Afternoon    & 135719 & 16.52996\\\\\n",
       "\t casual & Friday    & Evening      &  68288 & 15.55834\\\\\n",
       "\t casual & Friday    & Late\\_Evening &  42438 & 15.29341\\\\\n",
       "\t casual & Friday    & Night        &  15591 & 14.07581\\\\\n",
       "\t casual & Saturday  & Morning      &  82120 & 16.81210\\\\\n",
       "\t casual & Saturday  & Afternoon    & 207324 & 18.40535\\\\\n",
       "\t casual & Saturday  & Evening      &  74795 & 16.88745\\\\\n",
       "\t casual & Saturday  & Late\\_Evening &  54505 & 16.30990\\\\\n",
       "\t casual & Saturday  & Night        &  37465 & 14.73304\\\\\n",
       "\t ⋮ & ⋮ & ⋮ & ⋮ & ⋮\\\\\n",
       "\t member & Tuesday   & Morning      & 146455 & 10.90167\\\\\n",
       "\t member & Tuesday   & Afternoon    & 206587 & 11.49013\\\\\n",
       "\t member & Tuesday   & Evening      & 104937 & 11.83024\\\\\n",
       "\t member & Tuesday   & Late\\_Evening &  33523 & 11.11396\\\\\n",
       "\t member & Tuesday   & Night        &  12286 & 10.42465\\\\\n",
       "\t member & Wednesday & Morning      & 143366 & 10.88422\\\\\n",
       "\t member & Wednesday & Afternoon    & 198220 & 11.61243\\\\\n",
       "\t member & Wednesday & Evening      & 102313 & 11.99325\\\\\n",
       "\t member & Wednesday & Late\\_Evening &  35168 & 11.49270\\\\\n",
       "\t member & Wednesday & Night        &  12369 & 10.71935\\\\\n",
       "\t member & Thursday  & Morning      & 137547 & 10.85412\\\\\n",
       "\t member & Thursday  & Afternoon    & 192165 & 11.58242\\\\\n",
       "\t member & Thursday  & Evening      &  99026 & 12.17198\\\\\n",
       "\t member & Thursday  & Late\\_Evening &  39609 & 11.55732\\\\\n",
       "\t member & Thursday  & Night        &  12579 & 10.41841\\\\\n",
       "\t member & Friday    & Morning      & 117911 & 10.97268\\\\\n",
       "\t member & Friday    & Afternoon    & 186730 & 11.78898\\\\\n",
       "\t member & Friday    & Evening      &  82468 & 12.33947\\\\\n",
       "\t member & Friday    & Late\\_Evening &  37050 & 12.02247\\\\\n",
       "\t member & Friday    & Night        &  15136 & 10.75443\\\\\n",
       "\t member & Saturday  & Morning      & 105780 & 12.47958\\\\\n",
       "\t member & Saturday  & Afternoon    & 181854 & 13.51424\\\\\n",
       "\t member & Saturday  & Evening      &  65454 & 12.94515\\\\\n",
       "\t member & Saturday  & Late\\_Evening &  38863 & 12.64750\\\\\n",
       "\t member & Saturday  & Night        &  24996 & 11.79738\\\\\n",
       "\t member & Sunday    & Morning      &  87604 & 12.67486\\\\\n",
       "\t member & Sunday    & Afternoon    & 175164 & 13.52339\\\\\n",
       "\t member & Sunday    & Evening      &  58935 & 12.66489\\\\\n",
       "\t member & Sunday    & Late\\_Evening &  23788 & 11.96188\\\\\n",
       "\t member & Sunday    & Night        &  26780 & 12.10511\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A grouped_df: 70 × 5\n",
       "\n",
       "| casual_or_member &lt;fct&gt; | day_of_week &lt;ord&gt; | time_of_day &lt;ord&gt; | number_of_rides &lt;int&gt; | average_ride_length &lt;dbl&gt; |\n",
       "|---|---|---|---|---|\n",
       "| casual | Monday    | Morning      |  48862 | 14.91957 |\n",
       "| casual | Monday    | Afternoon    | 114614 | 16.99062 |\n",
       "| casual | Monday    | Evening      |  54993 | 15.81554 |\n",
       "| casual | Monday    | Late_Evening |  24344 | 15.02706 |\n",
       "| casual | Monday    | Night        |  13049 | 15.10274 |\n",
       "| casual | Tuesday   | Morning      |  48715 | 13.71365 |\n",
       "| casual | Tuesday   | Afternoon    | 106722 | 15.85772 |\n",
       "| casual | Tuesday   | Evening      |  60624 | 15.18945 |\n",
       "| casual | Tuesday   | Late_Evening |  27566 | 14.28058 |\n",
       "| casual | Tuesday   | Night        |   8492 | 13.93724 |\n",
       "| casual | Wednesday | Morning      |  47684 | 13.60118 |\n",
       "| casual | Wednesday | Afternoon    | 103994 | 15.76926 |\n",
       "| casual | Wednesday | Evening      |  61898 | 15.27095 |\n",
       "| casual | Wednesday | Late_Evening |  30234 | 14.51392 |\n",
       "| casual | Wednesday | Night        |   8639 | 14.34323 |\n",
       "| casual | Thursday  | Morning      |  49124 | 13.76908 |\n",
       "| casual | Thursday  | Afternoon    | 108666 | 15.86603 |\n",
       "| casual | Thursday  | Evening      |  66882 | 15.31214 |\n",
       "| casual | Thursday  | Late_Evening |  37812 | 14.36372 |\n",
       "| casual | Thursday  | Night        |   9942 | 13.66186 |\n",
       "| casual | Friday    | Morning      |  51826 | 14.64815 |\n",
       "| casual | Friday    | Afternoon    | 135719 | 16.52996 |\n",
       "| casual | Friday    | Evening      |  68288 | 15.55834 |\n",
       "| casual | Friday    | Late_Evening |  42438 | 15.29341 |\n",
       "| casual | Friday    | Night        |  15591 | 14.07581 |\n",
       "| casual | Saturday  | Morning      |  82120 | 16.81210 |\n",
       "| casual | Saturday  | Afternoon    | 207324 | 18.40535 |\n",
       "| casual | Saturday  | Evening      |  74795 | 16.88745 |\n",
       "| casual | Saturday  | Late_Evening |  54505 | 16.30990 |\n",
       "| casual | Saturday  | Night        |  37465 | 14.73304 |\n",
       "| ⋮ | ⋮ | ⋮ | ⋮ | ⋮ |\n",
       "| member | Tuesday   | Morning      | 146455 | 10.90167 |\n",
       "| member | Tuesday   | Afternoon    | 206587 | 11.49013 |\n",
       "| member | Tuesday   | Evening      | 104937 | 11.83024 |\n",
       "| member | Tuesday   | Late_Evening |  33523 | 11.11396 |\n",
       "| member | Tuesday   | Night        |  12286 | 10.42465 |\n",
       "| member | Wednesday | Morning      | 143366 | 10.88422 |\n",
       "| member | Wednesday | Afternoon    | 198220 | 11.61243 |\n",
       "| member | Wednesday | Evening      | 102313 | 11.99325 |\n",
       "| member | Wednesday | Late_Evening |  35168 | 11.49270 |\n",
       "| member | Wednesday | Night        |  12369 | 10.71935 |\n",
       "| member | Thursday  | Morning      | 137547 | 10.85412 |\n",
       "| member | Thursday  | Afternoon    | 192165 | 11.58242 |\n",
       "| member | Thursday  | Evening      |  99026 | 12.17198 |\n",
       "| member | Thursday  | Late_Evening |  39609 | 11.55732 |\n",
       "| member | Thursday  | Night        |  12579 | 10.41841 |\n",
       "| member | Friday    | Morning      | 117911 | 10.97268 |\n",
       "| member | Friday    | Afternoon    | 186730 | 11.78898 |\n",
       "| member | Friday    | Evening      |  82468 | 12.33947 |\n",
       "| member | Friday    | Late_Evening |  37050 | 12.02247 |\n",
       "| member | Friday    | Night        |  15136 | 10.75443 |\n",
       "| member | Saturday  | Morning      | 105780 | 12.47958 |\n",
       "| member | Saturday  | Afternoon    | 181854 | 13.51424 |\n",
       "| member | Saturday  | Evening      |  65454 | 12.94515 |\n",
       "| member | Saturday  | Late_Evening |  38863 | 12.64750 |\n",
       "| member | Saturday  | Night        |  24996 | 11.79738 |\n",
       "| member | Sunday    | Morning      |  87604 | 12.67486 |\n",
       "| member | Sunday    | Afternoon    | 175164 | 13.52339 |\n",
       "| member | Sunday    | Evening      |  58935 | 12.66489 |\n",
       "| member | Sunday    | Late_Evening |  23788 | 11.96188 |\n",
       "| member | Sunday    | Night        |  26780 | 12.10511 |\n",
       "\n"
      ],
      "text/plain": [
       "   casual_or_member day_of_week time_of_day  number_of_rides\n",
       "1  casual           Monday      Morning       48862         \n",
       "2  casual           Monday      Afternoon    114614         \n",
       "3  casual           Monday      Evening       54993         \n",
       "4  casual           Monday      Late_Evening  24344         \n",
       "5  casual           Monday      Night         13049         \n",
       "6  casual           Tuesday     Morning       48715         \n",
       "7  casual           Tuesday     Afternoon    106722         \n",
       "8  casual           Tuesday     Evening       60624         \n",
       "9  casual           Tuesday     Late_Evening  27566         \n",
       "10 casual           Tuesday     Night          8492         \n",
       "11 casual           Wednesday   Morning       47684         \n",
       "12 casual           Wednesday   Afternoon    103994         \n",
       "13 casual           Wednesday   Evening       61898         \n",
       "14 casual           Wednesday   Late_Evening  30234         \n",
       "15 casual           Wednesday   Night          8639         \n",
       "16 casual           Thursday    Morning       49124         \n",
       "17 casual           Thursday    Afternoon    108666         \n",
       "18 casual           Thursday    Evening       66882         \n",
       "19 casual           Thursday    Late_Evening  37812         \n",
       "20 casual           Thursday    Night          9942         \n",
       "21 casual           Friday      Morning       51826         \n",
       "22 casual           Friday      Afternoon    135719         \n",
       "23 casual           Friday      Evening       68288         \n",
       "24 casual           Friday      Late_Evening  42438         \n",
       "25 casual           Friday      Night         15591         \n",
       "26 casual           Saturday    Morning       82120         \n",
       "27 casual           Saturday    Afternoon    207324         \n",
       "28 casual           Saturday    Evening       74795         \n",
       "29 casual           Saturday    Late_Evening  54505         \n",
       "30 casual           Saturday    Night         37465         \n",
       "⋮  ⋮                ⋮           ⋮            ⋮              \n",
       "41 member           Tuesday     Morning      146455         \n",
       "42 member           Tuesday     Afternoon    206587         \n",
       "43 member           Tuesday     Evening      104937         \n",
       "44 member           Tuesday     Late_Evening  33523         \n",
       "45 member           Tuesday     Night         12286         \n",
       "46 member           Wednesday   Morning      143366         \n",
       "47 member           Wednesday   Afternoon    198220         \n",
       "48 member           Wednesday   Evening      102313         \n",
       "49 member           Wednesday   Late_Evening  35168         \n",
       "50 member           Wednesday   Night         12369         \n",
       "51 member           Thursday    Morning      137547         \n",
       "52 member           Thursday    Afternoon    192165         \n",
       "53 member           Thursday    Evening       99026         \n",
       "54 member           Thursday    Late_Evening  39609         \n",
       "55 member           Thursday    Night         12579         \n",
       "56 member           Friday      Morning      117911         \n",
       "57 member           Friday      Afternoon    186730         \n",
       "58 member           Friday      Evening       82468         \n",
       "59 member           Friday      Late_Evening  37050         \n",
       "60 member           Friday      Night         15136         \n",
       "61 member           Saturday    Morning      105780         \n",
       "62 member           Saturday    Afternoon    181854         \n",
       "63 member           Saturday    Evening       65454         \n",
       "64 member           Saturday    Late_Evening  38863         \n",
       "65 member           Saturday    Night         24996         \n",
       "66 member           Sunday      Morning       87604         \n",
       "67 member           Sunday      Afternoon    175164         \n",
       "68 member           Sunday      Evening       58935         \n",
       "69 member           Sunday      Late_Evening  23788         \n",
       "70 member           Sunday      Night         26780         \n",
       "   average_ride_length\n",
       "1  14.91957           \n",
       "2  16.99062           \n",
       "3  15.81554           \n",
       "4  15.02706           \n",
       "5  15.10274           \n",
       "6  13.71365           \n",
       "7  15.85772           \n",
       "8  15.18945           \n",
       "9  14.28058           \n",
       "10 13.93724           \n",
       "11 13.60118           \n",
       "12 15.76926           \n",
       "13 15.27095           \n",
       "14 14.51392           \n",
       "15 14.34323           \n",
       "16 13.76908           \n",
       "17 15.86603           \n",
       "18 15.31214           \n",
       "19 14.36372           \n",
       "20 13.66186           \n",
       "21 14.64815           \n",
       "22 16.52996           \n",
       "23 15.55834           \n",
       "24 15.29341           \n",
       "25 14.07581           \n",
       "26 16.81210           \n",
       "27 18.40535           \n",
       "28 16.88745           \n",
       "29 16.30990           \n",
       "30 14.73304           \n",
       "⋮  ⋮                  \n",
       "41 10.90167           \n",
       "42 11.49013           \n",
       "43 11.83024           \n",
       "44 11.11396           \n",
       "45 10.42465           \n",
       "46 10.88422           \n",
       "47 11.61243           \n",
       "48 11.99325           \n",
       "49 11.49270           \n",
       "50 10.71935           \n",
       "51 10.85412           \n",
       "52 11.58242           \n",
       "53 12.17198           \n",
       "54 11.55732           \n",
       "55 10.41841           \n",
       "56 10.97268           \n",
       "57 11.78898           \n",
       "58 12.33947           \n",
       "59 12.02247           \n",
       "60 10.75443           \n",
       "61 12.47958           \n",
       "62 13.51424           \n",
       "63 12.94515           \n",
       "64 12.64750           \n",
       "65 11.79738           \n",
       "66 12.67486           \n",
       "67 13.52339           \n",
       "68 12.66489           \n",
       "69 11.96188           \n",
       "70 12.10511           "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Number of rides and average ride length in minutes by customer type per day of week and time of day.\n",
    "bike_trip_df_final %>%\n",
    "  group_by(casual_or_member, day_of_week, time_of_day) %>%\n",
    "  summarize(number_of_rides = n(),\n",
    "            average_ride_length = mean(ride_length_in_mins))"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 24,
   "id": "2fc2ba38",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:33.294468Z",
     "iopub.status.busy": "2022-07-26T13:53:33.292825Z",
     "iopub.status.idle": "2022-07-26T13:53:33.536914Z",
     "shell.execute_reply": "2022-07-26T13:53:33.534684Z"
    },
    "papermill": {
     "duration": 0.262037,
     "end_time": "2022-07-26T13:53:33.539683",
     "exception": false,
     "start_time": "2022-07-26T13:53:33.277646",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A grouped_df: 10 × 4</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>time_of_day</th><th scope=col>casual_or_member</th><th scope=col>number_of_rides</th><th scope=col>average_ride_length</th></tr>\n",
       "\t<tr><th scope=col>&lt;ord&gt;</th><th scope=col>&lt;fct&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>Morning     </td><td>casual</td><td> 399372</td><td>15.20112</td></tr>\n",
       "\t<tr><td>Morning     </td><td>member</td><td> 862258</td><td>11.29610</td></tr>\n",
       "\t<tr><td>Afternoon   </td><td>casual</td><td> 960054</td><td>17.11201</td></tr>\n",
       "\t<tr><td>Afternoon   </td><td>member</td><td>1329751</td><td>12.15122</td></tr>\n",
       "\t<tr><td>Evening     </td><td>casual</td><td> 444598</td><td>15.90081</td></tr>\n",
       "\t<tr><td>Evening     </td><td>member</td><td> 605847</td><td>12.18137</td></tr>\n",
       "\t<tr><td>Late_Evening</td><td>casual</td><td> 246597</td><td>15.24903</td></tr>\n",
       "\t<tr><td>Late_Evening</td><td>member</td><td> 235750</td><td>11.75897</td></tr>\n",
       "\t<tr><td>Night       </td><td>casual</td><td> 138409</td><td>14.77391</td></tr>\n",
       "\t<tr><td>Night       </td><td>member</td><td> 116434</td><td>11.23619</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A grouped\\_df: 10 × 4\n",
       "\\begin{tabular}{llll}\n",
       " time\\_of\\_day & casual\\_or\\_member & number\\_of\\_rides & average\\_ride\\_length\\\\\n",
       " <ord> & <fct> & <int> & <dbl>\\\\\n",
       "\\hline\n",
       "\t Morning      & casual &  399372 & 15.20112\\\\\n",
       "\t Morning      & member &  862258 & 11.29610\\\\\n",
       "\t Afternoon    & casual &  960054 & 17.11201\\\\\n",
       "\t Afternoon    & member & 1329751 & 12.15122\\\\\n",
       "\t Evening      & casual &  444598 & 15.90081\\\\\n",
       "\t Evening      & member &  605847 & 12.18137\\\\\n",
       "\t Late\\_Evening & casual &  246597 & 15.24903\\\\\n",
       "\t Late\\_Evening & member &  235750 & 11.75897\\\\\n",
       "\t Night        & casual &  138409 & 14.77391\\\\\n",
       "\t Night        & member &  116434 & 11.23619\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A grouped_df: 10 × 4\n",
       "\n",
       "| time_of_day &lt;ord&gt; | casual_or_member &lt;fct&gt; | number_of_rides &lt;int&gt; | average_ride_length &lt;dbl&gt; |\n",
       "|---|---|---|---|\n",
       "| Morning      | casual |  399372 | 15.20112 |\n",
       "| Morning      | member |  862258 | 11.29610 |\n",
       "| Afternoon    | casual |  960054 | 17.11201 |\n",
       "| Afternoon    | member | 1329751 | 12.15122 |\n",
       "| Evening      | casual |  444598 | 15.90081 |\n",
       "| Evening      | member |  605847 | 12.18137 |\n",
       "| Late_Evening | casual |  246597 | 15.24903 |\n",
       "| Late_Evening | member |  235750 | 11.75897 |\n",
       "| Night        | casual |  138409 | 14.77391 |\n",
       "| Night        | member |  116434 | 11.23619 |\n",
       "\n"
      ],
      "text/plain": [
       "   time_of_day  casual_or_member number_of_rides average_ride_length\n",
       "1  Morning      casual            399372         15.20112           \n",
       "2  Morning      member            862258         11.29610           \n",
       "3  Afternoon    casual            960054         17.11201           \n",
       "4  Afternoon    member           1329751         12.15122           \n",
       "5  Evening      casual            444598         15.90081           \n",
       "6  Evening      member            605847         12.18137           \n",
       "7  Late_Evening casual            246597         15.24903           \n",
       "8  Late_Evening member            235750         11.75897           \n",
       "9  Night        casual            138409         14.77391           \n",
       "10 Night        member            116434         11.23619           "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Number of rides and average ride length in minutes by customer type per time of day.\n",
    "bike_trip_df_final %>%\n",
    "  group_by(time_of_day, casual_or_member) %>%\n",
    "  summarize(number_of_rides = n(),\n",
    "            average_ride_length = mean(ride_length_in_mins))"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 25,
   "id": "53b4095c",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:33.570052Z",
     "iopub.status.busy": "2022-07-26T13:53:33.568471Z",
     "iopub.status.idle": "2022-07-26T13:53:33.821128Z",
     "shell.execute_reply": "2022-07-26T13:53:33.818886Z"
    },
    "papermill": {
     "duration": 0.271054,
     "end_time": "2022-07-26T13:53:33.823989",
     "exception": false,
     "start_time": "2022-07-26T13:53:33.552935",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A grouped_df: 5 × 4</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>casual_or_member</th><th scope=col>rideable_type</th><th scope=col>count</th><th scope=col>average_ride_length</th></tr>\n",
       "\t<tr><th scope=col>&lt;fct&gt;</th><th scope=col>&lt;fct&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>casual</td><td>classic_bike </td><td>1061186</td><td>16.47923</td></tr>\n",
       "\t<tr><td>casual</td><td>docked_bike  </td><td> 188242</td><td>21.75467</td></tr>\n",
       "\t<tr><td>casual</td><td>electric_bike</td><td> 939602</td><td>14.67788</td></tr>\n",
       "\t<tr><td>member</td><td>classic_bike </td><td>1901290</td><td>12.29726</td></tr>\n",
       "\t<tr><td>member</td><td>electric_bike</td><td>1248750</td><td>11.19366</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A grouped\\_df: 5 × 4\n",
       "\\begin{tabular}{llll}\n",
       " casual\\_or\\_member & rideable\\_type & count & average\\_ride\\_length\\\\\n",
       " <fct> & <fct> & <int> & <dbl>\\\\\n",
       "\\hline\n",
       "\t casual & classic\\_bike  & 1061186 & 16.47923\\\\\n",
       "\t casual & docked\\_bike   &  188242 & 21.75467\\\\\n",
       "\t casual & electric\\_bike &  939602 & 14.67788\\\\\n",
       "\t member & classic\\_bike  & 1901290 & 12.29726\\\\\n",
       "\t member & electric\\_bike & 1248750 & 11.19366\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A grouped_df: 5 × 4\n",
       "\n",
       "| casual_or_member &lt;fct&gt; | rideable_type &lt;fct&gt; | count &lt;int&gt; | average_ride_length &lt;dbl&gt; |\n",
       "|---|---|---|---|\n",
       "| casual | classic_bike  | 1061186 | 16.47923 |\n",
       "| casual | docked_bike   |  188242 | 21.75467 |\n",
       "| casual | electric_bike |  939602 | 14.67788 |\n",
       "| member | classic_bike  | 1901290 | 12.29726 |\n",
       "| member | electric_bike | 1248750 | 11.19366 |\n",
       "\n"
      ],
      "text/plain": [
       "  casual_or_member rideable_type count   average_ride_length\n",
       "1 casual           classic_bike  1061186 16.47923           \n",
       "2 casual           docked_bike    188242 21.75467           \n",
       "3 casual           electric_bike  939602 14.67788           \n",
       "4 member           classic_bike  1901290 12.29726           \n",
       "5 member           electric_bike 1248750 11.19366           "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Rideable type frequency and its average ride length in minutes by customer type.\n",
    "bike_trip_df_final %>%\n",
    "  group_by(casual_or_member, rideable_type) %>%\n",
    "  summarize(count = n(),\n",
    "            average_ride_length = mean(ride_length_in_mins))"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 26,
   "id": "7249207a",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:33.855237Z",
     "iopub.status.busy": "2022-07-26T13:53:33.853643Z",
     "iopub.status.idle": "2022-07-26T13:53:34.156781Z",
     "shell.execute_reply": "2022-07-26T13:53:34.155044Z"
    },
    "papermill": {
     "duration": 0.321559,
     "end_time": "2022-07-26T13:53:34.159464",
     "exception": false,
     "start_time": "2022-07-26T13:53:33.837905",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "image/png": "iVBORw0KGgoAAAANSUhEUgAAA0gAAANICAIAAAByhViMAAAABmJLR0QA/wD/AP+gvaeTAAAg\nAElEQVR4nOzdeWAMd/8H8M/svclu7gghElRIROKuos666+xD6z6q+lBVipZeinqatqIeRetH\nUaHaB1VUSFC0blGiRRxBghBxJLubzWZ2d+b3R2gjJrI5ZMbk/forO/nON+/11OOd7858h+F5\nngAAAADg6acQOwAAAAAAlA8UOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZ\nQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkU\nOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLED\nAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAA\nAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAA\nkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZ\nQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkU\nOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLED\nAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAA\nAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAA\nkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZ\nQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkU\nOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLED\nAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAAAACZQLEDAAAAkAkUOwAA\n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\n3RaLRVH0uF4L8SpI5wmJV0E6T0i8CtJ/QpPJZLfbdRuviqDYAQAAGIRh59jpE1fsKoh4FaTz\nhMSrIJ0nJF4F6T8hV+z0gGJXqRwOB3PsAABGxRw7zf3ui53rXIotqleJjYG2sDoNmvUZ/JdX\nn3k45OK9vdx5m4LC7iwxUlEUW2hkvaQ2A0c+O+nRzqX/ysjes27GW7OXr9uw/8gpp9ccU/OW\ntu27Dn18fL92ta4jbdG1urXzNhxK02m9a9undbOOjXcvP5C174zWWfyo2zG+dqsamb+czTtV\n+l3L2outHx4Vby84rRae1+lF2aBIU2CYYlOCzaoef/cLxOUWd0REhNVqvfroSpebm+t0OgNC\nRbFoHaUMvvPic8lp8ymn4tA6ix8R3ugwX/jW7B+O55d5h0YNNQ9Lqh9S94s9X+/OOqB1Fv+6\n1r3z9lot5q37Iu3wbq2z+JGc2OSRTv31/JJUFaHHJ/frEBjcqFf3JhcfeU8dObBt+6YZE79f\n9HV6xuqXit9ew2yte989xdby8HnOZu7fuGXVC5tXpuxe+f3U7sUPu376o/c9O9fh9dli67e5\nvaPNl3fwwM4l899c+vFbPZ6es3zqkOu7ccehtIyfVv18XbvedInJ8SKNs/adydicefXRlS6m\nQZS0krxT+WcO5WmdxY/QajYRKTzvK8zR6dRVc7AaKIpZNQcpQVpn8aNQLRQRq9Vqt+vxPi4u\nl8vpdCoWMQVrHaUMvgIREafiyAk4p3UWP4J9ISLhx/NP7HHsu/roSlfLGichsjvrwHdHUrXO\n4l+TmLpSq0Xa4d2r0r7TOgv0yyDFzhYzcPHil4tvOZ22pFP7ATvXvDxhx9jpLX5bQNga1XPx\n4rdL7H5kzZS63Z7fPKPvzy/nNg++8D3ZMfPhTuMXWMJazJjz/hP92pgvXM3z/Zgyd+zwMV9N\ne+T++JbLxja7macFAABwDQx7r9iY5PsXTGwhIitm7b3q4PguEyfWCVW9+e+duPD6hTt3Q9en\n/2u2JizbvenJ/pdanYiYWvUcsSrtszCzaeXE/mc9fq45+wrcXIkGAACVz7DFTkSi74gWEUd6\nueaatLRfNmtm45OPZhV6209b0b2mnxddgmv0WjR+9EMPtt+c6y7a8u2gBoqiePL3PdW7bXCw\n1RxgrdOg+ZBn/53r1elLcgAAwHgM8lKsXz/NPiAiUa2jyjFW/eSUUzEFPVztQo2bsuSIogS8\n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\nOQ4r3gAAAABJRU5ErkJggg=="
     },
     "metadata": {
      "image/png": {
       "height": 420,
       "width": 420
      }
     },
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Display color palettes that are color blind friendly.\n",
    "display.brewer.all(colorblindFriendly = TRUE)\n",
    "\n",
    "# Adjust plot size\n",
    "options(repr.plot.width=10, repr.plot.height = 7)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 27,
   "id": "02af577b",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:34.192806Z",
     "iopub.status.busy": "2022-07-26T13:53:34.191085Z",
     "iopub.status.idle": "2022-07-26T13:53:46.237750Z",
     "shell.execute_reply": "2022-07-26T13:53:46.235890Z"
    },
    "papermill": {
     "duration": 12.066237,
     "end_time": "2022-07-26T13:53:46.240627",
     "exception": false,
     "start_time": "2022-07-26T13:53:34.174390",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "image/png": "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\nRREIAQAAAEBRBEIAAAAAUBSBEAAAAAAURSAEAAAAAEURCAEAAABAUQRCAAAAAFAUgRAAAAAA\nFEUgBAAAAABFEQgBAAAAQFEEQgAAAABQFIEQAAAAABRFIAQAAAAARREIAQAAAEBRBEIAAAAA\nUBSBEAAAAAAURSAEAAAAAEURCAEAAABAUQRCAAAAAFAUgRAAAAAAFEUgBAAAAABFEQgBAAAA\nQFEEQgAAAABQFIEQAAAAABRFIAQAAAAARREIAQAAAEBRBEIAAAAAUBSBEAAAAAAURSAEAAAA\nAEURCAEAAABAUQRCAAAAAFAUgRAAAAAAFEUgBAAAAABFEQgBAAAAQFEEQgAAAABQFIEQAAAA\nABRFIAQAAAAARREIAQAAAEBRBEIAAAAAUBSBEAAAAAAURSAEAAAAAEURCAEAAABAUQRCAAAA\nAFAUgRAAAAAAFEUgBAAAAABFEQgBAAAAQFEEQgAAAABQFIEQAAAAABRFIAQAAAAARREIAQAA\nAEBRBEIAAAAAUBSBEAAAAAAURSAEAAAAAEURCAEAAABAUQRCAAAAAFAUgRAAAAAAFEUgBAAA\nAABFEQgBAAAAQFEEQgAAAABQFIEQAAAAABRFIAQAAAAARREIAQAAAEBRBEIAAAAAUBSBEAAA\nAAAURSAEAAAAAEURCAEAAABAUQRCAAAAAFAUgRAAAAAAFEUgBAAAAABFEQgBAAAAQFEEQgAA\nAABQFIEQAAAAABRFIAQAAAAARREIAQAAAEBRBEIAAAAAUBSBEAAAAAAURSAEAAAAAEURCAEA\nAABAUQRCAAAAAFAUgRAAAAAAFEUgBAAAAABFEQgBAAAAQFEEQgAAAABQFIEQAAAAABRFIAQA\nAAAARREIAQAAAEBRBEIAAAAAUBSBEAAAAAAURSAEAAAAAEURCAEAAABAUQRCAAAAAFAUgRAA\nAAAAFEUgBAAAAABFEQgBAAAAQFEEQgAAAABQFIEQAAAAABRFIAQAAAAARREIAQAAAEBRBEIA\nAAAAUBSBEAAAAAAURSAEAAAAAEURCAEAAABAUQRCAAAAAFAUgRAAAAAAFEUgBAAAAABFEQgB\nAAAAQFEEQgAAAABQFIEQAAAAABRFIAQAAAAARREIAQAAAEBRBEIAAAAAUBSBEAAAAAAURSAE\nAAAAAEURCAEAAABAUQRCAAAAAFAUgRAAAAAAFEUgBAAAAABFEQgBAAAAQHoSI6cAACAASURB\nVFEEQgAAAABQFIEQAAAAABRFIAQAAAAARREIAQAAAEBRBEIAAAAAUBSBEAAAAAAURSAEAAAA\nAEURCAEAAABAUQRCAAAAAFAUgRAAAAAAFEUgBAAAAABFEQgBAAAAQFEEQgAAAABQFIEQAAAA\nABRFIAQAAAAARREIAQAAAEBRBEIAAAAAUBSBEAAAAAAURSAEAAAAAEURCAEAAABAUQRCAAAA\nAFAUgRAAAAAAFEUgBAAAAABFmQq7AGRhnTKksEsAgDtlfGFWYZcAAAAcwhVCAAAAAFAUgRAA\nAAAAFEUgBAAAAABFEQgBAAAAQFEEQgAAAABQFIEQAAAAABRFIAQAAAAARREIAQAAAEBRBEIA\nAAAAUBSBEAAAAAAURSAEAAAAAEURCAEAAABAUQRCAAAAAFAUgRAAAAAAFGUq7AIAiHiHGpp3\n1sqWF1cXiT+n715m27pFdD17R61Zf+3SCtueczd+4Ffb0Ly9FlhW3FwkNkL/d6lt9/4sHfzr\nGJp30koHi8Gqnzuob1qon4zJ0sFUQmvRXStbVfNy1c8d0Nd/r0fGZelQobWhUUutREnRbBIb\nYdu1RN9zMG8jAAAA4C7DFUKgsLnXNj7xghZSUT+20bZ1tZ7oqTV/yti3bw49jb6G+8K0kp43\ntns2MPYfqVUI0o9v0neu042ltfZjDM2qXu8Q0Nr4+AitnL9+cI2+e5sUr2l4aJKhnM/1Dpqr\nof/rhjoN5cwOfdcG8atpeHiSFuBxvUPZXsZe/TQ/Xf/3T33nOt0SbOjwkqFRcB5GAAAAwN2H\nQAgUMq37QDGJbdE424oF+vpFtgUv2g6dl1LtDKW9r3cyummlahl6vSYmYw4jdO4rRs029zVb\n+ELbugW2b1/U45O0Rs+K8eo/cMODfUSPt815zRa+yLbmG9vXE/Ukq9Zt8PUhajyj+brpK96w\nrVhgW7fANud9sZoNPXtnfG7o3E7SIq1fv237+xfbugW2Oa/oKWlak2dE0xwcAQAAAHchAiFQ\nyLQAT0lYo0ddutZg08Pni4jWIOhqgynQ+OynhkdHaZmv6WUewddd0k7ql5KuvtdT9SMXRXPV\nXM0iIm4NNA+L7J+px6dc7ZB21rbigLjW0Lzc7A2GphUlLcq2L+pqh5QI24FzUqyF5uYiImLw\n0jwtcnaxpFmv1XhZj7wkJn/NxejQCAAAALgrEQiBQqW5SHy0HrktS6MtXkTEfO2fp/WibfFk\n208f2f43P8cx9LgkMZfNFL00LdhHbEl6SpqIiCVERPSTF7Nsc/6QiGhlvURExKR5uMrl5ZLp\npkV9Z4SIaMXd7e9sy2fb1kdkGcHVLHq6nm5zbAQAAADcjXioDFCo9FTb3NdubKz6oIjo/57L\n6KOf3C8i4pKa8xi/ztAHPG8YNE7fsVFP1bSKYZqvSV85SexpLf28iEgpTzkQfX0bz7IiogUV\nk73nxKWCGDQ5dz7LoImHRJpKWS85HSe2eH3fhqvtFg9x89YqhBlKecmBr8RqE5FbjwAAAIC7\nEoEQuLtoIV0MbUPlyn+2oxcc3Sb5iL5jt9aigXZ/n6u39J1fqx8+c/XTK3/raX20WkO0DRP0\nlHQREaOPoXMtERF3s4iI0VdE9ISULGNa40RE8zDfsCvDoA81d4uIyJnV1uVbrrbmZQQAAADc\nPQiEwF3Do4KhTX8tJFgu77XNny62HJadyJHWYqyhQWV9+zzbzm2SrGnBTbRODxmeKG6d/Ymk\n20RPta1YZ+zayjB0vL73P9HdpWpTLS1KpIKkW28xtEG7oUFf8ZXu7qMF1tBqtzb2Trf+tCjH\n5TFyGQEAAAB3DwIhcDfQtPqPGsJai5asb/7WtvFvx9OgmCsY7qskkd/Z1q6xN+iHV+hXAox9\n2xhqlbTtjBIROTjPmn7GUL+JVqO96Ff0I79Z18cYhw3T49NEbnIpz+gjIvqVtBv2ph/bKSL6\nnr+0iy8bWnUwlPnTdiouTyMAAADg7kEgBAqdQesywVCtjESstq386fqzQB3k0VQ0Td+1L0vj\n2d9E2mihAbLz2mM/j66yHV11vYPfABGRiDgRkdRjYtMlMFDkyPUOrpVFRE5dFhHxqK4F+8iR\nLXpqesbn+oG10qqKVPSVU3G3HgEAAAB3JZ4yChQyreELhmpl9C3TrT9/n+c0KFev74mva5ZG\nc0kRkcSrD6HRarXQqpXOstMGVUVEj44XEZF0/Uqy+HSXTL/u1GqWFxH9/BUREXM9Q6chWgW/\nLLsw+omIJKU5NAIAAADuSgRCoFBpZkPTKhK/2vbPtlt3zlHCaj0tXWvQT3PNuOCvac0fFxF9\nc+TV9w37GDo+r1mudfCsaQgtIed+0ZOvXvGzbTgmJn9DaMmrHYzFtVqBEv+PnpQqIhL/h9hs\nWstemW4INGptWomIvj/GoREAAABwV+Ino0Chcq0vJqOk+xs6Dr7xo8jfbXvO5bRNVnqybdkq\nY/cOhiff0vft1JM1rVwjrZSPHP/FdubqzzVtv/1u7NfbMGicvmeXuAdp1eqJ7azt5xXXB9k/\nQ2/ygdZhnCEwXL+YrNXppplttkU/Xv3UGmtbv88Q1sg4yFvff0A3uGsVmmgBxfR9c/X4ZIdG\nAAAAwF2JQAgUKtdQERHf2ppv9s/+FkcCoYgcXWRddNLQuK0W2loz6nLxlL52oW371usdopdb\nF8UZwjpqdbuINV4/tEr/+5cs1+5sibZv3za0eUQL7aCZdIk+aPtxnh6dkPG5vvVj25UHtLpN\ntfu6aJpVLpzQVy23/fuf4yMAAADgLqTpuT8y/q4XHh7evn17EYmMjAwKCirscu6UdcqQwi4B\nAO6U8YVZhV2CiMiwdfMLuwQAuFMzwx4r7BJQxHEPIQAAAAAoikAIAAAAAIoiEAIAAACAogiE\nAAAAAKAoAiEAAAAAKIpACAAAAACKIhACAAAAgKIIhAAAAACgKFPB7EZPv/jLVzP/2PDvhWRD\nqbIh3fs/3bFeyRv6jH+0979XUntPnz+gtGfm9l0fPvX6urPB3T/6dGiVgqkWAAAAAFRQQFcI\nV0wa8/3ac90HPfv+Wy+3qZTyxcTh/zuVkL2bZtTWfXsoS5OePmdrjFHTCqZOAAAAAFBHQQRC\na8qpGdtjwsa//kCbpiHVaj80fFJ7H+P/vtiTvWdg69oxO75O1fWMlitRC07a/Ft6WwqgTgAA\nAABQSoEEwuSI4AoVulT0utag1fO2pMXlcIXQK3hASTnz3cnrHx2at86v1lA3bnUEAAAAgPxW\nEEnLxTts6tSpVdyM9rdpCQdmRyUEd6uaUzmWofX9N8zdd/WtnjZ7+/kmA0Ozd9yzZ094eHh4\nePju3bt9fHycVToAAAAAFF0F9FCZDCe2LZv2yey0ip3HdSqTY4eqA8Jin/s6ydbIzaAlRM0/\nbSv5UTnPudm6LVy4cPny5fbXwcHBcXFxTiwaAAAAAIqigvstZurFgzPeHP7sO9+V7vR/X77/\npIcx5+fEeAY9Fmy4MDfisogc+vaf4nWHWHiiDAAAAAA4QQEFwvgTq0Y8NfZfqfPBV3Ne6NfW\nNZeMp5kGNQ7YOnu36KmzdsQ0eyKnX5aKjBs3bvXq1atXr54wYcKePTk8nwYAAAAAkLuC+Mmo\nbkt85+UvLG2fnfZ0a0cu9oX0axM7fNaZk4eiJKhfmWI59nFzc3Nzc7O/sFqt+VovAAAAACih\nIAJhYvT3+xLTBtVy375t2/Udu1WuWyPnh8G4B/YOMS9686OVAfVfdOHnogAAAADgHAURCOOP\nRIjInPffydzoVfbVeZ83yXkDzTiwWYlXVkb2GZvz70UBAAAAAHeuIAJhyebv/Nr81t3eWvBT\nxusaI6f/OvL6R8PmLnJCXQAAAACgNFZ8BwAAAABFEQgBAAAAQFEEQgAAAABQFIEQAAAAABRF\nIAQAAAAARREIAQAAAEBRBEIAAAAAUBSBEAAAAAAURSAEAAAAAEURCAEAAABAUQRCAAAAAFAU\ngRAAAAAAFEUgBAAAAABFEQgBAAAAQFEEQgAAAABQFIEQAAAAABRFIAQAAAAARREIAQAAAEBR\nBEIAAAAAUBSBEAAAAAAURSAEAAAAAEURCAEAAABAUQRCAAAAAFAUgRAAAAAAFEUgBAAAAABF\n5SkQ2s4cO2x/lRy9dcKLw58d997KY/HOKAsAAAAA4GwmB/ulXtr4WFi3X4+WTL2yV0+/2KN6\nyxUXkkRk+pSZcw/u7lfO05lFAgAAAADyn6NXCBf27PPLvtQnXhgpItHbR624kDR82aGLx9fV\nN0eNeWSRMysEAAAAADiFo4Fw0pbo4O4/fPXW0yLy39t/W7zDPukc4lO++SePV76we4ozKwQA\nAAAAOIWjgfBkSrp/07L2199sOV+89gtGERHxqOiRnnTUObUBAAAAAJzI0UDYzMsS+fsuEUmJ\nW7ngfGL9V+rb27ctOW12r+as6gAAAAAATuPoQ2XeGFil+dRBDwzdbtr8nWbym9SiVHryka8m\nT35u/dnANpOdWiIAAAAAwBkcDYRNPlg9MbLTpDnT0jS3QVP+qeVhTohc8sxrMzzLhM378UGn\nlggAAAAAcAZHA6HBVPz1H7a+mhhzxejnbTGIiKtv5//90bRV+6beRs2ZFQIAAAAAnMLRQGh3\ndOOqBX9uPBkd2+L9GX3NUT5lapMGAQAAAOAe5Xgg1L8Y1Hz43A32N+7jp3VNmNa63m8thn4a\nPnO4iVQIAAAAAPcaR58yevT7B4fP3dB2+NR/D0faW3xDPpj0VNO1X43oPuOA08oDAAAAADiL\no4Hw7dEr/ULHhn/2XO3KQfYWk3u1sTPWv1Gr+NqJbzmtPAAAAACAszgaCH+KSao08LHs7b0G\nVEy+sDRfSwIAAAAAFARHA2E5izH+8OXs7Rf3XjJagvK1JAAAAABAQXA0EL7auMSReQM2xSRn\nbkyMWj3oh2P+9V52QmEAAAAAAOdyNBA++MOX5bSTLSvUHTbmTRHZu3D2Wy8OrB7S8aSt1Kc/\nPuzMCgEAAAAATuFoIHQL6LLz318famj4espEEVnz2ugJk+cVa9Lnl53/PVTKw4kFAgAAAACc\nIw8L03uFdJ6/uvOs88f3Ho1KN7qVCalRxsfivMoAAAAAAE6VWyBcsmRJLp+eizq1/drrHj16\n5F9JAAAAAICCkFsg7Nmzp4Oj6LqeH8UAAAAAAApOboFwzZo1Ga9tadHj+w3cmhQ0eORTbZrU\n9DEmH967ccYHn54p23vNsilOLxMAAAAAkN9yC4QtW7bMeP3X0zW3Job8fWJzY7+r9w2279Lr\nqeGDWpWq13tc//2zOji3TAAAAABAfnP0KaMvzT9c6fHpGWnQzuQe+vHQKkd/GOOEwgAAAAAA\nzuVoIDySlG5wyamzQawpp/OzIgAAAABAgXA0ED4c4H7k25cjUqyZG60pJ1+dddi9RF8nFAYA\nAAAAcC5HA+G4GY+lxK2tU7Pz1O9+2bRz//5dm5d8P61LrdrhF5MfnT7WqSUCAAAAAJzB0YXp\ny3WfuXqq6eGXZj4/YGVGo9El4Jmpqz7vXs45tQEAAAAAnMjRQCgirZ/7PGrwi3/+tnLP0ag0\ng2vpyrXadelQzjMPIwAAAAAA7h55i3PmYuW7PfpkNyfVAgAAAAAoQLkFwnr16mkGy47tm+yv\nc+m5c+fOfK4LAAAAAOBkuQVCT09PzXB14UEfH58CqQcAAAAAUEByC4Tr1q279tK2fPlyg4vF\nrBVASQAAAACAguDQshO6Nd7H3a39oqPOrgYAAAAAUGAcCoSa0Xt0qN+x2VudXQ0AAAAAoMA4\nujD9+HXLap8aOXzakgspVqcWBAAAAAAoGI4uO9Ht4XG2wHLTR/Wa/rxrYKkAV3OWJHn8+HEn\n1AYAAAAAcCJHA6Grq6tIUNeuQU6tBgAAAABQYBwNhEuXLnVqHQAAAACAAuboPYQAAAAAgCKG\nQAgAAAAAiiIQAgAAAICiHL2HEAAAAADuHtYpQ/J9TOMLs/J9zLscVwgBAAAAQFG5BcI2dWoO\nWXfG/jo0NPTNk/EFUhIAAAAAoCDk9pPRqCOHDk/66p/XO5oNcuDAgf+2bt58pliOPRs3buyc\n8gAAAAAAzpJbIJw+onmbDyaELZ9gf7u4d/vFN+mp63p+FwYAAAAAcK7cAmHr91cf6/P39mNn\nrbret2/fDp/MHhzoXmCVAQAAAACc6hZPGa3QoEWFBiIiP/30U8eHH36kpEdBFAUAAAAAcD5H\nl5348ccfRSQxctdPS1buOxaVaDWVqlijQ8/e95X1dGZ5AAAAAABnycM6hItf79vvnUUptuu3\nC44b9XSfcd//8OZDTigMAAAAACB+ZmOvfTGzQnydMbij6xAe/7Ff77d+KNFy8A8rN0dGX7h4\nPmrr6p+GtApc9Fbv/j9HOKMyAAAAAIBTOXqF8KNRv3qWHngg/Ct3g2ZvadD6oftadrYFl1w0\ncrI8+KnTKgQAAAAAOIWjVwgXnk+s8tRzGWnQTjO4PzeiatL5BU4oDAAAAADuImkJe196rHOV\n0j7uPoFt+47ZnZBmb0+K3vB/vVqU9PE0Wdwr1Ayb9OMBe3vE8hldG1b387D4l67Y4+n3Llt1\nERE9RdO0d07FZwwbZDENOXwxl3GcytFA6GkwJJ9Lzt6efC5ZM/JcGQAAAABFmp76ZL1ms/f7\nvj/n91U/zyjx76xWjV+xfzK2WdfFUdVn/bpq2z8rR7W3jX+00fFka+rldbW7DZdOzy/7e9Oi\nz8Zsn/tal0/35b6HHMdx9rQc/cnoqBDvsd8+s+3tjQ18LRmNqZd2jPj6kHfl95xTGwAAAADc\nFWL3v/jtsdQ1sXNbeLuISO1VMd36zT+TaivlYij/1CuzBo7sGuAmItUqvTpqaredV1KLxy+P\nt9qGPdOvSSl3ua9e+OJSh92L576LHMep4Orm1Hk5GggH/fTmhBojm5WvM3jEoGa1K7tK0tHd\nG+Z+NvtQosu0Hwc5tUQAAAAAKFynf93g6tvBngZFxCPoyb/+etL+etQL//fXr4s/2HMwIuLY\nrn9+tzd6lnn+8YZzHixfoWXnDs2bNWvfuecDNUvmvoscx3E2R38y6lP1mX0rpzcNipkxaWz/\nvr379O0/9p3p0SUbf/7n3uHVfJxaIgAAAAAULluKTTO4Zm+3ppzqFlLmkTcXXDIWD+v2+LQf\nv7e3G0z+3205vXv1nO4Ny+xf/W37umU6j12Z48jJNj2XcZwtD+sQlmn91Jr9T54+sH3v0agU\nsQRVrF4/tKyjgRIAAAAA7lmlu9VOfmvxtoS0Bp5mEUk8912lui/N2RfR4OToP04kn0leGmg2\niEhi9NUgd279lHd/SZ360djQZl2eE9k34/56L74k7+20fxqbZrO/SIz+8WK6TUQuHsh5HGfL\na6DTylRr0LFr9+5dOzYgDQIAAABQg3/dTx8ItHVt99Rvf23Zsf6PZzo8n+zZvZOvxVK8oW5L\n/WjhmhOnj2/485u+bV4WkX1Ho00l4j+Z/MqAt+du2rl785r/vfv5Qe+qfURENEsTL8vCJydt\nP3hi98Y/Brd92qBpInKzcZz9VJk8XCEEAAAAADVpRs8fdq8e8+Srzz3W/rzV+752Q9dMf1NE\nipV5cfkHEc+++shnl011GrWduHhvyf613mhes3Ns7B+TY17+7OUWE2O9A8ve12bomukv2of6\ndcWnfYdOCqvxUZLV1mzQZ49Ev5T7OM6dl67rTt2Bs4WHh7dv315EIiMjg4KCCrucO2WdMqSw\nSwCAO2V8YVZhlyAiMmzd/MIuAQDu1Mywxwq7hLuXM/5yLsj/CdNtSedi9ZL+7gW2xxxxhRAA\nAAAACppmcCvpX9hFOHwPoS0lJSXt3r6UCAAAAADIwqFAqFvjfdzd2i866uxqAAAAAAAFxqFA\nqBm9R4f6HZu91dnVAAAAAAAKjKMrR4xft6z2qZHDpy25kOLsB58CAAAAAAqCow+V6fbwOFtg\nuemjek1/3jWwVICrOUuSPH78uBNqAwAAAAA4kaOB0NXVVSSoa9d7fl0HAAAAAICdo4Fw6dKl\nTq0DAAAAABx3lyx7e6/L2zqEB1f9sODPjSejY1u8P6OvecPmqNota5ZwUmUAAAAAAKdyPBDq\nXwxqPnzuBvsb9/HTuiZMa13vtxZDPw2fOdykOak8AAAAAMjBsHXz833MmWGP5fuYdzlHnzJ6\n9PsHh8/d0Hb41H8PR9pbfEM+mPRU07Vfjeg+44DTygMAAAAAOIujgfDt0Sv9QseGf/Zc7cpX\nnytjcq82dsb6N2oVXzvxLaeVBwAAAABwFkcD4U8xSZUG5nD9tNeAiskXeN4MAAAAANx7HA2E\n5SzG+MOXs7df3HvJaGEtCgAAAAC49zgaCF9tXOLIvAGbYpIzNyZGrR70wzH/ei87oTAAAAAA\ngHM5Gggf/OHLctrJlhXqDhvzpojsXTj7rRcHVg/peNJW6tMfH3ZmhQAAAAAAp3A0ELoFdNn5\n768PNTR8PWWiiKx5bfSEyfOKNenzy87/Hirl4cQCAQAAAADOkYeF6b1COs9f3XnW+eN7j0al\nG93KhNQo42NxXmUAAAAAoJTEc7M8Sg49npxe3mIsmD3mIRCKLWnZN9MWLF114PjZdJNHcNU6\nXR8eNLR7YxalBwAAAIB7kaM/GbWmnh7cpHzXwWO/X7I2Mi417eKp5Qu+fKpHk9Bu4+KtulNL\nBAAAAIC7hjXNVoib31R6YtxtbOVoIFw7ssOcrdGtnv30eFxC1PEDe46cTrgc8dlzrQ7+Pqnd\nxO23sWMAAAAAuIcEWUyvrZxdr2Qxi8lcsnLjL7ec3/bNi9VK+Vo8/Rv3GhVzLefZUqPeHd67\nTkgZV8/itVr2mbvhbJ42F5HoTXPa1S3v5uIaVLXxxG+35z6sn9n46clTo/u0Ll1hwG1MytFA\nOG7hMd+qr/31yYjgYmZ7i8mj3PCpf70e6vff56/exo4BAAAA4N4ypdfkp2eHH9qzvnexY8+E\n1XpwoT7nzy1rf5i4f+mnfRcft/cZ17L+h2u1lz75bsOqn59uKkNaVP768CXHNxeR7t0mtXxu\nyupVS55t4fLmwIbjNp7Lfdifhnbx7jJm7cYvb2NGjt5DuC8xrfJjD2Vvf+iJim+/tvk2dgwA\nAAAA95b6U38e1qWqiLz2RaMvmi3/ffF7tdxNUjvkpbKvLVh3XvpWSoj8+P3N5/+KndfSxyIi\n9Ru3TFtS/M1n1g1d2c2Rze17afzVyvF9K4lI07COlzcUnzl04SsrbLkMG13hk9cHtbm9GTka\nCHsUd1u7+YRI3RvaT22MsXiF3d6+AQAAAOAeEtjM3/7C7ONqtJSr5X41TxU3GXSbLiJxB5br\nuq2Vr2vmrXxSD4p0c2RzuxGdymS87vdUyJTXF8Ud8Mxl2MoDq9/2jBwNhG9/NaRSr37v/bZ1\nbLfQjMZDf3zY97eTtccvvu3dAwAAAMC9KYf778zebgaTz6W405nXYtAMLg5unv0DFz8XzWDO\nfVgvvxzHd0hugXDkyJGZ37YqY3jlgeoz64c1DA3x0uIPH9j+97ZjRpfA7r4bROrfdgUAAAAA\nUDR4V3xSt/46MyptdIiPiIjoY9qFnX1k1rwnqzo+yOfhUW17V7C/XjB5v3eVD70rBtz5sDnK\nLRDOmDHjxt4m0+n/Np7+b2PGW7FdmDD6+VefHXGHdQAAAADAvc7Vr+vH7Uu/0ry757RXmlbx\nXTlrzCfrI5f9WD5Pgywd0P795I/bVvb4+7t3Ju6+PHVPD1c/3zsfNke5BcK0tLQ73wEAAAAA\nqGPkb9sTn31q0jMPn02xVPv/9u4/uOv6PuD458s3BJPFkPKbCLIbWLTOiroDlTKHwnq99nK7\nHc4BiqUEXT2cq1tPPcRQ9OZaqNCD0iGBMqD+2M0qzruhImeFHtdFPGdRCyhQJDCBgCgIkpDv\n/vAmE0L8MvL9JPB6PP765vN5883r8gd3z/v8eF8xctkrz4z+Upf8/3m2uO/zj9x4zw8m17x3\nZNCQq2b+csPfXvKlM//aU8nkcmf3tvKrVq0aPXp0kiT19fWVlZXtPc6ZOvbIpPYeAeBMZe9e\n1N4jJEmS3L7msfYeAeBMLRgxrr1H6LgK8f98wD94vi+VSZLk8K7f/Xr9Ww2HWrhseNNNN7Xd\nSAAAAKQh3yDc9tT3rxr7yL7G5hbPCkIAAICzTr5BeOftP/0w279m3sMjv3JhUeaL1wMAANDB\n5RuEqz/45PIfrJh+2+UFnQYAAIDUnHIzxBMMLy8+r9d5BR0FAACANOUbhLNnjHr1+995dffh\ngk4DAABAavK9ZfTSKc9MntfzmgsH3fCNP+vfo/SEswsXLmzrwQAAACisfINw7b0j5m3cnyT7\nX/qPX578UhlBCAAApCngnoGFkO8to3fMe7Ws/5h12xoajxw+WUFHBAAAoBDyukKYaz604eOm\nEQsevnpAt0IPBAAAQDryukKYyRQN6JLd//qeQk8DAABAavK7ZTTT5bm5t/zuJ9+c8+8bcgUe\nCAAAgHTk+1KZv/mXzRcUffS9qsvurejds6zzCWffe++9th4MAACAwso3CHv06NHj698aUtBZ\nAAAASFG+Qfj0008XdA4AAABSlm8QHjhwoJWzXbt2bYthAAAASE++QVhRUdHK2VzOu2YAAADO\nMvkG4fTp0z/3c65p55a3nnlyxb7MBdN/9o9tPhYAAACFlm8Q1tTUnHxwzszf3PDl6+b8ZP3U\niePbdCoAAAAKLr99CE+hpPewhTOG7P2v2b868ElbDQQAAEA6zigIkyQp7VeayWQHl564MyEA\nAAAd3BkFYXPjntnTXu9cdkWfzmcalgAAAKQs32cIr7nmmpOONe/a/MbvG478yf3z2nYmAAAA\nUpBvELakU//Lrv+LG27+0dRhbTYOAAAAack3CNetW1fQOQAAAEiZZ/8AAACCau0K4caNG/P8\nlsGDB7fFMAAAAKSntSC8+OKL8/yWXC7XFsMAAACQntaCcPr06a2cyfmGrAAADaRJREFUbW5s\nWDb7n7d+3NgpW9bGQwEAAFB4rQVhTU3NqU5teuHRSdWztn7ceOHXbq5dZNsJAACAs89pv1Tm\n6Adv3j/+2sFfv/03+3pPXbhq65plo7/ctRCTAQAAUFCntQ9h80u10267a+bWw03Xjr+/dv60\nS8qLCzUXAAAABZZvEB7Y+MKU6urla987/w//dMHCRZNHDSroWAAAABTaF98ymmvav3jazf0u\n/cZj6/aPm1q7bfPLahAAAOAc8AVXCN99qXZS9d2/2vZR/+E3P7Vo7p8PrkhnLAAAAAqttSB8\n4JYRD/3i152Kut/28MIHJ4/KJscaGhpaXNm9e/fCjAcAAEChtBaEDy5fmyTJsca9j97314/e\n19q32JgeAADgrNNaEE6ZMiW1OQAAAEhZa0E4d+7c1OYAAAAgZae9MT0AAADnBkEIAAAQlCAE\nAAAIShACAAAEJQgBAACCEoQAAABBCUIAAICgBCEAAEBQghAAACAoQQgAABCUIAQAAAhKEAIA\nAAQlCAEAAIIShAAAAEEJQgAAgKAEIQAAQFCCEAAAIChBCAAAEJQgBAAACEoQAgAABCUIAQAA\nghKEAAAAQQlCAACAoAQhAABAUIIQAAAgKEEIAAAQlCAEAAAIShACAAAEJQgBAACCEoQAAABB\nCUIAAICgBCEAAEBQghAAACAoQQgAABCUIAQAAAhKEAIAAAQlCAEAAIIShAAAAEEJQgAAgKAE\nIQAAQFCCEAAAIChBCAAAEJQgBAAACEoQAgAABCUIAQAAghKEAAAAQQlCAACAoAQhAABAUIIQ\nAAAgKEEIAAAQlCAEAAAIShACAAAEJQgBAACCEoQAAABBCUIAAICgBCEAAEBQghAAACAoQQgA\nABCUIAQAAAhKEAIAAASVdhAu+e6tT+w53OKpaWPHVFVVLa0/eMLx12feVlVVdWftpsJPBwAA\nEEiaQZjbvKb26Z0fNOVyp1qRyWbWLP18+OWafl63N5vJFHw6AACAYIrS+TW71825Z+7ahoNH\nW1/We+RX96ypPZr7afH/FuChnY9vb+5xXdcP3i38kAAAAKGkdIWw4tIbp874p1k/vKf1ZeUD\nJvRJdi3bfvyu0U3L13S7rLrEo44AAABtLaUrhMXlFwwqT44dPe8L1nXqUn1lj/lL3ppUMyxJ\nkiTXuHj9nqtnXtJcc+LCV155ZevWrUmSvPPOO7169dq9e3chxgYAADiHpRSE+Rs8YcS+u2oP\nNw8t6ZQ5uPOxHc19Zl1YtuSkZS+88MLKlSs//dy3b19BCAAAcLo63L2YZZXjBnRqWLLtwyRJ\nNi1d233IpC4tvVGmpKSkvLy8vLy8pKTk2LFjqY8JAABw1utwQZhkiiYO61m3+LdJ7uii1/YO\nv3Vwi6umTp26evXq1atX19TUbNiwIeUZAQAAzgEdLwiT5KLx1+97e9Gu7ct3JpXj+53f3uMA\nAACcmzpiEJb2HnNR5w9nzHqx55WTim1ACAAAUBgdMQiTTPbbw3vV//7QiAkt3y8KAADAmUv1\nLaPZ4n7PPvvsqc4++Pi/ffb50jt/9uydx0/dvuRfCzoYAABAQB3yCiEAAACFJwgBAACCEoQA\nAABBCUIAAICgBCEAAEBQghAAACAoQQgAABCUIAQAAAhKEAIAAAQlCAEAAIIShAAAAEEJQgAA\ngKAEIQAAQFCCEAAAIChBCAAAEJQgBAAACEoQAgAABCUIAQAAghKEAAAAQQlCAACAoAQhAABA\nUIIQAAAgKEEIAAAQlCAEAAAIShACAAAEJQgBAACCEoQAAABBCUIAAICgBCEAAEBQghAAACAo\nQQgAABCUIAQAAAhKEAIAAAQlCAEAAIIShAAAAEEJQgAAgKAEIQAAQFCCEAAAIChBCAAAEJQg\nBAAACEoQAgAABCUIAQAAghKEAAAAQQlCAACAoAQhAABAUIIQAAAgKEEIAAAQlCAEAAAIShAC\nAAAEJQgBAACCEoQAAABBCUIAAICgBCEAAEBQghAAACAoQQgAABCUIAQAAAhKEAIAAAQlCAEA\nAIIShAAAAEEJQgAAgKAEIQAAQFCCEAAAIChBCAAAEJQgBAAACEoQAgAABCUIAQAAghKEAAAA\nQQlCAACAoAQhAABAUIIQAAAgKEEIAAAQlCAEAAAIShACAAAEJQgBAACCEoQAAABBCUIAAICg\nBCEAAEBQghAAACAoQQgAABCUIAQAAAhKEAIAAAQlCAEAAIIShAAAAEEJQgAAgKAEIQAAQFCC\nEAAAIChBCAAAEJQgBAAACEoQAgAABCUIAQAAghKEAAAAQQlCAACAoAQhAABAUIIQAAAgKEEI\nAAAQlCAEAAAIShACAAAEJQgBAACCEoQAAABBCUIAAICgBCEAAEBQghAAACAoQQgAABCUIAQA\nAAhKEAIAAAQlCAEAAIIShAAAAEEJQgAAgKAEIQAAQFCCEAAAIChBCAAAEJQgBAAACEoQAgAA\nBCUIAQAAghKEAAAAQQlCAACAoAQhAABAUIIQAAAgKEEIAAAQlCAEAAAIShACAAAEJQgBAACC\nEoQAAABBCUIAAICgBCEAAEBQghAAACAoQQgAABCUIAQAAAhKEAIAAAQlCAEAAIIShAAAAEEJ\nQgAAgKAEIQAAQFCCEAAAIChBCAAAEJQgBAAACEoQAgAABCUIAQAAghKEAAAAQQlCAACAoAQh\nAABAUIIQAAAgKEEIAAAQlCAEAAAIShACAAAEJQgBAACCEoQAAABBCUIAAICgBCEAAEBQghAA\nACAoQQgAABCUIAQAAAhKEAIAAAQlCAEAAIIShAAAAEEJQgAAgKAEIQAAQFCCEAAAIChBCAAA\nEJQgBAAACEoQAgAABCUIAQAAghKEAAAAQQlCAACAoAQhAABAUIIQAAAgKEEIAAAQlCAEAAAI\nShACAAAEJQgBAACCEoQAAABBCUIAAICgBCEAAEBQghAAACAoQQgAABCUIAQAAAhKEAIAAAQl\nCAEAAIIShAAAAEEJQgAAgKAEIQAAQFCCEAAAIChBCAAAEJQgBAAACEoQAgAABCUIAQAAghKE\nAAAAQQlCAACAoAQhAABAUIIQAAAgKEEIAAAQlCAEAAAIShACAAAEJQgBAACCEoQAAABBCUIA\nAICgBCEAAEBQghAAACAoQQgAABCUIAQAAAhKEAIAAAQlCAEAAIIShAAAAEEJQgAAgKAEIQAA\nQFCCEAAAIChBCAAAEJQgBAAACEoQAgAABCUIAQAAghKEAAAAQQlCAACAoAQhAABAUIIQAAAg\nKEEIAAAQVGpB2PzyE/P+/o7v/NUtkx/44cItHzedvGLa2DFVVVVL6w+ecPz1mbdVVVXdWbsp\nlTkBAACiSCkItzx1/+wn1139l5Nr/m5C2bsvTf3eguaWlmWymTVLPx9+uaaf1+3NZjKpjAkA\nABBIKkGYO/rIk28PHDvjxlHXXHrViLt+NOXQrud/UX/o5IW9R35172u1R3O5z44c2vn49uYe\n13XtksacAAAAkaQRhJ8ceGX7kWOjR1/w6Y9dKr52RVnx+pf/++SV5QMm9El2Ldt+/K7RTcvX\ndLususSjjgAAAG2tKIXfcfTQG0mSfKW082dHLiktWvnGgWT8SUs7dam+ssf8JW9NqhmWJEmS\na1y8fs/VMy9prjlx4YoVK958880kSerr6/v167djx47CzQ8AAHBOSiMImz85lCRJ96Ljl/l6\ndM42HTzS4uLBE0bsu6v2cPPQkk6Zgzsf29HcZ9aFZUtOWlZXV7dy5cpPP3fv3l0QAgAAnK40\ngrBTcUmSJPubmsuy2U+PNDQey1YUt7i4rHLcgE7PLNn24Xf/qOumpWu7D7m9S0tvlBk4cODQ\noUOTJNm3b19dXV3BZk9b9u5F7T0CwDliwYhx7T0CAHR0aTyc1/kPLkuSZOPh41tNbD7c1PWP\nK1penSmaOKxn3eLfJrmji17bO/zWwS2umjhx4vz58+fPn19dXb1ly5YCTA0AAHCOSyMIz6sY\nWVmcfX7t7k9/bDz0+n9+dPTKUX1Otf6i8dfve3vRru3LdyaV4/udn8KEAAAAAaXy+s5M8T+M\nufidJdNXrd+4a8uGxQ/8uLTvDRP6lZ1qeWnvMRd1/nDGrBd7Xjmp2AaEAAAAhZHGM4RJkgy6\n6aE7PpnzxOwHGo5kBl5+3UMzJrdWopnst4f3uu/F+hvvbfl+UQAAAM5cJvd/doE/G61atWr0\n6NFJktTX11dWVrb3OAAAAGcNO74DAAAEJQgBAACCEoQAAABBCUIAAICgBCEAAEBQghAAACAo\nQQgAABCUIAQAAAhKEAIAAAQlCAEAAIIShAAAAEEJQgAAgKAEIQAAQFCCEAAAIChBCAAAEJQg\nBAAACEoQAgAABCUIAQAAghKEAAAAQQlCAACAoAQhAABAUIIQAAAgKEEIAAAQlCAEAAAIShAC\nAAAEJQgBAACCEoQAAABBCUIAAICgitp7gDZz7bXXZrPZ9p4CAAA40fr16ysqKtp7ClqQyeVy\n7T3DGXn//fefe+656urq9h4EAABoWUNDQ7du3dp7Clpw1l8h7N2799ixY/fu3dvegwAAAC0r\nLS1t7xFo2Vl/hRAAAID/Hy+VAQAACEoQAgAABCUIAQAAghKEAAAAQQlCAACAoAQhAABAUIIQ\nAAAgKEEIAAAQlCAEAAAIShACAAAEJQgBAACC+h8VBJlrCmU04AAAAABJRU5ErkJggg=="
     },
     "metadata": {
      "image/png": {
       "height": 420,
       "width": 600
      }
     },
     "output_type": "display_data"
    }
   ],
   "source": [
    "ride_count <- ggplot(bike_trip_df_final, aes(x = casual_or_member, fill = casual_or_member)) +\n",
    "  geom_bar() +\n",
    "  labs(title = \"Number of rides by customer type\", y = \"Number of rides\") +\n",
    "  scale_y_continuous(labels = unit_format(unit = \"M\", scale = 1e-6)) +\n",
    "  geom_text(aes(label = ..count..), stat = \"count\", vjust = 2, colour = \"white\") +\n",
    "  scale_fill_brewer(palette = \"Set2\", direction = -1) +\n",
    "  theme_classic() +\n",
    "  theme(axis.title.x = element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank(), legend.title = element_blank())\n",
    "\n",
    "ride_count"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 28,
   "id": "acb123df",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:46.274840Z",
     "iopub.status.busy": "2022-07-26T13:53:46.273246Z",
     "iopub.status.idle": "2022-07-26T13:53:46.822523Z",
     "shell.execute_reply": "2022-07-26T13:53:46.820711Z"
    },
    "papermill": {
     "duration": 0.568984,
     "end_time": "2022-07-26T13:53:46.825035",
     "exception": false,
     "start_time": "2022-07-26T13:53:46.256051",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "image/png": "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\nAABAUIIQAAAgKEEIAAAQlCAEAAAIShACAAAEJQgBAACCEoQAAABBCUIAAICgBCEAAEBQghAA\nACAoQQgAABCUIAQAAAhKEAIAAAQlCAEAAIIShAAAAEEJQgAAgKAEIQAAQFCCEAAAIChBCAAA\nEJQgBAAACEoQAgAABCUIAQAAghKEAAAAQQlCAACAoAQhAABAUIIQAAAgKEEIAAAQlCAEAAAI\nShACAAAEJQgBAACCEoQAAABBCUIAAICgBCEAAEBQghAAACAoQQgAABCUIAQAAAhKEAIAAAQl\nCAEAAIIShAAAAEEJQgAAgKAEIQAAQFCCEAAAIChBCAAAEJQgBAAACEoQAgAABCUIAQAAghKE\nAAAAQQlCAACAoAQhAABAUIIQAAAgKEEIAAAQlCAEAAAIShACAAAEJQgBAACCEoQAAABBCUIA\nAICgBCEAAEBQghAAACAoQQgAABCUIAQAAAhKEAIAAAQlCAEAAIIShAAAAEEJQgAAgKAEIQAA\nQFCCEAAAIChBCAAAEJQgBAAACEoQAgAABCUIAQAAghKEAAAAQQlCAACAoAQhAABAUIIQAAAg\nKEEIAAAQlCAEAAAIShACAAAEJQgBAACCEoQAAABBCUIAAICgBCEAAEBQghAAACAoQQgAABCU\nIAQAAAhKEAIAAAQlCAEAAIIShAAAAEEJQgAAgKAEIQAAQFCCEAAAIChBCAAAEJQgBAAACEoQ\nAgAABCUIAQAAghKEAAAAQQlCAACAoAQhAABAUIIQAAAgKEEIAAAQlCAEAAAIShACAAAEJQgB\nAACCEoQAAABBCUIAAICgBCEAAEBQghAAACAoQQgAABCUIAQAAAhKEAIAAAQlCAEAAIIShAAA\nAEEJQgAAgKAEIQAAQFCCEAAAIChBCAAAEJQgBAAACEoQAgAABCUIAQAAghKEAAAAQQlCAACA\noAQhAABAUIIQAAAgKEEIAAAQlCAEAAAIShACAAAEJQgBAACCEoQAAABBCUIAAICgBCEAAEBQ\nghAAACAoQQgAABCUIAQAAAhKEAIAAAQlCAEAAIIShAAAAEEJQgAAgKAEIQAAQFCCEAAAIChB\nCAAAEJQgBAAACEoQAgAABCUIAQAAghKEAAAAQQlCAACAoAQhAABAUIIQAAAgKEEIAAAQlCAE\nAAAIShACAAAEJQgBAACCEoQAAABBCUIAAICgBCEAAEBQghAAACAoQQgAABCUIAQAAAhKEAIA\nAAQlCAEAAIIShAAAAEEJQgAAgKAEIQAAQFCCEAAAIChBCAAAEJQgBAAACEoQAgAABCUIAQAA\nghKEAAAAQQlCAACAoAqyHlCxoOSB2S+//v6O/OO7nzr4uuIODTOfBAAAEELGTwhXl46ZMO3V\n0/teecvwQY1XzR894qGKbAcBAACEkWkQVu69Z9p/dhww9vvnndHtlLOvv/PanR8+N2X9ziwn\nAQAAhJFlEO75+OW1u8t79z666rJe4Vk9GtddsuCjDCcBAADEkeUf7O3d+WaSJF0b1qm+06Vh\nwdw3P06u+Pxy1qxZy5cvT5Jk/fr1bdq0WbduXRYzAQAADk1ZBmHFnp1JkjQv+J+nlC3q5O//\ndHf1ZVlZ2dy5c6s+N2/eXBACAAAcRFkG4WF1GyRJsm1/ReP8/Ko7W/aV5xfWrf5Cx44dTz31\n1CRJtm7dWlZWlsnIlOT/9PdZTwA41Dx09sCsJwBALZNlENZpdEKSvLxi1/629T4PwpW79jc9\nq7D6C8XFxcXFxUmSzJs3b9q0admsBAAAOERleahM/cJzj6qb/9zCjVWX+3a+sXjH3m+dd2SG\nkwAAAOLI9LUTeXV/9r3j35t867wlKz5cvezRm+9u2Po7g9o0znISAABAGFn+ZDRJkk79x1+z\n596SCTdv2Z3X8aRe48demWmhAgAABJJxECZ5+b1/OLL3DzNeAQAAEJAHcgAAAEEJQgAAgKAE\nIQAAQFCCEAAAIChBCAAAEJQgBAAACEoQAgAABCUIAQAAghKEAAAAQQlCAACAoAQhAABAUIIQ\nAAAgKEEIAAAQlCAEAAAIShACAAAEJQgBAACCEoQAAABBCUIAAICgBCEAAEBQghAAACAoQQgA\nABCUIAQAAAhKEAIAAAQlCAEAAIIShAAAAEEJQgAAgKAEIQAAQFCCEAAAIKiCrAccmJ49e+bn\n52e9AgAAOABLliwpLCzMegVfIq+ysjLrDV9vw4YNc+bMGTJkSNZDAACAA7Zly5ZmzZplvYIv\nUTueELZq1WrAgAGbN2/OeggAAHDAGjZsmPUEvlzteEIIAADAQedQGQAAgKAEIQAAQFCCEAAA\nIChBCAAAEJQgBAAACEoQAgAABCUIAQAAghKEAAAAQQlCAACAoAQhAABAUIIQAAAgqP8G4hXJ\nmKh1edMAAAAASUVORK5CYII="
     },
     "metadata": {
      "image/png": {
       "height": 420,
       "width": 600
      }
     },
     "output_type": "display_data"
    }
   ],
   "source": [
    "avg_ride_length <- bike_trip_df_final %>%\n",
    "  group_by(casual_or_member) %>%\n",
    "  summarize(average_ride_length = mean(ride_length_in_mins)) %>% \n",
    "  ggplot(aes(x = casual_or_member, y = average_ride_length, fill = casual_or_member)) +\n",
    "  labs(title = \"Average ride length in minutes by customer type\", y = \"Average ride length\") +\n",
    "  geom_bar(stat = \"summary\", fun = \"mean\") +\n",
    "  geom_text(aes(label = round(average_ride_length, 2)), nudge_y = -1, colour = \"white\") +\n",
    "  scale_fill_brewer(palette = \"Set2\", direction = -1) +\n",
    "  theme_classic() + theme(axis.title.x = element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank(), legend.title = element_blank())\n",
    "\n",
    "avg_ride_length"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 29,
   "id": "c1565924",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:46.866751Z",
     "iopub.status.busy": "2022-07-26T13:53:46.864915Z",
     "iopub.status.idle": "2022-07-26T13:53:59.617279Z",
     "shell.execute_reply": "2022-07-26T13:53:59.615249Z"
    },
    "papermill": {
     "duration": 12.779048,
     "end_time": "2022-07-26T13:53:59.623591",
     "exception": false,
     "start_time": "2022-07-26T13:53:46.844543",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "image/png": "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\nrkJggg=="
     },
     "metadata": {
      "image/png": {
       "height": 420,
       "width": 600
      }
     },
     "output_type": "display_data"
    }
   ],
   "source": [
    "ride_count_per_season <- ggplot(bike_trip_df_final, aes(x = casual_or_member, fill = casual_or_member)) +\n",
    "  geom_bar() +\n",
    "  labs(title = \"Number of rides by customer type per season\", y = \"Number of rides\") +\n",
    "  scale_y_continuous(labels = unit_format(unit = \"M\", scale = 1e-6)) +\n",
    "  scale_fill_brewer(palette = \"Set2\", direction = -1) +\n",
    "  facet_wrap(~season) +\n",
    "  theme_classic() +\n",
    "  theme(axis.title.x = element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank(), legend.title = element_blank())\n",
    "\n",
    "ride_count_per_season"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 30,
   "id": "d98d08f3",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:53:59.664029Z",
     "iopub.status.busy": "2022-07-26T13:53:59.662354Z",
     "iopub.status.idle": "2022-07-26T13:54:07.471973Z",
     "shell.execute_reply": "2022-07-26T13:54:07.469772Z"
    },
    "papermill": {
     "duration": 7.831605,
     "end_time": "2022-07-26T13:54:07.474614",
     "exception": false,
     "start_time": "2022-07-26T13:53:59.643009",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "image/png": "iVBORw0KGgoAAAANSUhEUgAABLAAAANICAIAAABYJYFiAAAABmJLR0QA/wD/AP+gvaeTAAAg\nAElEQVR4nOzdeUBU1d/H8e9lFlYBBVFBQEHcNbUkNzS3ykotf1q5oaZWbmXuaam5ZWpalpbl\nlplb1pOmuaRmalqaZi5ZqLjigoiC7Axznz/GBmRzUAaM+379xZw5c+45Z+6ZmQ935l5FVVUB\nAAAAAGiPQ3F3AAAAAABQPAiEAAAAAKBRBEIAAAAA0CgCIQAAAABoFIEQAAAAADSKQAgAAAAA\nGkUgBAAAAACNIhACAAAAgEZpJRDeONlXURRFUSbuj861wt8LmiqKUueN/UXTnyF+pRRF+TvZ\nVDSbuwdJV37q0/phbzdjuVpjC/TAg2/WUxSl3c+X8q82J7i0oig/3Ei5jz7a5MGfakCKcEXY\n7p5fBIrGkmpeiqKsuJZU3B0BAOC/TSuB0GrG071vmtTi7sV/wISwTkt3HDJUC3uyeUhx90Xr\nVHPiL7/88tvvF4q7I/euBAxBg3gRAABAC/TF3YGilhyz6clJ+36d1KS4O/JgU9M+PB1ncKlx\n+sA2FwelQA+t1GXy0uqxftVL26lrGmRKjmjWrJl7wNtx5yYVd1/uUQkYgubcx4sAAAD4D9HW\nEUKXsi+66RwOvNvu++jk4u7LA001J6erqsGl1j18EPRq0L5Xr15tyjnbo2MAisb9vAgAAID/\nEG0FQmevjhtH1Deb4vs+NbXQG1czkpLTMgq92XuhpkanmzWxUdisKPZPu+0D5rSUDHt+0bvw\n22c5AACA/whtBUIRaTZlc+syTtcOTu277lw+1fYNqKkoyv9OXM9aqGbEKYriWraLteTkF80V\nRen7T/TC0Z183DxcHPVupX3Cnnt1f0yKSMYPH41oXCPAzdHg7h3YrvfYkznOa6Kq5s0fjwmr\nWamUk7G0T8XWnV/ecOS65HBuz4rezz7m51Pa0cUzpE7Dge98eirpjqYsZ8QZfPpmwrkfXgyr\n6WZ0+TI6nxMtmH9e/m6H5nXLeroZXT0q124ycMLnl1Izo8K2doEOek8RSYpZqyhKKb8hubaS\n10YPv/NwtpPKmNOjP3/7lYZV/d0cHb19gzr1H3f0Zlqubd51pCISe2zja12frFLBy9Fg9PCq\nGPZMn1W/Xcl7sLflP9Vn/+8pRVEqddiY7VEn5jdVFKX6Szvzbtf048KJTzaqUaaUk6unT72W\nnWav/d16p417Uf6DWlXD2+jWQETiz09WFMWr2pJ/H3SX51Hue/8srB0v5xBsmfAhfqUMzsHp\nt46/0bGxh4urQacvXc7/ia6Dt5+Mz7kJW/acbAq3/QKtQRtXhJoRt+L9Ea1Da3p5uOqNzmX9\nq7br/tqWv+OsFe59vy2MF4GZ1cooitLjQOZpuuIix1jO3TX0nxvWwpg/X1IUxSNgtLXExifr\nHp7TiK9HO+kcHEvVXX/mVv41AQBAJlUbYiNeEhGv6itVVb2y500RMbrVj0w2WSuc+LSJiNQe\n+pvl5t5Xa4hIp79isjZiNt0UERfvztaSiKVhIlL92WoiUvmhph2fauXvrBcR1wodP3qpnuJg\nqP1o6/ZtmrrpHESkXON3rQ8c7OsmIlP71xcRg1u5evWrueodRMRB7z5568WsG903J1ynKIqi\nlKtUs+mjD3m76kXE1a/V9qtJ2Trf79CWeu5G53JV2zzVft315Lym4sOeD4mIoijlguo0b/xI\naYNORDyqdDiemG6pcHLx9DGjhoqIwaXamDFjJkxbl2s7eW30j4kNROTJnVGWaqaUsy/UKG3d\nYnU/DxFxKtO0VzlXEdkYm9lPW0Z67eBsT72DiJQJqtWsRbOalTxExEHnNvev2LzGa8tUpyce\nd3ZQDC41kjPueOzLvm4iMi/qVh5tm97tUt3SgfqNwhrWCdEriog0H/Gt5W4b96L8B3V49qRR\nw/uIiKN70zFjxkx6/3cbn0f1PvZPG58OG3e8nEOwZcIH+7rpjBXCq3qKiN6l7EP1q7vpHURE\nZ/T5aH90QbuaU+G2b/satHFFmE3x/UN9RMRB7/nQI41bNGlYqbSjiOiMFdZfu73de91vC+dF\n4MRnTUUkqPN2a8mhCfUtbyt1hu+3Fu7uXVVEHnn3T9sn08Zqi6uWEZGvohMtN0/93zhnB8Xg\nWvPb03F5DRwAAOSkxUCoqurcNhVFpNpL/2etcD+BUFEMo5cfsJQkR++r5KQXEZ2h7Cc7zlkK\nrx2cb1AURdGdSbkdQS0pRVF0/T/emmZWVVXNSL02b1BjETG41Dj/b7W4yPmODorRrc5n205Z\nSjLSYz4Z3EhEPKq8bP0QaOm8T2W3Vm+uSMow5zMPZ77pISKOHg3XHbk9tLRbEcMeqyAigc98\nkc9Ic8pro9kC4Xc9QkTEI/i5n8/c/pR24dcVNVwMlg+O1o+/No50RKC7iPT8fO+/BRnfj3tU\n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\n22re5eorT3yQWCen7dCuzf5j6ozX2/T+TZYXEAIAADRUhoMwhC53TJtwePaKWVP2Hkp07tV/\n2tRxdQ8lU2++uqq8w5ji2w58tDOEsOipJ4//rxY/+6elz/atf8VEcnS/S373emrYpPo/LwoA\nAMDpSKSPe89747N69eqioqIQQiqVys/Pb9giR2befU43xdlKPrTgdMbuLVmW6Z1w+uYVjjjf\nWwAA4ETe6Q4AABApQQgAABApQQgAABApQQgAABApQQgAABApQQgAABApQQgAABApQQgAABAp\nQQgAABApQQgAABApQQgAABApQQgAABApQQgAABApQQgAABApQQgAABApQQgAABApQQgAABAp\nQQgAABApQQgAABApQQgAABApQQgAABApQQgAABApQQgAABApQQgAABApQQgAABApQQgAABAp\nQQgAABApQQgAABApQQgAABCp/4MgrF2z4t/+ccLf/92ocVOeem7HNzWnGF08/q4VX1bW+6fH\nhg8dPHjwktTBE85vevqewYMHT5y//ZztFwAAIA4ZD8IdL02etfKdvrePe/yB4tyP33j0wXm1\n9Q+mPyyZ/8fSfTXp9A8tlUgmSpZ8P/zSNYvW70kmEud0ywAAAFFomtnl01UzV27tPHzGsEGd\nQwhdpieGFU9/ITV6VPsLj5/64p3Zj8xZu/dg1akXazvgqi9L5leln836rgArSpfvrm3dv+W+\njzO0fwAAgMYrs08ID+9/a/ehI0VF7esOs/NuuCY3a8Oaz04Yy7ty2KNT/2XGU4+cerUWHYvb\nhbLndx/71Oj2pSUX9xzb3BchAQAAzlxmW6qqYnMI4YqcZkfPFOQ03bd5/wljWS3ad+nSpXPn\njj+yXJPssb1bv734g28P09ULN3zZd3TByYOTJ0/u06dPnz59Jk2a1KtXr7O4AwAAgEYrs0FY\ne7gihNCq6bGrtG6WrDl4qMELdisuLN8yv7I2HUI4WLrs09p2xZflnv0+AQAAIpTZ7xA2yWoe\nQviqpjY3maw7s7f6SDIvq8EL5uaP6Njk5cU7vx7fqeX2JWtbXX1vdn2/KHPnnXfedNNNIYQt\nW7ZMnTq1wZcDAABoxDL7hLDZhT1DCNsqj71q4sPKmpY98hq+YqLpmGvbrF+4JaSrFmzc0++u\nbvVO9ejRY9CgQYMGDerZs+e+ffsafjkAAIDGK7NBeEHegPys5Gtrv6g7rK7YtO5AVe9B7c5m\nza4jB5ZvXVC2e2lpyB/Z4aJzsU0AAIAYZfgHOhNZDw/t/tHiJ1Zv2Fa24/2FU57JufTm4g65\nIYQdLy5dtOSVBiyZ03Zo12ZfT53xepved2d5ASEAAEBDZfyNDV3umDbhtitWzJoy4bfTPsy7\nftrM++oumXrz1VV/WtuQFRPJ0f0uSe2qKCyu//OiAAAAnI5EOp0+33vIoNWrVxcVFYUQUqlU\nfn5+wxY5MvPuc7opzlbyoQWnM3ZvybJM74TTN69wxPneAgAAJ/JOdwAAgEgJQgAAgEgJQgAA\ngEgJQgAAgEgJQgAAgEgJQgAAgEgJQgAAgEgJQgAAgEgJQgAAgEgJQgAAgEgJQgAAgEgJQgAA\ngEgJQgAAgEgJQgAAgEgJQgAAgEgJQgAAgEgJQgAAgEgJQgAAgEgJQgAAgEgJQgAAgEgJQgAA\ngEgJQgAAgEgJQgAAgEgJQgAAgEgJQgAAgEgJQgAAgEgJQgAAgEgJQgAAgEgJQgAAgEg1zfwl\natesmPvKWxs/OZDs3uOXoyeO6ZRz8kV/fOax4UPfq6ga+odlxe1zjz+/6el7ppR81nHwjDlj\nL8/kXQAAADQ2GX9CuOOlybNWvtP39nGPP1Cc+/Ebjz44r7ZBMyGERDJRsmT7906laxat35NM\nJDKzdwAAgMYsw0GYrpq5cmvn4VOHDbruyl8U/nr6/RVlr72QqjjjmRBCCG0HXLVn4/yqdPro\nmYrS5btrW/dvmZ3ZuwAAAGiMMhuEh/e/tfvQkaKi9nWH2Xk3XJObtWHNZ2c6U6dFx+J2oez5\n3QePntm+tOTinmObn3QTpaWlW7du3bp1ayqVat68+Tm8IwAAgEYjs0FYVbE5hHBFTrOjZwpy\nmu7bvP9MZ77VJHts79ZvL/7g28N09cINX/YdXXDy4Ny5c0eNGjVq1Kg5c+ZcfrnvFgIAANQj\ns0FYe7gihNCq6bGrtG6WrDl46ExnjupWXFi+ZX5lbTqEcLB02ae17Yovy613EgAAgFPL7K+M\nNslqHkL4qqY2N5msO7O3+kgyL+tMZ47KzR/RscnLi3d+Pb5Ty+1L1ra6+t7s+n5RZsKECSNH\njgwhrFu3bvz48Wd5F8mHFpzlCpwX8wpHnO8tAADAT1pmnxA2u7BnCGFbZc3RMx9W1rTskXem\nM8ckmo65ts36hVtCumrBxj397upW71R+fn5BQUFBQUH79u0rKyvP+j4AAAAaocwG4QV5A/Kz\nkq+t/aLusLpi07oDVb0HtTvTmeN1HTmwfOuCst1LS0P+yA4XZW7zAAAAjVuGXzuRyHp4aPeP\nFj+xesO2sh3vL5zyTM6lNxd3yA0h7Hhx6aIlr5x6pl45bYd2bfb11Bmvt+l9d5YXEAIAADRU\nZr9DGELocse0CYdnr5g1Ze+hROde/adNHVfXoKk3X11V3mFM8W2nmKlfIjm63yW/ez01bFL9\nnxcFAADgdCTSx73nvfFZvXp1UVFRCCGVSuXn55/v7QAAAPyEZPgjowAAAPxUCUIAAIBIZfw7\nhD8R119/ffK79xwC/+/k5+eXlJSc710AADQ2jfw7hJ9//vmqVavGjh17vjcCnJXLLrts165d\n53sXAACNTSN/Qti2bdvhw4fv2bPnfG8EOCstWrQ431sAAGiEGvkTQgAAAH6IH5UBAACIlCAE\nAACIlCAEAACIlCAEAACIlCAEAACIlCAEAACIlCAEAACIlCAEAACIlCAEAACIlCAEAACIlCAE\nAACI1P8C3Rpdo3c9nygAAAAASUVORK5CYII="
     },
     "metadata": {
      "image/png": {
       "height": 420,
       "width": 600
      }
     },
     "output_type": "display_data"
    }
   ],
   "source": [
    "ride_count_by_day_of_week <- ggplot(bike_trip_df_final, aes(x = casual_or_member, fill = casual_or_member)) +\n",
    "  geom_bar() +\n",
    "  labs(title = \"Number of rides by customer type per day of week\", y = \"Number of rides\") +\n",
    "  scale_y_continuous(labels = unit_format(unit = \"M\", scale = 1e-6)) +\n",
    "  scale_fill_brewer(palette = \"Set2\", direction = -1) +\n",
    "  facet_wrap(~day_of_week) +\n",
    "  theme_classic() +\n",
    "  theme(axis.title.x = element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank(), legend.title = element_blank())\n",
    "\n",
    "ride_count_by_day_of_week"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 31,
   "id": "e88177f0",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:54:07.515111Z",
     "iopub.status.busy": "2022-07-26T13:54:07.513285Z",
     "iopub.status.idle": "2022-07-26T13:54:14.973220Z",
     "shell.execute_reply": "2022-07-26T13:54:14.970122Z"
    },
    "papermill": {
     "duration": 7.483972,
     "end_time": "2022-07-26T13:54:14.976778",
     "exception": false,
     "start_time": "2022-07-26T13:54:07.492806",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "image/png": "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"
     },
     "metadata": {
      "image/png": {
       "height": 420,
       "width": 600
      }
     },
     "output_type": "display_data"
    }
   ],
   "source": [
    "ride_count_per_day_and_time <- ggplot(bike_trip_df_final, aes(x = casual_or_member, fill = time_of_day)) +\n",
    "  geom_bar(position = \"dodge\") +\n",
    "  labs(title = \"Number of rides by customer type per day and time\", y = \"Number of rides\") +\n",
    "  guides(fill = guide_legend(title = \"time of day\")) +\n",
    "  scale_y_continuous(labels = unit_format(unit = \"M\", scale = 1e-6)) +\n",
    "  scale_fill_brewer(palette = \"YlGnBu\") +\n",
    "  facet_wrap(~day_of_week) +\n",
    "  theme(axis.title.x = element_blank())\n",
    "\n",
    "ride_count_per_day_and_time\n",
    "# Reminder:\n",
    "# 00:00 - 06:00 is night\n",
    "# 06:00 - 12:00 is morning\n",
    "# 12:00 - 18:00 is afternoon\n",
    "# 18:00 - 21:00 is evening\n",
    "# 21:00 - 23:59 is late evening"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 32,
   "id": "6d904084",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-07-26T13:54:15.018593Z",
     "iopub.status.busy": "2022-07-26T13:54:15.016819Z",
     "iopub.status.idle": "2022-07-26T13:54:19.289525Z",
     "shell.execute_reply": "2022-07-26T13:54:19.287644Z"
    },
    "papermill": {
     "duration": 4.296447,
     "end_time": "2022-07-26T13:54:19.292018",
     "exception": false,
     "start_time": "2022-07-26T13:54:14.995571",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "image/png": "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\nAACgKAIhAAAAACiKQAgAAAAAiiIQAgAAAICiCIQAAAAAoCgCIQAAAAAoikAIAAAAAIoiEAIA\nAACAogiEAAAAAKAoAiEAAAAAKIpACAAAAACKIhACAAAAgKIIhAAAAACgKAIhAAAAACiKQAgA\nAAAAiiIQAgAAAICiCIQAAAAAoCgCIQAAAAAoikAIAAAAAIoiEAIAAACAogiEAAAAAKAoAiEA\nAAAAKIpACAAAAACKIhACAAAAgKIIhAAAAACgKAIhAAAAACiKQAgAAAAAiiIQAgAAAICiCIQA\nAAAAoCgCIQAAAAAoikAIAAAAAIoiEAIAAACAogiEAAAAAKAoAiEAAAAAKIpACAAAAACKIhAC\nAAAAgKIIhAAAAACgKAIhAAAAACiKQAgAAAAAiiIQAgAAAICiCIQAAAAAoCgCIQAAAAAoikAI\nAAAAAIoiEAIAAACAogiEAAAAAKAoAiEAAAAAKIpACAAAAACKIhACAAAAgKIIhAAAAACgKAIh\nAAAAACiKQAgAAAAAiiIQAgAAAICiCIQAAAAAoCgCIQAAAAAoikAIAAAAAIoiEAIAAACAogiE\nAAAAAKAoAiEAAAAAKIpACAAAAACKIhACAAAAgKIIhAAAAACgKAIhAAAAACiKQAgAAAAAiiIQ\nAgAAAICiCIQAAAAAoCgCIQAAAAAoikAIAAAAAIoiEAIAAACAogiEAAAAAKAoAiEAAAAAKIpA\nCAAAAACKIhACAAAAgKIIhAAAAACgKAIhAAAAACiKQAgAAAAAiiIQAgAAAICiCIQAAAAAoCgC\nIQAAAAAoikAIAAAAAIoiEAIAAACAogiEAAAAAKAoAiEAAAAAKIpACAAAAACKIhACAAAAgKII\nhAAAAACgKAIhAAAAACiKQAgAAAAAiiIQAgAAAICiCIQAAAAAoCgCIQAAAAAoikAIAAAAAIoi\nEAIAAACAogiEAAAAAKAoAiEAAAAAKIpACAAAAACKIhACAAAAgKIIhAAAAACgKAIhAAAAACiK\nQAgAAAAAiiIQAgAAAICiCIQAAAAAoCgCIQAAAAAoikAIAAAAAIoiEAIAAACAogiEAAAAAKAo\nAiEAAAAAKIpACAAAAACKIhACAAAAgKIIhAAAAACgKAIhAAAAACiKQAgAAAAAiiIQAgAAAICi\nCIQAAAAAoCgCIQAAAAAoikAIAAAAAIoiEAIAAACAogiEAAAAAKAoAiEAAAAAKIpACAAAAACK\nIhACAAAAgKIIhAAAAACgKAIhAAAAACjK8ILHW/JeN/vx8zvkdDA9vb13dJ+JxxMu0HPxylYe\n9iJx25fPXbfz8PWH+uKlq3Qf1KOQo6lUa7cDAAAAgCpeZAoynt+18NebIe2MxvimkCMhDh7N\nh/QpFd+SP5uNiFxaPWb6iqvvDBjY0y1mw4I5o4dF/bhggM767QAAAACgjhcUCAP3zvhw1t9B\noVFJ2089cC1Zo0aNUolajVHTVpwu3PHrdo0Ki0iRKVq7rlN+DOjexdvGuu0+Ti9kMgAAAADg\npfCCzoq5lmo3evykryd/mKT9yINItwquseEPbgWGxJ83jLy/81pErJ+fj+mpnWutCs62h7bf\nsna7FdcfAAAAAF4+L+gMoW12nyLZJTbKPkn7v6HRxr9ntp91JtpoNDjlfKPTkHebl416dExE\nSjraxC9WwtGw6dj9qHrWbZfOj58uX778yJEjInL79u38+fNfvXrVQtMAAAAAAC+RzLySSmxU\nQKjepkCOGpN/HO9qfLh/46Kvvh1j57u0te0jEfEwPD17mcNGHxMaERdp3fb4pydOnPD39zc9\ndnV1JRACAAAAeCVlZiDU2/qsXLnyyTO72m+PPLfp0NbvTrw11EFE7sXEOev1pteComP1rrY6\nW+u2xxdWuHDhKlWqiEhwcPDBgwetOAUAAAAAkHleritrVvByiH5wx8apjIicDY+Jbz8fHuNS\n2tXa7fFPe/ToMXfu3Llz5/bu3fvSpUtWWFEAAAAAyHyZGQhDzs3p1XvArai4Jw1xO26GuZYs\nau9a39tW/+ffgabW6EdHDjyMqtgol7XbX9R6AwAAAMBLITMDYfZCb3uE3f5w3IKDJ86eP3lk\n+YyROx9l69u7qGi2I9oWv7BknP+hs/9dOrHok6mOuRt2zeNs9XYAAAAAUIlmTHCbeGuLjbrR\num3/9t8tf8fT0dQSee/k4vk/7j56PkKfrZBv6VY9+1bP5ywiYozdvHTGis0HgiK0wuXq9nu/\nTxEnw4toT8zf39/Pz09EAgICvL29X8AUAQAsJc/iUZldArKwGz0mZXYJAPAivNBAmOUQCAEg\n6yIQ4nkQCAEo4uW6qAwAAAAA4IUhEAIAAACAogiEAAAAAKAoAiEAAAAAKIpACAAAAACKIhAC\nAAAAgKIIhAAAAACgKAIhAAAAACiKQAgAAAAAiiIQAgAAAICiCIQAAAAAoCgCIQAAAAAoikAI\nAAAAAIoiEAIAAACAogiEAAAAAKAoAiEAAAAAKIpACAAAAACKIhACAAAAgKIIhAAAAACgKAIh\nAAAAACiKQAgAAAAAiiIQAgAAAICiCIQAAAAAoCgCIQAAAAAoikAIAAAAAIoiEAIAAACAogiE\nAAAAAKAoAiEAAAAAKIpACAAAAACKIhACAAAAgKIIhAAAAACgKAIhAAAAACiKQAgAAAAAiiIQ\nAgAAAICiCIQAAAAAoCgCIQAAAAAoikAIAAAAAIoiEAIAAACAogiEAAAAAKAoAiEAAAAAKIpA\nCAAAAACKIhACAAAAgKIIhAAAAACgKAIhAAAAACiKQAgAAAAAiiIQAgAAAICiCIQAAAAAoCgC\nIQAAAAAoikAIAAAAAIoiEAIAAACAogiEAAAAAKAoAiEAAAAAKIpACAAAAACKIhACAAAAgKII\nhAAAAACgKAIhAAAAACiKQAgAAAAAiiIQAgAAAICiCIQAAAAAoCgCIQAAAAAoikAIAAAAAIoi\nEAIAAACAogiEAAAAAKAoAiEAAAAAKIpACAAAAACKIhACAAAAgKIIhAAAAACgKAIhAAAAACiK\nQAgAAAAAiiIQAgAAAICiCIQAAAAAoCgCIQAAAAAoikAIAAAAAIoiEAIAAACAogiEAAAAAKAo\nAiEAAAAAKIpACAAAAACKIhACAAAAgKIIhAAAAACgKAIhAAAAACiKQAgAAAAAiiIQAgAAAICi\nCIQAAAAAoCgCIQAAAAAoikAIAAAAAIoyZHYBAAAAL5dOx2qNHLY+s6tAFjZlerPMLgEwF2cI\nAQAAAEBRBEIAAAAAUBSBEAAAAAAURSAEAAAAAEURCAEAAABAUQRCAAAAAFAUgRAAAAAAFEUg\nBAAAAABFEQgBAAAAQFEEQgAAAABQFIEQAAAAABRFIAQAAAAARREIAQAAAEBRBEIAAAAAUBSB\nEAAAAAAURSAEAAAAAEURCAEAAABAUQRCAAAAAFAUgRAAAAAAFEUgBAAAAABFEQgBAAAAQFEE\nQgAAAABQFIEQAAAAABRFIAQAAAAARREIAQAAAEBRBEIAAAAAUBSBEAAAAAAURSAEAAAAAEUR\nCAEAAABAUQRCAAAAAFAUgRAAAAAAFEUgBAAAAABFEQgBAAAAQFEEQgAAAABQFIEQAAAAABRF\nIAQAAAAARREIAQAAAEBRBEIAAAAAUBSBEAAAAAAURSAEAAAAAEURCAEAABWhjXEAACAASURB\n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\nNs4T/7hzX9/QGyuTLlCpyRWD3DtyPP7XbiFnNhmNcfXc7LUnhp0JfnjpbDpmJzFzzxB+PfR3\nZ5/uZ/y/ddRpppbX6r9VqW6TuPy5Vg6aKm1mZWz4Im9/0T9yxvLpnwRFaIXL1f1ifB9dprYD\nAAAAyOriIuM0nX0aC8RGXm9RovQBl1p92/nVblaj55BOlcs1ExGdIceyAzc+3r3pr+27dm9d\nOuWjgfVG/PHHJL/U2s0fMUUJM4itu62ms0myQMH+P68bos/l07r1/OEb3ispIjYuDjqD6/2Q\nG1qCxTRdxq9Kqj3zjhEmHrb6AmMOHfqkfJL2Y5MrVxx7OSbqboYreJn5+/v7+fmJSEBAgLe3\nd2aXkxF5Fo/K7BJUd6PHpMwuAVAUfwCRYZ2O1crsEpC1TZmewS/vvcIs/jc57Y9Ydw71yFV1\n9f6QoNecbUQk7PaywuVHLj51pbGbnbuNvvWpu5PD3vWsuPa/iHAvG52IhAX+6OT1zuq7YTXP\nzJv4a9SMrx9Xe2p+jQofhEc+/Pf27mkptouIo17X/8K9D4OHpjZiihWG3V7olKt361WX1rQt\naGoZXz7nXLuvbu3vburwS/fD9q4NtoZE1Hex2/tp9dqTr/9951K1bLYRwRscczT/6mzwcF/T\nNVCMIxrVvvX2wh/6FMvYTJp7htBZp4u4ncKNGSJuR2h6vmwJAAAA4GWRo/ys5l6rmjbqu3Di\ne962QTP7D4twfithNrPzqGyMW/X18u0D6xcMOLlz0vDRInLqYmBdz4ffTB0X7Jqrf9NK2v2L\ns+ecdSk2XETsUmk3f8QUrevqNzliesMiTjuXfTnu+IMZJ1qmuFi1TzY1nufd7q0F1/8aZO/e\ndLqfz0e1WjjP/Kh6UbfNC0d8sztg46oCGZ4rc78pOdTX5cLS/v/ci0zYGHX/8MDvzrkUGZLa\nuwAAAADgBdP0ziuOb23vc31IJ796rd+9Wqr39n8S/cYtW54PNk3p//vHbxcvVeP9rzf3X32y\nT+W8n9UqfSX3x39MHXh00Yd1Klds1vn9O+V7b9/+gYi4+n6aYrv5Iyant83957R2v3zWp1a9\nNosOyVdrTgwu4ZbK6rgs3vhRgP+Qj/6+JSKD1h8a28Z9Qv/2lWs3W3o097KdB/2elTzTmisz\nvzIacnZuvlKDIp18ew7sUbNsEXsJv3h8z5LZi86F2sw8cX1Acddnd5EF8ZVRPD++MgpkFv4A\n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\nEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCC\nEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCC\nEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCC\nEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCC\nEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCC\nEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCC\nEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCC\nEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCC\nEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCC\nEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFCCEAAAIFBpyT39VzP697r9o+23/OqRZ8/I\nrR5FxW88/cDL0z9cvC612cFHXXTlxftnloya6O0AAAChSHIFrZm9pkbu6X17tdi2ZZ9a6VEU\nLZx004hnvrjgij6/yil6ZfT9/a8ueGL0FSmJ3w4AABCOJAfhin+szT6odevWLf5na7zg7mfm\nNT7/d13bN46iqMmwWNcLhz2x9KJfNkhP7Pa8mpX/EwAAAEiWJN8Vm712S87h2Vs3rV2+Yk38\nPxu35E9ftHlrhw55JU+rZR93eFbGrDeWJ3p7ZV00AADAHiHJdwj/tr4w/vZ954z8pDAeT6v5\no47d+l52+qEFG+ZEUXRQZvq23Zpnpk2Zk1/QNrHbo+7fPP3ggw8WL14cRdG8efNyc3NXrlyZ\niGsHAABIrmQG4daCpetT0/et2/rOJ4Zkx9e9/+r44WNvqtb0sTMzNkRRlJv237uXddNTi9Zv\nLt6S2O3bnr744otTpkwpedywYUNBCAAAVEnJDMLUjLxnn332P8+qtTm336dTZv1l3Nxf/KZG\nFEWri4qzUlNLXltZuDU1OyMlI7HbK+GSAQAA9hx71idrHl6vRuHaf6fXPCSKovmbirZtX7Cp\nqM7B2Ynevu3p0KFDZ86cOXPmzDvuuOPvf/97Ai4UAAAg+ZIZhGs+vf+SnlcsLyj+z4biN5dt\nzD7ogOrZJzbISP3T2ytKthZumP3XdQVHtN870dsr67oBAAD2CMkMwtr7n5u78avrBo/+YO78\nBR/PfvqeftM31Lq05wFRLOO3Zzf7bMLgqbPmf7lw7viBd2XWb3dhw6yEbwcAAAhJMv+GMCWt\n7i333/zIQ0/cN/Smzam19m96cL8Rgw/PSo+iqMm5Q3tvuefpEQNXbo41PuyEoUN6lZRrorcD\nAACEIxaPx3e+V6imTp3aoUOHKIqWLl3aoEGDZI+zOxo+cn2yRwjdkovvSPYI4ep39eRkjxC6\nYSM6JfHsfgGy27rNOS7ZI/DDltzffrBL3BgDAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAI\nlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAI\nlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAI\nlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAI\nlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAI\nlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAI\nlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAI\nlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAI\nlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAI\nlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAI\nlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAIlCAEAAAI\n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"
     },
     "metadata": {
      "image/png": {
       "height": 420,
       "width": 600
      }
     },
     "output_type": "display_data"
    }
   ],
   "source": [
    "rideable_type_count <- ggplot(bike_trip_df_final, aes(x = casual_or_member, fill = rideable_type)) +\n",
    "  geom_bar(position = \"dodge\") +\n",
    "  labs(title = \"Number of rides by customer type per rideable type\", y = \"Number of rides\") +\n",
    "  guides(fill = guide_legend(title = \"rideable type\")) +\n",
    "  scale_fill_brewer(palette = \"Dark2\") +\n",
    "  theme_classic() +\n",
    "  theme(axis.title.x = element_blank())\n",
    "\n",
    "rideable_type_count"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "R",
   "language": "R",
   "name": "ir"
  },
  "language_info": {
   "codemirror_mode": "r",
   "file_extension": ".r",
   "mimetype": "text/x-r-source",
   "name": "R",
   "pygments_lexer": "r",
   "version": "4.0.5"
  },
  "papermill": {
   "default_parameters": {},
   "duration": 128.974694,
   "end_time": "2022-07-26T13:54:19.735667",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2022-07-26T13:52:10.760973",
   "version": "2.3.4"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
