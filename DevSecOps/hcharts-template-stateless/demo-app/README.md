# DEMO App

This is a demo application to develop and test the templates.

It is a webserver that shows the message from the environment variable `MSG` plus a count number wich starts with the value from the environment variable `COUNT_START`.

## Environment Variables

| Name | Description | Default value |
|-----|-------------|---------------|
|MSG  | Message to print | Default Message |
|COUNT_START | Number to start the count | 0 |

## Endpoints

| Endpoint | Description       |
|---------|--------------------|
| '/show' | Show the message   |
| '/up'   | Increase the count |
| '/down' | Decrease the count |

## How-to run the app

1. Create the image:
    `docker build --pull --rm . -t demo-app:latest`
2. Run the container:
    `docker run --publish 5001:5000 demo-app:latest`
3. Test the app:
    `curl http://127.0.0.1:5001/show`
