
1. What is Docker
2. Why Docker is needed (Problem it solves)
3. Virtual Machines vs Docker
4. Docker Architecture
5. Docker Image
6. Docker Container
7. Dockerfile
8. Docker Registry
9. Docker Volumes
10. Docker Networks
11. Docker Commands (important ones)
12. How Docker Works Internally
13. Docker Workflow
14. Using Docker with Spring Boot
15. Docker Compose

---

# 1. What is Docker

Docker is an **open-source platform used to develop, ship, and run applications inside containers**.

In simple words:

Docker allows developers to **package an application with all its dependencies** (libraries, runtime, system tools, configurations) into a **single unit called a container**.

This container can run **anywhere**:

* developer laptop
* testing server
* production server
* cloud platforms

without changing anything.

### Formal Definition

Docker is a **containerization platform** that uses **OS-level virtualization** to deliver software in packages called **containers**.

### Key Idea

Instead of installing software directly on the machine, Docker runs the software inside **isolated environments called containers**.

These containers share the **host operating system kernel**, making them lightweight and fast.

### Example

Suppose a Spring Boot application requires:

* Java 17
* Maven
* MySQL
* Some specific libraries

Normally these must be installed manually.

With Docker, everything is packaged inside an **image**, and then run as a **container**.

---

# 2. Why Docker is Needed (Problem it Solves)

Before Docker, developers faced many problems during deployment.

### Problem 1 — Environment Differences

Example:

Developer machine

```
Java 17
MySQL 8
Ubuntu
```

Production server

```
Java 11
MySQL 5
CentOS
```

Result:

Application fails.

This problem is commonly called:

> "Works on my machine problem"

Docker solves this by packaging **everything required by the application**.

---

### Problem 2 — Complex Installation

Large applications require many dependencies:

* Java runtime
* Python runtime
* libraries
* environment variables

Installing them manually is time consuming.

Docker automates this.

---

### Problem 3 — Application Conflicts

Two applications may need different versions.

Example

```
Application A → Java 11
Application B → Java 17
```

Running both on the same machine is difficult.

Docker solves this by isolating them in separate containers.

---

# 3. Virtual Machines vs Docker

Before containers, virtualization was used.

## Virtual Machine Architecture

A Virtual Machine includes:

* Guest Operating System
* Application
* Libraries
* Hypervisor

Structure

```
Hardware
Hypervisor
VM1 (OS + App)
VM2 (OS + App)
VM3 (OS + App)
```

Each VM includes **full OS**, making them heavy.

---

## Docker Architecture

Docker containers share the host OS kernel.

```
Hardware
Host OS
Docker Engine
Container1
Container2
Container3
```

Containers only include:

```
Application
Dependencies
Libraries
```

---

### Comparison

| Feature     | Virtual Machine | Docker    |
| ----------- | --------------- | --------- |
| OS          | Separate OS     | Shared OS |
| Size        | GB              | MB        |
| Boot Time   | Minutes         | Seconds   |
| Performance | Slower          | Faster    |

---

# 4. Docker Architecture

Docker works using **three main components**.

### Docker Client

The Docker client is the **command line interface** used by users.

Example commands

```
docker run
docker build
docker pull
docker push
```

The client communicates with Docker Daemon using REST API.

---

### Docker Daemon

The Docker daemon is the **background service responsible for managing Docker objects**.

Responsibilities:

* build images
* run containers
* manage networks
* manage volumes

The daemon listens to Docker API requests.

---

### Docker Registry

A Docker registry is a **storage system for Docker images**.

Example registries:

* Docker Hub
* Amazon ECR
* Google Container Registry

Example command

```
docker pull mysql
```

This downloads the MySQL image from Docker Hub.

---

# 5. Docker Image (In Depth)

A **Docker image is a read-only template used to create containers**.

It contains everything needed to run an application:

* application code
* runtime
* system libraries
* dependencies
* environment variables

Images are built using **Dockerfile**.

---

## Image Layers

Docker images are built in **layers**.

Example Dockerfile

```
FROM openjdk:17
COPY app.jar app.jar
RUN apt-get update
CMD java -jar app.jar
```

Each instruction creates a **layer**.

Layers make Docker efficient because they can be reused.

---

## List Images

Command:

```
docker images
```

Example output

```
REPOSITORY     TAG       IMAGE ID
mysql          latest    123abc
nginx          latest    456def
```

---

## Pull Image

Download image from registry.

```
docker pull nginx
```

---

## Remove Image

```
docker rmi image_id
```

---

