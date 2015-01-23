docker-ghost
============

follow official ghost Docker image, added version for tagged builds

I'm running this on CoreOS and chown to the core user (userid 500)

my docker run on CoreOS (with ghost UID = core uid) looks like this:
```
docker run -d --name ghost \
    -p 80:2368 
    -e 'USER_UID=500' -e 'USER_GID=500' -e 'GHOST_URL=http://10.40.0.5/' 
    -v /var/golfconnect/blog/data:/ghost-override 
    so0k/ghost:0.5.8-2`
```

my ```/path/to/blog/data/config.js``` like this:
```
// # Ghost Configuration
// Setup your Ghost install for various environments
// refer to https://github.com/TryGhost/Ghost/blob/master/config.example.js
//      and https://github.com/orchardup/docker-ghost/blob/master/config.js
//      and https://github.com/discordianfish/docker-ghost/blob/master/config.js

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
