'use strict';

module.exports = function(router) {
  router.get('/Manage/Menu/Category', function(req, res) {
    res.render('./CanteenManageMenu/Category/develop');
  });

  router.post('/Category/Add', function(req, res) {
      res.json({
          message   :     "success"   ,
          id        :     Number(Math.floor(100000 + Math.random() * 100000))
      });
  });

  router.post('/Category/Remove', function(req, res) {
      res.json({
          message: "success"
      });
  });

  router.post('/Category/Update/Profile', function(req, res) {
      res.json({
          message: "success"
      });
  });

  router.post('/pic/upload/token/category/:id', function(req, res) {
      res.json({
          message   :     "success" ,
          key       :     100     ,
          token     :     "heihei"
      });
  });

  router.post('/Category/Update/Top/:id', function(req, res) {
      res.json({
          message:  "success"
      });
  });

  return router;
};