# 6. Docker Container (In Depth)

A **container is a running instance of a Docker image**.

Think of image as blueprint and container as running program.

Example:

```
docker run nginx
```

Flow

```
nginx image → container created → nginx server running
```

Containers are:

* lightweight
* isolated
* fast to start

---

## Container Lifecycle

Container states:

```
Created
Running
Paused
Stopped
Deleted
```

---

## List Running Containers

```
docker ps
```

---

## List All Containers

```
docker ps -a
```

---

## Stop Container

```
docker stop container_id
```

---

## Remove Container

```
docker rm container_id
```

---

# 7. Dockerfile (In Depth)

A **Dockerfile is a script containing instructions used to build a Docker image**.

It automates image creation.

Example Dockerfile

```
FROM openjdk:17
WORKDIR /app
COPY target/app.jar app.jar
ENTRYPOINT ["java","-jar","app.jar"]
```

---

## Dockerfile Instructions

### FROM

Specifies base image.

```
FROM openjdk:17
```

---

### WORKDIR

Sets working directory.

```
WORKDIR /app
```

---

### COPY

Copies files.

```
COPY target/app.jar app.jar
```

---

### RUN

Executes command during build.

```
RUN apt-get update
```

---

### CMD

Default command.

```
CMD ["java","-jar","app.jar"]
```

---

### ENTRYPOINT

Main command executed.

```
ENTRYPOINT ["java","-jar","app.jar"]
```

---

# 8. Docker Volumes

Containers are temporary.

If container deletes, data is lost.

Docker volumes provide **persistent storage**.

Example:

```
docker volume create myvolume
```

Run container with volume

```
docker run -v myvolume:/data mysql
```

Used for:

* database storage
* logs
* file uploads

---

# 9. Docker Network

Containers communicate using Docker networks.

Types:

### Bridge Network

Default network.

Containers communicate internally.

---

### Host Network

Container uses host network directly.

---

### None Network

No network access.

---

Create network

```
docker network create mynetwork
```

Run container in network

```
docker run --network=mynetwork nginx
```

---

# 10. Important Docker Commands

### Pull image

```
docker pull mysql
```

---

### Build image

```
docker build -t myapp .
```

---

### Run container

```
docker run nginx
```

---

### Run container with port mapping

```
docker run -p 8080:80 nginx
```

---

### Check logs

```
docker logs container_id
```

---

### Execute command inside container

```
docker exec -it container_id bash
```

---

### Stop container

```
docker stop container_id
```

---

# 11. How Docker Works Internally

Docker uses Linux kernel features:

### Namespaces

Provide isolation.

Separate:

* process
* network
* file system

---

### Control Groups (cgroups)

Limit resource usage.

Example:

* CPU
* memory
* disk

---

### Union File System

Used to manage image layers.

Allows multiple layers to be stacked.

---

# 12. Docker Workflow

Typical development workflow:

```
Write Code
↓
Create Dockerfile
↓
Build Image
↓
Run Container
↓
Test Application
↓
Push Image to Registry
↓
Deploy
```

---

# 13. Using Docker with Spring Boot

Step 1 — Build project

```
mvn clean package
```

Generates

```
target/app.jar
```

---

Step 2 — Create Dockerfile

```
FROM openjdk:17
WORKDIR /app
COPY target/app.jar app.jar
ENTRYPOINT ["java","-jar","app.jar"]
```

---

Step 3 — Build image

```
docker build -t springboot-app .
```

---

Step 4 — Run container

```
docker run -p 8080:8080 springboot-app
```

Application runs at

```
http://localhost:8080
```

---

# 14. Docker Compose

Docker Compose is used to run **multiple containers together**.

Example:

Spring Boot + MySQL.

---

## docker-compose.yml

```
version: '3'

services:

  mysql:
    image: mysql:8
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: testdb
    ports:
      - "3307:3306"

  springboot:
    build: .
    ports:
      - "8080:8080"
    depends_on:
      - mysql
```

---

Run application

```
docker-compose up
```

Stop

```
docker-compose down
```

---

# 15. Real Industry Example

Microservices architecture:

```
API Gateway
User Service
Order Service
Payment Service
Database
Redis
Kafka
```

Each runs in its own container.

Example containers

```
user-service-container
order-service-container
mysql-container
redis-container
kafka-container
```

Docker Compose or Kubernetes manages them.

---

# 16. Advantages of Docker

1. Portability
2. Fast deployment
3. Isolation
4. Consistency
5. Efficient resource usage
6. Ideal for microservices

---

