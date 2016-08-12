# OwnLocal REST API

This is my implementation of the REST API project from OwnLocal. It was written with Ruby and Sinatra. I used Sequel and sqlite3 for the database, and RSpec for testing.

<br/>

## How to Run

    $ git clone git@github.com:bhoover85/ol.git
    $ cd ol/
    $ bundle install

From here you can start the web server with `rackup` and browse to http://localhost:9292 or run tests with `bundle exec rspec`.

<br/>

## Endpoints

### `GET /businesses`
Fetches a list of businesses with pagination. Businesses are sorted by id and default to 50 per page. The `page` and `per_page` parameters can be set by passing them in with the request. Output is a JSON object.

*Examples:*

    GET /businesses
    GET /businesses?page=5
    GET /businesses?per_page=100
    GET /businesses?page=5&per_page=100


*Output:*

    {
    "page":1,
    "per_page":50,
    "total":50000,
    "total_pages":1000,
    "businesses":[
        {
        "id":0,
        "uuid":"...",
        "name":"..."
        ...
        },...]
    }

<br/>

### `GET /businesses/:id`
Fetches a specific business. Output is a JSON object.

*Example:*

    GET /businesses/5

*Output:*

    {
        "id":5,
        "uuid":"...",
        "name":"..."
        ...
    }
