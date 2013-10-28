# Bus Times Server

Bus Times Server serves as the backend web server for [Bus Times Pebble](https://github.com/keanulee/bus-times-pebble),
which displays upcoming departure times for nearby bus stops on your Pebble watch.

## Bus Data

Bus Times Server uses GTFS data. Download GTFS data in `.txt` format and import it using the `gtfs_import` rake task

```
rake gtfs_import["/path/to/gtfs_data"]
```

where the directory gtfs_data contains:

* calendar.txt
* routes.txt
* stops.txt
* trips.txt
* stop_times.txt

## Response Format

When the Pebble app starts, the watch sends a POST request with the following parameters:

#### Request

```
{
  "0" : 0,
  "1" : <latitude * 10000>,
  "2" : <longtitude * 10000>,
  "3" : <accuracy, in metres>,
  "4" : 0,
  "5" : <button pressed, one of {1,2,3}>
}
```

Bus Times Server responds with a list of (up to 6) stop ids:

#### Response

```
{
  "0" : 1111,
  "1" : 2222,
  "2" : 3333,
  "3" : 4444,
  "4" : 5555,
  "5" : 6666
}
```

The watch then requests for times for a particular `route_index` (routes wrap around after
incrementing past the number of routes) at a particular `stop_id`:

#### Request

```
{
  "0" : <stop_id>,
  "1" : <latitude * 10000>,
  "2" : <longtitude * 10000>,
  "3" : <accuracy, in metres>,
  "4" : <route_index>,
  "5" : <button pressed, one of {1,2,3}>
}
```

The response contains strings that will be displayed on screen:

#### Response

```
{
  "0" : <stop name, up to 15 characters | "Invalid Stop">,
  "1" : <trip headsign, up to 20 characters>,
  "2" : <departure times, up to 11 characters | "No Departures">
}
```

## Pebble Watch Apps

The compiled Pebble apps are in `public/bus-times-pebble-ios.pbw` and `public/bus-times-pebble-android.pbw`.
The apps use the URL of the Bus Times Server; they need to be changed to match your instance of Bus Times
Server and recompiled.

To view the source for the Pebble app, see [Bus Times Pebble](https://github.com/keanulee/bus-times-pebble).
