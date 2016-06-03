var path = require('path');
var fs = require('fs');


module.exports = (function(json_path) {
    json_path = json_path || "./bin/public/version/hash.json"

    var reg_css_js = /\.(css|js)$/;

    // change these consts according to the app's running environment
    var STATIC_ROOT = '';
    var DEBUG = false;
    var EXTRA_PATH = 'public/version';

    var hash_cache;

    function static_url(p) {
        var results = "";
        data = fs.readFileSync(json_path, {encoding:'utf-8'});
        hash_cache = JSON.parse(data);
        if (p[0] == '/') {
            p = p.slice(1);
        }
        if (DEBUG || !reg_css_js.test(p)) {
            results = STATIC_ROOT + '/' + p
        } else {
            var hash = hash_cache[p];
            if (hash) {
                var ext = path.extname(p);
                p = path.join(path.dirname(p), path.basename(p, ext) + '_' + hash + ext);
            }
            results = STATIC_ROOT + '/' + EXTRA_PATH + '/' + p;
        }
        return results;
    }

    return {
    	static_url		: 		static_url
    };
})();