var POP3Client = require("../main.js");
var     argv = require('optimist')
                .usage("Usage: $0 --host [host] --port [port] --username [username] --password [password] --debug [on/off] --networkdebug [on/off]")
                .demand(['username', 'password'])
                .argv;

var host = argv.host || "localhost";
var port = argv.port || 110;
var debug = argv.debug === "on" ? true : false;
var filename = argv.filename;
var username = argv.username;
var password = argv.password;
var totalmsgcount = 0;
var currentmsg = 0;

var client = new POP3Client(port, host, { debug: (argv.debug === "on" ? true: false) });

client.on("error", function(err) {
	console.log("Server error occurred, failed, " + err);
});

client.on("connect", function(status, rawdata) {

	if (status) {

		console.log("CONNECT success");
		client.login(username, password);

	} else {

		console.log("CONNECT failed because " + rawdata);
		return;

	}
});

client.on("invalid-state", function(cmd) {
	console.log("Invalid state, failed. You tried calling " + cmd);
});

client.on("locked", function(cmd) {
	console.log("Current command has not finished yet, failed. You tried calling " + cmd);
});

client.on("login", function(status, rawdata) {

	if (status) console.log("LOGIN success");
	else console.log("LOGIN failed because " + rawdata);
	client.quit();

});

client.on("quit", function(status, rawdata) {

	if (status === true) console.log("QUIT success");
	else console.log("QUIT failed because " + rawdata);

});
