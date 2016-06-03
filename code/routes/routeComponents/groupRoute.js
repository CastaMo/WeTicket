'use strict';

module.exports = function(router) {

  router.get('/Manage/Menu/Food/Property', function(req, res) {
    res.render('./CanteenManageMenu/Food/Property/develop');
  });

  router.post('/Dish/Group/Add', function(req, res) {
    res.json({
      message   :     "success",
      id        :     Number(Math.floor(100000 + Math.random() * 100000))
    });
  });

  router.post('/Dish/Group/Update/:propertyGroupId', function(req, res) {
    res.json({
      message   :     "success"
    });
  });

  router.post('/Dish/Group/Remove/:propertyGroupId', function(req, res) {
    res.json({
      message   :     "success"
    });
  });

  return router;
};
