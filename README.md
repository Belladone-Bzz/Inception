## Description

Inception is a system administration project focused on Docker and containerized infrastructure. The goal of the activity is to build a small WordPress infrastructure inside a virtual machine using Docker Compose. The infrastructure is composed of three dedicated services:

- **NGINX**: the only public entry point. It handles HTTPS/TLS connections and forwards PHP requests to WordPress/PHP-FPM.
- **WordPress + PHP-FPM**: hosts the WordPress application and executes PHP code.
- **MariaDB**: stores the WordPress database.

The services communicate through a dedicated Docker network. Persistent data is stored in two Docker named volumes: one volume for the MariaDB database; one volume for the WordPress website files. Only NGINX is exposed to the host, on port `443`, using TLS 1.2 or TLS 1.3.

**This project allowed me to greatly improve the following skills:**
- Functional Documentation
- Container Networking
- Data Persistence Strategies
- Web Stack Deployment
- Containerization
- Web Server Configuration
- Secrets Management
- Container Orchestration

## What is Containerisation ?

### Why use containerisation ?
Developers may face a major problem: creating a brilliant programme on their computer, only to realize that it only works on their own computer. To use it elsewhere, they will need to install the necessary dependencies. It’s possible to provide a great script that will install these dependencies, but you can’t assume that the user is on a Mac or Linux, or that they’re running a version of the OS so old that it doesn’t even recognize your dependencies. Containerisation helps to overcome this problem.

Containers  are lightweight virtualized environments that package all the dependencies and code an application needs to run into a single text file, which can run the same way on any machine. A container is like a virtual machine but without a kernel (the entire system that enables the virtual machine to run, including the OS, graphics, networking, etc.). In other words, a container contains only the application and its dependencies. 

### Containers vs Virtual Machine
Containers and Virtual machines have similar resource isolation and allocation benefits but function differently because containers virtualise the operating system instead of the hardware. Containers are more portable and efficient. Virtualisation and containerisation are based on different approaches: the former focuses on the infrastructure, whilst the latter focuses on the application. Containerisation does not always replace virtualisation, but it has clearly supplanted it in many modern use cases.

**Containers** are a simulation at the app layer that packages code and dependencies together. Multiple containers can run on the same machine and share the OS kernel with other containers, each running as isolated processes in user space. Containers take up less space than VMs (talking about tens of MBs in size), can handle more applications, and require fewer VMs and Operating Systems. They are particularly useful when you want to:
- Deploy applications quickly
- Work with microservices
- Automate your environments
- Streamline the transition from dev to prod

**Virtual Machines (VMs)** are a simulation of physical hardware turning one server into many servers. The hypervisor allows multiple VMs to run on a single machine. Each machine includes a full copy of an operating system, the application, necessary binaries, and libraries. VMs take more space compared to containers (talking about tens of GBs in size), and they can be slow to boot. This approach is suitable for complex or heterogeneous environments, such as:
- Testing multiple versions of an operating system
- Running ‘legacy’ applications in their native environment
- Isolating environments with high security requirements

<p align="center">
<img src="https://www.techtarget.com/rms/onlineimages/containers_vs_virtual_machines-f.png"  width="865px"/>
</p>

### How do containers work ?
The effectiveness of containers rely on several key features of the Linux kernel, including namespaces (isolation of resources: network, PID, users...), capabilities (privileges control of root) and cgroups (resources limitation: CPU, memory, I/O...). The combination of namespaces, capabilities and cgroups enables containers to run in an isolated, secure and efficient manner. Namespaces ensure resource isolation, capabilities control process privileges and cgroups manage resource allocation.

#### Container image and Dockerfile:
A container image is a kind of snapshot of an application, ready to be launched in an isolated environment. It contains everything needed for the application to run: code, dependencies, environment variables, configuration files, etc.

These images are built using a recipe file called a Dockerfile. It describes, step by step, how to build your image. This Dockerfile is a simple text file. Each instruction in the Dockerfile creates a layer in the image. These layers are stacked on top of one another and cached, which makes the process:
- Fast (only modified layers are rebuilt)
- Lightweight (layers can be shared across multiple images)

This layer-based approach also saves space and makes updates easier. To optimise the layers, it is recommended to place instructions that rarely change (installing dependencies) at the top of the Dockerfile, and those that change frequently (copying code) at the bottom. This ensures that the cache is reused as much as possible.

