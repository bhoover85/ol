# OwnLocal REST API

This is my implementation of the REST API project from OwnLocal. It was written with Ruby and Sinatra. I used Sequel and sqlite3 for the database, and RSpec for testing.

I chose Sinatra over Rails due to its light weight and flexibility. Since there are only two endpoints I felt that Sinatra would be a great fit for what I was trying to accomplish. Adding a few more endpoints would still fit well within its scope. If this were a larger project, or had the potential to be, I would use Rails due to its features and MVC pattern.

If we wanted to add authentication we could do so with Rack::Auth::Basic or use an available gem such as sinatra-authentication.

<br/>

## How to Run

    $ git clone git@github.com:bhoover85/ol.git
    $ cd ol/
    $ bundle install

From here you can start the web server with `rackup` and browse to http://localhost:9292 or run tests with `bundle exec rspec`. On first load the database will be created and populated with the CSV data.

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
    "page":5,
    "per_page":100,
    "total":50000,
    "total_pages":500,
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
