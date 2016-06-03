var path = require('path');
var hashmap = require('./hashmap');
var fs = require("fs");


module.exports = (function() {
    var _allURL = {
        mainjsURL: "public/js/main.js",
        utiljsURL: "public/js/common/util.js",
        maincssURL: "public/css/main.css",
        min_mainjsURL: "public/js/main.min.js",
        min_extrajsURL: "public/js/common/extra.min.js",
        min_maincssURL: "public/css/main.min.css",
        base64_maincssURL: "public/css/base64.min.css"
    };

    var _getAllVersionUrl = function() {
        var results_ = {};
        for (var key in _allURL) {
            var url = _allURL[key];
            results_[key] = hashmap.static_url(url);
        }
        return results_
    };

    var _writeVersionToSourceFolderAndRender = function(res, callback) {
        var _allWriteCount = 2,
            _count = 0;
        var allURL = _getAllVersionUrl();

        var _getFormalCSSString = function() {
            var str = "link(rel='stylesheet' type='text/css' href=\'" + allURL["min_maincssURL"] + "\')\n";
            return str;
        }

        var _getFormalJSString = function() {
            var str = "script(src=\'" + allURL["min_extrajsURL"] + "\', type='text/javascript')\n";
            str += "script(src=\'" + allURL["min_mainjsURL"] + "\', type='text/javascript')\n";
            str += "link(rel='stylesheet' type='text/css' href=\'" + allURL["base64_maincssURL"] + "\')\n";
            return str;
        }

        var _checkIfAllWriteFinish = function() {
            _count++;
            if (_count === _allWriteCount) {
                if (typeof callback === "function") {
                    callback(res);
                }
                res.send(allURL);
            }
        }

        fs.writeFile("./src/jade/formalCSS.jade", _getFormalCSSString(), function(error) {
            _checkIfAllWriteFinish();
            if (error) {
                console.log("common css jade write fail");
            }
        });

        fs.writeFile("./src/jade/formalScript.jade", _getFormalJSString(), function(error) {
            _checkIfAllWriteFinish();
            if (error) {
                console.log("common css jade write fail");
            }
        });
    };
    return {
        renew       :       _writeVersionToSourceFolderAndRender
    };
})();