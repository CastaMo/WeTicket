'use strict';

module.exports = function(router) {

  router.get('/Manage/Menu/Food/Single', function(req, res) {
    res.render('./CanteenManageMenu/Food/Single/develop');
  });

  router.post('/Dish/Add/:categoryId', function(req, res) {
    res.json({
          message   :     "success" ,
          id        :     Number(Math.floor(100000 + Math.random() * 100000))
      });
  });

  router.post('/Dish/Remove', function(req, res) {
    res.json({
          message   :     "success"
      });
  });

  router.post('/Dish/Copy', function(req, res) {
    var _getNewDishIdMap = function(currentDishId) {
      var newDishIdMap = {};
      for (var id in currentDishId) {
        if (currentDishId.hasOwnProperty(id)) {
          newDishIdMap[id] = Number(Math.floor(100000 + Math.random() * 100000));
        }
      }
      return newDishIdMap;
    }
    var newDishIdMap = _getNewDishIdMap(req.body);
    res.json({
      message   :     "success",
      result    :     newDishIdMap
    });
  });

  router.post('/Dish/Update/Top', function(req, res) {
    res.json({
      message   :     "success"
    });
  });

  router.post('/Dish/Update/Category', function(req, res) {
    res.json({
      message   :     "success"
    });
  });

  router.post('/Dish/Update/All/:dishId', function(req, res) {
    res.json({
      message   :     "success"
    });
  });

  router.post('/Dish/Update/Able/:flag', function(req, res) {
    res.json({
      message   :     "success"
    });
  });

  router.post('/pic/upload/token/dishupdate/:dishId', function(req, res) {
    res.json({
          message   :     "success" ,
          key       :     100     ,
          token     :     "heihei"
      });
  });

  return router;
};
