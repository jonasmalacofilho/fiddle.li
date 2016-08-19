import Assertion.*;
import Data;
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
			show(req.method, req.url, req.headers["host"]);

			var prefix = (req.headers["host"]:String).split(".")[0];
			switch prefix {
			case "localhost"|"fiddle.li":
				res.write(Index.render(conf));
			case _:
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
		server.listen(port);
		trace('listening');
	}
}

