import Assertion.*;
import Data;
import js.Node;
import js.node.*;
import js.node.http.*;

class Server {
	static function main()
	{
		var port = "80";
		var conf:Map<String,SupportedTarget> = [
			"haxe" => { protocol: "http://", host:"try.haxe.org", name:"Haxe", providerName:"Try Haxe" },
			"js" => { protocol: "https://", host:"jsfiddle.net", name:"JavaScript", providerName:"JSFiddle"  },
			"css" => { protocol: "https://", host:"jsfiddle.net", name:"CSS", providerName:"JSFiddle"  },
			"html" => { protocol: "https://", host:"jsfiddle.net", name:"HTML", providerName:"JSFiddle"  }
		];
		var fallback = { protocol: "http://", host:"fiddle.li" };
		show(port, conf, fallback);

		function handle(req:IncomingMessage, res:ServerResponse)
		{
			var host = req.headers["host"];
			show(req.method, req.url, host);

			switch host {
			case "localhost"|"fiddle.li":
				res.write(Index.render(conf));
			case _:
				var prefix = (req.headers["host"]:String).split(".")[0];
				var target:Target = switch conf[prefix] {
					case null: fallback;
					case some: some;
				}
				show(prefix, target);
				res.writeHead(302, { location:'${target.protocol}${target.host}${req.url}' });
			}
			res.end();
		}
		var server = Http.createServer(handle);

		function controledExit(signal:String)
		{
			show(signal);
			var code = 128 + switch (signal) {
				case "SIGINT": 2;
				case "SIGTERM": 15;
				case "SIGUSR2": 12;  // nodemon uses this to restart
				case _: 0;  // ?
			}
			trace('Trying a controled shutdown after signal $signal');
			server.on("close", function () {
				trace('Succeded in shutting down the HTTP server; exiting now with code $code');
				js.Node.process.exit(code);
			});
			server.close();  // FIXME not really waiting for all responses to finish
		}
		Node.process.on("SIGINT", controledExit.bind("SIGINT"));
		Node.process.on("SIGTERM", controledExit.bind("SIGTERM"));
		Node.process.on("SIGUSR2", controledExit.bind("SIGUSR2"));

		server.listen(port);
		trace('listening');
	}
}

