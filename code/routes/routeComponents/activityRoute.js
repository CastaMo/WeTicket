'use strict';

var http = require('http');
var StringDecoder = require('string_decoder').StringDecoder;
var cookie = 'sid=tkbobycg4ycgq6kz7ir18eunzarrd5l6';
var flag = true;

module.exports = function(router) {
  router.get('/Manage/Market/Activity', function(req, res) {
    res.render('./CanteenManageMarket/Activity/develop');
  });

  router.get('/Manage/Market/Activity/Data', function(req, res) {
    var options = {
      hostname: 'devel.brae.co',
      path: req.url,
      method: 'GET',
      headers: {
        // "Content-Type": "application/json",
        'Cookie': cookie
      }
    };

    var request = http.request(options, function(remoteRes) {
      console.log('\nAt url:', req.url);
      console.log('Method:', options.method);
      console.log('Remote server:', options.hostname);
      console.log('Request remote server start');

      var decoder = new StringDecoder('utf8');

      remoteRes.on('data', function(chunk) {
        var textChunk = decoder.write(chunk);
        console.log('Remote server response:', textChunk);
        res.send(textChunk);
      });

      remoteRes.on('end', function() {
        console.log('Remote server end\n');
      });
    });
    // request.write(JSON.stringify(req.body));
    request.on('error', function(e) {console.log('Remote server error:', e);});
    request.end();
    // res.send("var allData = '"+'{"message":"success","data":[{"id":"214","title":"111\u6c34\u7535\u8d39","intro":"222","content":"333","pic":"mxr0pgguy4f1s5ugab9jp8yjkr9pm549","date_begin":"1464752750","date_end":"1464752760","type":"sales"},{"id":"215","title":"sdfsdf","intro":"sdf","content":"sdf","pic":"hua70hz6g5u9g26036eqtxslzms0vuac","date_begin":"0","date_end":"0","type":"sales"},{"id":"216","title":"\u6548\u7387\u592a\u4f4e\u4e86","intro":"\u4e0d\u80fd\u5fcd","content":"\u6211\u7684\u9519","pic":"okjo1ivioqr4sy5v5kmyhfjg1bhw6r9u","date_begin":"0","date_end":"0","type":"sales"},{"id":"217","title":"\u54c8\u54c8\u54c8","intro":"\u4fee\u6539","content":"\u4e0d\u80fd\u8fd9\u71d5\u5b50\u554a","pic":"vz07pohkrt80zcjhqnnbpehidcyicnq8","date_begin":"0","date_end":"0","type":"theme"}]}'+"';"+
    //   "if (typeof window.mainInit !== 'undefined') {mainInit(JSON.parse(allData));mainInit = null;allData = null;}");
  });

  router.post('/Activity/Add/:type', function(req, res) {
    var options = {
      hostname: 'devel.brae.co',
      path: req.url,
      method: 'POST',
      headers: {
        "Content-Type": "application/json",
        'Cookie': cookie
      }
    };

    var request = http.request(options, function(remoteRes) {
      console.log('\nAt url:', req.url);
      console.log('Method:', options.method);
      console.log('Remote server:', options.hostname);
      console.log('Request remote server start');

      var decoder = new StringDecoder('utf8');

      remoteRes.on('data', function(chunk) {
        var textChunk = decoder.write(chunk);
        console.log('Remote server response:', textChunk);
        res.send(textChunk);
      });

      remoteRes.on('end', function() {
        console.log('Remote server end\n');
      });
    });
    request.write(JSON.stringify(req.body));
    request.on('error', function(e) {console.log('Remote server error:', e);});
    request.end();
  });

  router.post('/pic/upload/token/activityadd', function(req, res) {
    var options = {
      hostname: 'devel.brae.co',
      path: req.url,
      method: 'POST',
      headers: {
        "Content-Type": "application/json",
        'Cookie': cookie
      }
    };

    var request = http.request(options, function(remoteRes) {
      console.log('\nAt url:', req.url);
      console.log('Method:', options.method);
      console.log('Remote server:', options.hostname);
      console.log('Request remote server start');

      var decoder = new StringDecoder('utf8');

      remoteRes.on('data', function(chunk) {
        var textChunk = decoder.write(chunk);
        console.log('Remote server response:', textChunk);
        res.send(textChunk);
      });

      remoteRes.on('end', function() {console.log('Remote server end\n');});
    });
    request.write(JSON.stringify(req.body));
    request.on('error', function(e) {console.log('Remote server error:', e);});
    request.end();
  });

  router.post('/pic/upload/token/activityupdate/:id', function(req, res) {
    var options = {
      hostname: 'devel.brae.co',
      path: req.url,
      method: 'POST',
      headers: {
        "Content-Type": "application/json",
        'Cookie': cookie
      }
    };

    var request = http.request(options, function(remoteRes) {
      console.log('\nAt url:', req.url);
      console.log('Method:', options.method);
      console.log('Remote server:', options.hostname);
      console.log('Request remote server start');

      var decoder = new StringDecoder('utf8');

      remoteRes.on('data', function(chunk) {
        var textChunk = decoder.write(chunk);
        console.log('Remote server response:', textChunk);
        res.send(textChunk);
      });

      remoteRes.on('end', function() {console.log('Remote server end\n');});
    });
    request.write(JSON.stringify(req.body));
    request.on('error', function(e) {console.log('Remote server error:', e);});
    request.end();
  });

  router.post('/Activity/Update/:activity_id', function(req, res) {
    var options = {
      hostname: 'devel.brae.co',
      path: req.url,
      method: 'POST',
      headers: {
        "Content-Type": "application/json",
        'Cookie': cookie
      }
    };

    var request = http.request(options, function(remoteRes) {
      console.log('\nAt url:', req.url);
      console.log('Method:', options.method);
      console.log('Remote server:', options.hostname);
      console.log('Request remote server start');

      var decoder = new StringDecoder('utf8');

      remoteRes.on('data', function(chunk) {
        var textChunk = decoder.write(chunk);
        console.log('Remote server response:', textChunk);
        res.send(textChunk);
      });

      remoteRes.on('end', function() {console.log('Remote server end\n');});
    });
    console.log(JSON.stringify(req.body));
    request.write(JSON.stringify(req.body));
    request.on('error', function(e) {console.log('Remote server error:', e);});
    request.end();
  });

  router.post('/Activity/Remove/:activityId', function(req, res) {
    var options = {
      hostname: 'devel.brae.co',
      path: req.url,
      method: 'POST',
      headers: {
        "Content-Type": "application/json",
        'Cookie': cookie
      }
    };

    var request = http.request(options, function(remoteRes) {
      console.log('\nAt url:', req.url);
      console.log('Method:', options.method);
      console.log('Remote server:', options.hostname);
      console.log('Request remote server start');

      var decoder = new StringDecoder('utf8');

      remoteRes.on('data', function(chunk) {
        var textChunk = decoder.write(chunk);
        console.log('Remote server response:', textChunk);
        res.send(textChunk);
      });

      remoteRes.on('end', function() {console.log('Remote server end\n');});
    });
    request.on('error', function(e) {console.log('Remote server error:', e);});
    request.end();
  });

  return router;
};