**To turn a Dockerfile into a runnable container image, we need to use a build tool.**

## Containers building tools
Historically, `docker build` was used to turn Dockerfile into runnable image, but nowadays there are other, more flexible and modern solutions available. Many tools are used: Buildah (Developed by Red Hat) ; Docker ; Kaniko(Developed by Google) etc.

**The contribution of these tool was to bring together existing building blocks of contenairisation (namespaces, cgroups, capabilities) and the image format into a usable tool, whereas previous technologies required considerable system expertise.** 

Each tool has its own advantages depending on your context. For this project, Docker is the tool being used which is ideal for development and learning.

### Why use Docker ?

Solomon Hykes launched Docker on 20 March 2013. It was developed for an internal project at dotCloud, a French company and has been distributed as an open-source project since March 2013 and is currently the most widely used containerization engine.

The advantage of using Docker :
- The most popular choice for application containerisation (lot of documentation)
- Easy to get started with, even for beginners

## Secrets Docker vs Environment Variables
### Containers Security
Containers have revolutionized application deployment, but they also introduce specific security concerns. Containers share the host's kernel, unlike virtual machines which have their own kernel. A vulnerability in the kernel or an overly privileged container can therefore potentially affect the host and other containers.

Security must therefore be considered at several levels. One particularly important aspect is secret management.

### What is secret ?
A secret is sensitive information that an application needs in order to operate.

Typical examples include: Database passwords ; API keys ; SSH private keys ; Authentication tokens etc. There are several ways to provide this information to a container.

### Use of .env files for secret ?
A .env file can contain sensitive data and the Compose file can reference these variables, but a .env file is not a secret management system.

Process with variable in .env is much more secure than just puting potential sensitive data in environement variable, if the .env file is excluded from Git inside a .gitignore.

### Docker Secrets
Docker provides a dedicated mechanism called Docker Secrets. 

This is safer because the secret is not part of the image itself. The access to a secret is also explicitly granted to the services that need it.


## Docker Network vs Host Network
Containers are isolated from each other by default. This isolation also applies to networking. Docker provides several network drivers to control how containers communicate with each other and with the host. 

### Docker Network
A Docker network provides an isolated virtual network that containers can join.

When several containers are connected to the same Docker network, they can communicate with each other without exposing their ports directly to the host.

One of the advantages of a Docker network is Docker's internal DNS. Instead of using an IP address, containers can communicate using the service name defined in Docker Compose. This is important because container IP addresses can change when containers are recreated. The service name remains stable even if the underlying container changes.

Docker networking should not be considered a complete security boundary. A network configuration can reduce the attack surface, but it does not replace authentication, encryption, firewalls, or application-level security.

### Host Network
The host network works differently. Instead of giving the container its own isolated network namespace, Docker makes the container use the host's network stack directly. Port publishing is therefore unnecessary for this container. 

## Docker Volumes vs Bind Mounts
Containers are designed to be temporary and replaceable. If a container is deleted, the data stored inside is normally deleted with it. This becomes a problem for stateful applications such as MariaDB or WordPress, where data must survive container restarts and recreation.

Docker provides several mechanisms to persist data outside the container's writable layer. Two of the most common are Docker volumes and Bind mounts.

### Docker Volume
A Docker volume is storage managed by Docker itself. The important point is that the application sees: `/var/lib/mysql` (for a sql database for exemple) as a normal directory, while Docker manages where the data is physically stored on the host. 

On a typical Linux installation, Docker-managed volumes are stored somewhere under Docker's data directory, commonly: `/var/lib/docker/volumes/`. Volumes are particularly useful when Docker should manage the storage lifecycle. Volumes are well suited for databases and other persistent application data.

### Bind Mounts
For Bind mount, instead of asking Docker to manage the storage location, we explicitly choose a directory or file on the host and mount it into the container. Docker makes it available inside the container. Changes made on the host are visible inside the container, and depending on the mount mode, changes made inside the container can also affect the host files.

Bind mounts are useful when the files need to be directly controlled by the host. 

## Project Description
For this project, containers are appropriate because each service only needs its application, its dependencies and its configuration. The project itself still runs inside the required virtual machine: Docker provides application-level isolation inside that VM.

### Project architecture

