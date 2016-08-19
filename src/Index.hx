import Assertion.*;
import js.node.*;
import js.node.http.*;

class Index {
	static function main()
	{
		var port = "80";
		var conf = [
			"haxe" => { protocol: "http://", host:"try.haxe.org" },
			"js" => { protocol: "http://", host:"jsfiddle.net" },
			"css" => { protocol: "http://", host:"jsfiddle.net" },
			"html" => { protocol: "http://", host:"jsfiddle.net" }
		];
		var fallback = { protocol: "http://", host:"fiddle.li" };
		show(port, conf, fallback);

		function handle(req:IncomingMessage, res:ServerResponse)
		{
			show(req.method, req.url, req.headers["host"]);

			var prefix = (req.headers["host"]:String).split(".")[0];
			var target = switch conf[prefix] {
				case null: fallback;
				case some: some;
			}
			show(prefix, target);

			res.writeHead(302, { location:'${target.protocol}${target.host}${req.url}' });
			res.end();
		}

		var server = Http.createServer(handle);
		server.listen(port);
		trace('listening');
	}
}

