## Project description

In this project, I set up a complete infrastructure using Docker Compose, creating and managing multiple containerized services including NGINX with SSL/TLS, WordPress with php-fpm, and MariaDB. I learned about containerization, networking, volume management, and secure web service deployment within my own personal virtual machine.

**This project allowed me to greatly improve the following skills:**
- Functional Documentation
- Container Networking
- Data Persistence Strategies
- Web Stack Deployment
- Containerization
- Web Server Configuration
- Secrets Management
- Container Orchestration

## What is Docker ?

#### Why use Docker ?
Developers may face a major problem: creating a brilliant programme on their computer, only to realize that it only works on their own computer. To use it elsewhere, they will need to install the necessary dependencies. It’s possible to provide a great script that will install these dependencies, but you can’t assume that the user is on a Mac or Linux, or that they’re running a version of the OS so old that it doesn’t even recognize your dependencies.

In response to this major problem, Solomon Hykes launched Docker on 20 March 2013. Docker is a tool that can package an application and its dependencies into an isolated container. Docker was developed for an internal project at dotCloud, a French company. It has been distributed as an open-source project since March 2013 and is currently the most widely used containerization engine.

Docker is a **tool** designed to allow you to build, deploy and run applications in an isolated and consistent manner across different machines and operating systems. This process is done using CONTAINERS. which are lightweight virtualized environments that package all the dependencies and code an application needs to run into a single text file, which can run the same way on any machine. While Docker is primarily used to package and run applications in containers, it is not limited to that use case. Docker can also be used to create and run other types of containers, such as ones for testing, development, or experimentation.

The main advantage of Docker is therefore the ability to model each container as an image that can be stored locally. A container is like a virtual machine but without a kernel (the entire system that enables the virtual machine to run, including the OS, graphics, networking, etc.). In other words, a container contains only the application and its dependencies. 

#### Docker vs Virtual Machine
Docker containers and Virtual machines have similar resource isolation and allocation benefits but function differently because containers virtualise the operating system instead of the hardware. Containers are more portable and efficient.

- **Containers** are a simulation at the app layer that packages code and dependencies together. Multiple containers can run on the same machine and share the OS kernel with other containers, each running as isolated processes in user space. Containers take up less space than VMs (talking about tens of MBs in size), can handle more applications, and require fewer VMs and Operating Systems.
- **Virtual Machines (VMs)** are a simulation of physical hardware turning one server into many servers. The hypervisor allows multiple VMs to run on a single machine. Each machine includes a full copy of an operating system, the application, necessary binaries, and libraries. VMs take more space compared to containers (talking about tens of GBs in size), and they can be slow to boot.

<p align="center">
<img src="https://www.techtarget.com/rms/onlineimages/containers_vs_virtual_machines-f.png"  width="865px"/>
</p>

#### Docker image:
Docker Image is a lightweight executable package that includes everything the application needs to run, including the code, runtime environment, system tools, libraries, and dependencies. Although this does not guarantee error-free operation – as an application’s behavior ultimately depends on many factors that go beyond the image itself – using Docker can reduce the risk of unexpected errors. 

Docker Image is built from a dockerfile, which is a simple text file that contains a set of instructions for building the image, with each instruction creating a new layer in the image.


#### Dockerfile:
Dockerfile is a simple text file that contains a set of instructions for building a Docker Image. It specifies the base image to use and then includes a series of commands that automate the process for configuring and building the image, such as installing packages, copying files, and setting environment variables. Each command in the Dockerfile creates a new layer in the image.

## Sources included and design choices

## Virtual Machines vs Docker

## Secrets vs Environment Variables

## Docker Network vs Host Network

## Docker Volumes vs Bind Mounts

## Instructions

## Resources