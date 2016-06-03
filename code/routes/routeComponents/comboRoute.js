'use strict';

var http = require('http');
var StringDecoder = require('string_decoder').StringDecoder;
var cookie = 'sid=tkbobycg4ycgq6kz7ir18eunzarrd5l6';
var flag = true;

module.exports = function(router) {
  router.get('/Manage/Menu/Combo/Sinlge', function(req, res) {
    res.render('./CanteenManageMenu/Combo/Single/develop');
  });

  function getOptionsForProxySendRequestConfig(url, method) {
    method = method.toUpperCase();
    var options = {
      hostname: 'devel.brae.co',
      path: url,
      headers: {
        'Cookie': cookie
      }
    };
    options.method = method;
    if (method === "POST") {
      options.headers["Content-Type"] = "application/json";
    }
    return options;
  };

  function getCallbackProxyHandleResponse(res) {
    return function(remoteRes) {
      var decoder = new StringDecoder('utf8');

      remoteRes.on('data', function(chunk) {
        var textChunk = decoder.write(chunk);
        console.log('Remote server response:', textChunk);
        res.send(textChunk);
      });

      remoteRes.on('end', function() {
        console.log('Remote server end\n');
      });
    }
  }

  function proxySendRequest(options, callbackProxyHandleResponse) {
    var request = http.request(options, callbackProxyHandleResponse);
    request.on('error', function(e) {console.log('Remote server error:', e);});
    request.end();
  }

  function getCallbackHandleForRequest(method) {
    return function(req, res) {
      var options = getOptionsForProxySendRequestConfig(req.url, method),
          callback = getCallbackProxyHandleResponse(res);
      console.log('\nAt url:', req.url);
      console.log('Method:', options.method);
      console.log('Remote server:', options.hostname);
      console.log('Request remote server start');
      proxySendRequest(options, callback);
    }
  }

  //router.get('/Manage/Menu/Data', getCallbackHandleForRequest("GET"));

  return router;
};
