var ghost = require('ghost'),
    path  = require('path');

ghost({
    config: path.join(__dirname, 'config.js')
}).then(function (ghostServer) {
    ghostServer.start();
});
