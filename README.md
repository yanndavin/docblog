# Introduction

Docblog is a simple project to setup three micro-services to run self-hosted blogging platform.

**Microservices**:
 - A git server (gogs)
 - A blog builder with a webhook which listen for git push and rebuild the blog with jekyll
 - A nginx web server to expose the git-server admin interface and serve the blog static pages



```
 +--Overview-------------------------------------------------------------+
 |                                                                       |
 |                                                                       |
 |               +-------+        +------+        +---------+            |
 |               | nginx |        | gogs |        |  jekyll |            |
 |               +-------+        +------+        +---------+            |
 |                  |                |                 |                 |
 |   git push-----> |                |                 |                 |
 |                  +--------------> |  webhook        |                 |
 |                  |                +---------------> |                 |
 |                  |                |                 +---+             |
 |                  |                |                 |   | build blog  |
 |                  |                |                 | <-+             |
 |                  |                |                 |                 |
 |                  |                |                 |                 |
 |                                                                       |
 |                                                                       |
 +-----------------------------------------------------------------------+
```

# Requierements
- docker
- docker-compose
- build-essential

- Https certificates generation
```
make create-certificates
```

renew 
```
renew certificates
```

# Installation

1. create a `.secret` file with the following content
    ```bash
    GIT_SERVER_ADMIN_USER=<USER>
    GIT_SERVER_ADMIN_PASSWORD=<PASS>
    GIT_SERVER_ADMIN_EMAIL=<EMAIL>
    GIT_SECURITY_KEY=<KEY>
    BLOG_BUILDER_GIT_URL=https://admin_user:admin_pass@git-server:3000/admin_user/you_repo.git
    ```

2. build docker images
    ```bash
    make build
    ```

3. run the system
    ```bash
    docker-compose up
    ```

4. create your repository
    Go to ```https://<WEB_SERVER_NGNIX_SERVER_NAME>/gogs``` login with previous `admin_user` and `admin_pass`.
    Create a repository with same name than the `BLOG_BUILDER_GIT_URL` variable value, `your_repo` for instance.
    

5. add git hook
    Go to your blog repository settings then create a `Webhooks` on `Push` events with the 
    `http://blog-builder:9000/hooks/rebuild-webhook` as payload URL.
    
