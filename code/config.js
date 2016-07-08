/**
 * 项目配置文件
 */

var path = require("path");

var config = {
    // debug 为 true 时，用于本地调试
    debug: true,
    
    host: "localhost",
    // mongodb配置
    db: "mongodb://127.0.0.1/weticket",
    
    session_secret: 'weticket', // 务必修改
    auth_cookie_name: 'weticket',

    port: 8888,

    // redis 配置，默认是本地
    redis_host: '127.0.0.1',
    redis_port: 6379,
    redis_db: 0,

}

if (process.env.NODE_ENV === 'test') {
  config.db = 'mongodb://127.0.0.1/weticket_test';
}

module.exports = config;