<p align="center">
<img src="https://42-cursus.gitbook.io/guide/~gitbook/image?url=https%3A%2F%2F2977649544-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252Fz2zo8aAL0o31034sj7J7%252Fuploads%252FyvhymcEvTigTobYKwak9%252Fimage.png%3Falt%3Dmedia%26token%3D17454441-90ab-4a27-ac75-76a30d0bc2f3&width=768&dpr=3&quality=100&sign=7aff84a6f2485582c4524e8a181b1581&sv=3"  width="865px"/>
</p>

### Sources included and design choices

### Why three containers?

Each service has a distinct responsibility. NGINX handles incoming HTTPS traffic, WordPress/PHP-FPM handles the application, and MariaDB handles persistent relational data. Keeping them separated makes the architecture easier to understand, maintain, restart and debug. It also follows the project requirement that each service runs in its own dedicated container.

### NGINX
NGINX is the public entry point of the infrastructure. It listens on port `443`;accepts HTTPS connections ; enables TLS 1.2 and TLS 1.3 ; serves the WordPress files ; forwards PHP requests to `wordpress:9000` through FastCGI ; is the only service exposed to the host.

MariaDB and PHP-FPM are not published directly to the host.

### WordPress and PHP-FPM
The WordPress container contains: WordPress ; PHP 8.2 ; PHP-FPM ; the PHP MySQL extension ; WP-CLI. PHP-FPM listens on port `9000` inside the Docker network. NGINX communicates with it using `wordpress:9000`. The hostname `wordpress` is the Docker Compose service name and is resolved through Docker's internal DNS.

### MariaDB
MariaDB is installed directly in a Debian-based custom image. It listens on port `3306` inside the Docker network and stores its database files in the persistent `db_data` volume. MariaDB is not exposed through a host port because only WordPress needs to access it.

### Docker network
The project uses a dedicated Docker bridge network named `inception`.

This allows connection from NGINX to wordpress(9000) and from wordpress to mariadb(3306) without exposing those internal ports to the host. Using service names instead of hard-coded container IP addresses is important because container IP addresses can change when containers are recreated.

### Persistent storage
Two named volumes are used: `wp_files` mounted at `/var/www/html` abd `db_data` mounted at `/var/lib/mysql`.

The volumes are configured so that their persistent data is stored in `/home/user/data/` on the host . Of course, `user` correspond to the actual 42 login.

### Secret management
For this project, a .env file is used for the secrets and can't be exposed on Git repository thanks to a .gitignore containing .env. 

## Instructions

### Prerequisites
The project must be run inside the required virtual machine. The environment needs Docker ; Docker Compose ; `make` ; a working DNS/hosts configuration for `<user>.42.fr` ; enough disk space for the Docker images and persistent data.

### Configuration
Create the local environment file as follow:

```bash
cp srcs/.env_example srcs/.env
```

Then edit it and define all variables. The administrator username must not contain `admin` or `administrator`, as required by the subject.

### Makefile
The following rules, to use at the repository root, are integrates to the makefile:

```bash
# To build and start the infrastructure
make
```

```bash
# To stop the infrastructure
make down
```

```bash
# To rebuild the infrastructure
make re
```

```bash
# To clean
make clean
```

Use cleanup commands carefully because Docker cleanup can remove resources that are not related to this project.

## **Resources**
- Peer learning. BIG thanks to Audrey, Benjamin, Jolyne(The Queen), Luka, Ady <3
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose file reference](https://docs.docker.com/reference/compose-file/)
- [Docker volumes](https://docs.docker.com/engine/storage/volumes/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [MariaDB documentation](https://mariadb.com/docs/)
- [PHP-FPM documentation](https://www.php.net/manual/en/install.fpm.php)
- [WordPress developer documentation](https://developer.wordpress.org/)
- [Inception guide — Medium](https://medium.com/@imyzf/inception-3979046d90a0)
- [Inception tutorial — GradeMe](https://tuto.grademe.fr/inception/)
- [Application containerization — TechTarget](https://www.techtarget.com/searchitoperations/definition/application-containerization-app-containerization)
- [Inception guide — Abdilah](https://devabdilah.medium.com/inception-42-a-comprehensive-guide-to-dockerizing-your-first-infrastructure-part-iii-a10e93e9d922)
- [Containerisation documentation — Stéphane Robert](https://blog.stephane-robert.info/docs/conteneurisation/)
- [Docker secrets management — Semaphore](https://semaphore.io/blog/docker-secrets-management)

### AI usage
No IA was use during this project.