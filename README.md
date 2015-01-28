#docker-ghost
Following official ghost Docker image, added version in Dockerfile for tagged builds

- [Quickstart using `docker run`](#quickstart)
- [Setup with `docker-compose`](#using-docker-compose)

##Quickstart 

Using docker run with internal SQLite database.
I'm running this on CoreOS and chown to the core user (userid 500)


`docker run` on CoreOS (with ghost UID = core uid) looks like this:
```shell
docker run -d --name ghost \
    -p 80:2368 
    -e 'USER_UID=500' -e 'USER_GID=500' -e 'GHOST_URL=http://10.40.0.5/' 
    -v /path/to/blog/data/data:/ghost-override 
    so0k/ghost:0.5.8
```

`/path/to/blog/data/config.js`:
```javascript
// # Ghost Configuration
var path = require('path'),
    config;

config = {
    // ### Production
    // When running Ghost in the wild, use the production environment
    // Configure your URL and mail settings here
    production: {
        url: process.env.GHOST_URL,
        mail: {},
        database: {
            client: 'sqlite3',
            connection: {
                filename: path.join(__dirname, '/content/data/ghost.db')
            },
            debug: false
        },
        server: {
            // Host to be passed to node's `net.Server#listen()`
            host: '0.0.0.0',
            // Port to be passed to node's `net.Server#listen()`, for iisnode set this to `process.env.PORT`
            port: '2368'
        }
    }
};

// Export config
module.exports = config;
```
config.js References:
- https://github.com/TryGhost/Ghost/blob/master/config.example.js
- https://github.com/orchardup/docker-ghost/blob/master/config.js
- https://github.com/discordianfish/docker-ghost/blob/master/config.js

##Using docker-compose
Setting up docker-compose yml files to use a shared postgres container

docker-compose directory structure
```
/var/project/compose/
├── blog
│   └── docker-compose.yml
├── ..
│   └── docker-compose.yml
├── shared
    └── docker-compose.yml
```
`/var/project/compose/shared/docker-compose.yml`:
```yml
db:
    image: postgres:9.3
    volumes:
     - /var/project/data/db:/var/lib/postgresql/data/
```

`/var/project/compose/blog/docker-compose.yml`:
```yml
ghost:
    image: "so0k/docker-ghost:0.5.8"
    environment:
     - DB_CLIENT=pg
     - DB_CONNECTION_STRING=postgres://username:password@db_host/database
     - USER_UID=500
     - USER_GID=500
     - GHOST_URL=http://blog.project.com
    ports:
     - "11080:2368"
    volumes:
     - /var/project/blog/data:/ghost-override
    external_links:
     - shared_db_1:db_host
```

`/var/project/blog/data/config.js`:
```
// # Ghost Configuration 0.5.8
var path = require('path'),
    config;

config = {
    // ### Production
    // When running Ghost in the wild, use the production environment
    // Configure your URL and mail settings here
    production: {
        url: process.env.GHOST_URL,
        mail: {},
        database: {
            client: process.env.DB_CLIENT,
            connection: process.env.DB_CONNECTION_STRING,
            debug: false
        },
        server: {
            // Host to be passed to node's `net.Server#listen()`
            host: '0.0.0.0',
            // Port to be passed to node's `net.Server#listen()`, for iisnode set this to `process.env.PORT`
            port: '2368'
        }
    }
};

// Export config
module.exports = config;
```
