if [ "$SRC" = "" ]
then
	SRC=src
fi
set -xe

(cd "$SRC" && haxe build.hxml)
scp "$SRC"/index.js root@104.131.183.27:/var/www/
ssh root@fiddle.li "systemctl restart fiddle-li && systemctl status fiddle-li"

