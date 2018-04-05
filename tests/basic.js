var POP3Client = require("../main.js");
var     argv = require('optimist')
                .usage("Usage: $0 --host [host] --port [port] --username [username] --password [password] --debug [on/off] --networkdebug [on/off] --download [on/off] --dele [on/off] --rset [on/off]")
                .demand(['username', 'password'])
                .argv;

var host = argv.host || "localhost";
var port = argv.port || 110;
var debug = argv.debug === "on" ? true : false;
var dele = argv.dele === "on" ? true : false;
var rset = argv.rset === "on" ? true : false;
var download = argv.download === "on" ? true : false;

var username = argv.username;
var password = argv.password;
var totalmsgcount = 0;
var currentmsg = 0;

var client = new POP3Client(port, host, {

		debug: (argv.networkdebug === "on" ? true: false)

	});


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

client.on("login", function(status, data, rawdata) {

	if (status) {

		console.log("LOGIN/PASS success");
		if (download || dele) client.list();
		else client.capa();

	} else {

		console.log("LOGIN/PASS failed because " + rawdata);
		client.quit();

	}

});

client.on("capa", function(status, data, rawdata) {

	if (download) client.list();
	else client.quit();

});

client.on("rset", function(status,rawdata) {

	if (status) {

		console.log("RSET success");
		rset=false;
		currentmsg=1;
		client.retr(1);

	} else {

		console.log("RSET failed because " + rawdata);
		client.quit();

	}
});

client.on("list", function(status, msgcount, msgnumber, data, rawdata) {

	if (status === false) {

		console.log("LIST failed");
		client.quit();

	} else if (msgcount > 0) {

		totalmsgcount = msgcount;
		currentmsg = 1;
		console.log("LIST success with " + msgcount + " message(s)");

		if (download) client.retr(1);
		else if (dele) client.dele(1);
		else client.quit();

	} else {

		console.log("LIST success with 0 message(s)");
		client.quit();

	}
});

client.on("retr", function(status, msgnumber, data, rawdata) {

	if (status === true) {

		console.log("RETR success " + msgnumber + " with data " + data);
		if (dele) client.dele(msgnumber);
		else {

			if (currentmsg < totalmsgcount) {

				currentmsg += 1;
				client.retr(currentmsg);

			} else client.quit();
		}

	} else {

		console.log("RETR failed for msgnumber " + msgnumber + " because " + rawdata);
		client.quit();

	}
});

client.on("dele", function(status, msgnumber, data, rawdata) {

	if (status === true) {

		console.log("DELE success for msgnumber " + msgnumber);

		if (currentmsg < totalmsgcount) {

			currentmsg += 1;
			if (!rset && download) client.retr(currentmsg);
			else client.dele(currentmsg);

		} else if (rset) client.rset()
		else  client.quit();

	} else {

		console.log("DELE failed for msgnumber " + msgnumber);
		client.quit();

	}
});

client.on("quit", function(status, rawdata) {

	if (status === true) console.log("QUIT success");
	else console.log("QUIT failed");

});
