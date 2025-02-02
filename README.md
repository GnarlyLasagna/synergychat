# SynergyChat

## About This Fork

I have forked this repository while following along to the Kubernetes lessons on Boot.Dev
I had an issue using the following command because my laptop is an ARM64 processor and not AMD64
```
kubectl create deployment synergychat-web --image=lanecwagner/synergychat-web:latest
```

So my intention was to build the needed Docker images myself with ARM64 to upload my versions to DockerHub for use in lessons

if youre viewing this and by luck need the same solution you can use my file, run this command and continue the lessons
```
kubectl create deployment synergychat-web --image=evandolatowski/synergychat-web:latest
```
simply using my command in place of the one given will allow you to follow along with your ARM64 processor

I have also built and deployed a arm64 version for each other Image used from this SynergyChat project Including:
 - evandolatowski/synergychat-testcpu
 - evandolatowski/synergychat-testram
 - evandolatowski/synergychat-crawler
 - evandolatowski/synergychat-api
 - evandolatowski/synergychat-web



## About


SynergyChat is not only the best workforce chatting tool, but the best analytics engine. SynergyChat is powered by several microservies:

* "web" - The web frontend. This small micro-service serves static HTML, CSS, and JavaScript files that form the shell of the application.
* "api" - The web API. This micro-service is exposed as our public API, and powers the data for the web frontend.
* "crawler" - The analytics crawler. This micro-service scrapes a public repository of books for various keywords and stores them in a database. It is not exposed as a public API, but the "api" micro-service can access its data through internal HTTP requests.

## Web Service

This is a simple Go server that serves static HTML, CSS and JavaScript files intended to be loaded in a web browser.

### Environment Variables

| Name     | Description                                                                                                          | Required | Example                 |
| -------- | -------------------------------------------------------------------------------------------------------------------- | -------- | ----------------------- |
| WEB_PORT | The port the server will listen on                                                                                   | False    | 8080                    |
| API_URL  | The base URL of the API service. If not provided, the page will still load in the browser, but won't be interactive. | False    | `http://localhost:8081` |

## API Service

### Environment Variables

| Name             | Description                                                                                        | Required | Example                            |
| ---------------- | -------------------------------------------------------------------------------------------------- | -------- | ---------------------------------- |
| API_PORT         | The port the server will listen on                                                                 | True     | 8080                               |
| API_DB_FILEPATH  | The file path where the database be created and stored. If omitted, ephemeral memory will be used. | False    | `/var/lib/synergychat/api/db.json` |
| CRAWLER_BASE_URL | The base URL of the crawler service. If not provided slash commands won't work.                    | False    | `http://localhost:8081`            |

### HTTP Endpoints

#### `GET /healthz`

Returns a 200 OK if the service is healthy.

#### `POST /messages`

Creates a new message. Request body example:

```json
{
  "AuthorUsername": "john_doe",
  "Text": "Hello, world!"
}
```

Profane words like "heck", "darn", and "fetch" might cause... problems.

The `/stats` slash command can be used at the beginning of the `Text` field to get a response from the crawler bot. Here are some examples:

* `/stats`: Returns a summary of all keywords crawled in all books.
* `/stats keywords=love`: Returns a summary of the keyword "love" in all books.
* `/stats keywords=love,hate`: Returns a summary of the keywords "love" and "hate" in all books.
* `/stats title=Frankenstein`: Returns a summary of all keywords in the book "Frankenstein".
* `/stats keywords=love,hate title=Frankenstein`: Returns a summary of the keywords "love" and "hate" in the book "Frankenstein".

The keywords need to actually be crawled by the crawler before they can be queried, so make sure the crawler is configured and has been running for a while before querying for keywords.

The array of previously created messages is returned in the response body.

#### `GET /messages`

An array of previously created messages is returned in the response body:

```json
[
    {
        "AuthorUsername": "john_doe",
        "Text": "Hello, world!"
    },
    {
        "AuthorUsername": "jane_sue",
        "Text": "Hello to you ;)"
    }
]
```

## Crawler Service

### Environment Variables

| Name             | Description                                                                                                    | Required | Example                           |
| ---------------- | -------------------------------------------------------------------------------------------------------------- | -------- | --------------------------------- |
| CRAWLER_PORT     | The port the server will listen on                                                                             | True     | 8081                              |
| CRAWLER_KEYWORDS | The keywords to search for. Only included keywords will be counted                                             | True     | love,hate                         |
| CRAWLER_DB_PATH  | The directory path where the database files be created and stored.  If omitted, ephemeral memory will be used. | False    | `/var/lib/synergychat/crawler/db` |

### HTTP Endpoints

#### `GET /healthz`

Returns a 200 OK if the service is healthy.

#### `GET /stats`

Optional query parameters:

* `keywords`: A comma-separated list of keywords to filter the results by. If omitted, all keywords will be returned.
* `title`: A book title to filter the results by. If omitted, all books will be returned.

Returns an array of JSON objects containing the counts of the keywords in the database. For example:

```json
[
  {
    "Keyword": "hate",
    "BookTitle": "The Strange Case of Dr. Jekyll and Mr. Hyde",
    "Count": 10
  },
  {
    "Keyword": "love",
    "BookTitle": "The Strange Case of Dr. Jekyll and Mr. Hyde",
    "Count": 12
  }
  {
    "Keyword": "love",
    "BookTitle": "Frankenstein; Or, The Modern Prometheus",
    "Count": 17
  }
]
```

## TestRAM

A simple application that allocates an arbitrary amount of memory and holds onto it indefinitely. This is useful for testing the Kubernetes Horizontal Pod Autoscaler.

### Environment Variables

| Name      | Description                                           | Required | Example |
| --------- | ----------------------------------------------------- | -------- | ------- |
| MEGABYTES | The number of megabytes the application will allocate | True     | 1000    |

## TestCPU

A simple application that uses as much CPU as possible. This is useful for testing the Kubernetes Horizontal Pod Autoscaler.
