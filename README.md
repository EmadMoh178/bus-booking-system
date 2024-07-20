
# Bus Booking System

This is a bus booking system built using Ruby on Rails and PostgreSQL. The application is dockerized for easy setup and deployment.

## Prerequisites

- Docker
## Setup

### 1. Clone the Repository

```sh
git clone https://github.com/EmadMoh178/bus-booking-system.git
cd bus-booking-system
```

### 2. Create the `.env` File

Create a `.env` file in the root directory of the project and add the following environment variables:

```sh
# .env
POSTGRES_USER=your_username
POSTGRES_PASSWORD=your_password
# Use db to run on docker or localhost to run locally
DB_HOST=db
DB_PORT=5432
```

Replace `your_username` and `your_password` with your own chosen username and password for the PostgreSQL database. These credentials will be used to set up and access the database within the Docker container.

### 3. Build and Run the Docker Containers

Build and start the Docker containers:

```sh
docker-compose up --build
```

### 4. Setup the Database

Open a new terminal window and run the following commands to create and migrate the database:

```sh
docker-compose run web rake db:create
docker-compose run web rake db:migrate
docker-compose run web rake db:seed
```

### 5. Access the Application

The application will be available at `http://localhost:3000`.

### 6. Shutting Down the Application

When you're done using the application, you can shut down the Docker containers using the following command:

```sh
docker-compose down
```

This will stop and remove the containers, networks, and volumes created by `docker-compose up`.

## API Endpoints

### Sign Up

**Endpoint:** `/signup`  
**Method:** `POST`  
**Body:**

```json
{
  "user": {
    "name": "Example User",
    "email": "user@example.com",
    "password": "password",
    "password_confirmation": "password"
  }
}
```

### Sign In

**Endpoint:** `/signin`  
**Method:** `POST`  
**Body:**

```json
{
  "email": "user@example.com",
  "password": "password"
}
```

### Check Available Seats

**Endpoint:** `/seats/available`  
**Method:** `GET`  
**Query Parameters:**
- `start_station` (required): The starting station number (1-5)
- `end_station` (required): The ending station number (1-5, end_station > start_station)

**Example Request:**

```
http://localhost:3000/seats/available?start_station=1&end_station=5
```

### Book a Seat

**Endpoint:** `/seats/book`  
**Method:** `POST`  
**Query Parameters:**
- `seat_number` (required): The seat number to book (1-12)
- `start_station` (required): The starting station number (1-5)
- `end_station` (required): The ending station number (1-5, end_station > start_station)

**Example Request:**

```
http://localhost:3000/seats/book?seat_number=3&start_station=2&end_station=4
```

