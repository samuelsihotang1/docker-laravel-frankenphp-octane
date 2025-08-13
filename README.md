# Laravel FrankenPHP Docker

This repository contains a boilerplate for running a Laravel application with FrankenPHP inside a Docker container.

## Tech Stack

This project uses the following technologies:

* **[Docker](https://www.docker.com/)**: A platform for developing, shipping, and running applications in containers.
* **[FrankenPHP](https://frankenphp.dev/)**: A modern application server for PHP, written in Go.
* **[Laravel](https://laravel.com/)**: A web application framework with expressive, elegant syntax.
* **[Laravel Octane](https://laravel.com/docs/11.x/octane)**: A package that supercharges application performance by using high-powered servers like FrankenPHP and Swoole.
* **[MySQL](https://www.mysql.com/)**: An open-source relational database management system.
* **[phpMyAdmin](https://www.phpmyadmin.net/)**: A free and open source administration tool for MySQL and MariaDB.

## Getting Started

To get the application running on your local machine, please follow these steps.

### Prerequisites

Make sure you have [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/) installed on your system.

### Installation

1.  **Clone the repository:**

    ```bash
    git clone [https://github.com/samuelsihotang1/docker-laravel-frankenphp-octane.git](https://github.com/samuelsihotang1/docker-laravel-frankenphp-octane.git)
    cd docker-laravel-frankenphp-octane
    ```

2.  **Run the application with Docker Compose:**

    ```bash
    docker-compose up -d --build
    ```

    This command will build the Docker images and start the services in detached mode. The first time you run this, it will also:
    * Install a fresh Laravel project if one doesn't exist.
    * Install composer dependencies.
    * Install Laravel Octane with the FrankenPHP server.
    * Run database migrations.

### Accessing the Application

Once the containers are up and running, you can access the different services:

* **Laravel Application**: [http://localhost:8000](http://localhost:8000)
* **phpMyAdmin**: [http://localhost:8001](http://localhost:8001)
* **Database**: The MySQL database is accessible on port `3307` on your local machine.

## Performance Comparison 

Here is a performance comparison using Pest's stress testing. The test compares a standard Laravel setup against this project's Laravel Octane with FrankenPHP configuration.

### Standard Laravel (`php artisan serve`)

* **Requests per Second**: `3.38 reqs/s` (Total 17 requests)
* **Average Request Duration**: `292.78 ms`

### Laravel Octane + FrankenPHP

* **Requests per Second**: `38.24 reqs/s` (Total 192 requests)
* **Average Request Duration**: `24.00 ms`

### Summary

| Metric                | Standard Laravel | Octane + FrankenPHP | Improvement           |
| :-------------------- | :--------------- | :------------------ | :-------------------- |
| **Requests/Second** | 3.38 reqs/s      | **38.24 reqs/s** | ~11.3x More Requests  |
| **Avg. Request Time** | 292.78 ms        | **24.00 ms** | ~12.2x Faster         |

As you can see, **Laravel Octane with FrankenPHP offers a significant performance improvement** by keeping the application in memory, which drastically reduces request overhead.

## Application Configuration

The main configuration for the Docker environment is in the `docker-compose.yml` file. Here you can find the definitions for the `app`, `mysql`, and `phpmyadmin` services.

The Laravel application's environment variables are set within the `docker-compose.yml` and are used by the `init.sh` script to configure the `.env` file inside the `app` container.

Key environment variables:

* **`DB_CONNECTION`**: `mysql`
* **`DB_HOST`**: `mysql`
* **`DB_PORT`**: `3306` (within the Docker network)
* **`DB_DATABASE`**: `laravel_db`
* **`DB_USERNAME`**: `laravel`
* **`DB_PASSWORD`**: `secret`

## Stopping the Application

To stop the services, run the following command in the project directory:

```bash
docker-compose down
