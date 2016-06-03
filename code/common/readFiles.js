var fs = require('fs')

//遍历文件夹，获取所有文件夹里面的文件信息
/*
 * @param path 路径
 *
 */
function getFileList(path, callback) {
    var filesList = [];
    readFile(path, filesList, callback);
    return filesList;
}

//遍历读取文件
function readFile(path, filesList, callback) {
    files = fs.readdirSync(path); //需要用到同步读取
    files.forEach(walk);

    function walk(file) {
        states = fs.statSync(path + '/' + file);
        if (states.isDirectory()) {
            readFile(path + '/' + file, filesList, callback);
        } else {
            //创建一个对象保存信息
            var obj = new Object();
            obj.size = states.size; //文件大小，以字节为单位
            obj.name = file; //文件名
            obj.path = path + '/' + file; //文件绝对路径
            filesList.push(obj);
            if (typeof callback === "function"){
              callback(obj);
            }
        }
    }
}

//写入文件utf-8格式
function writeFile(fileName, data) {
    fs.writeFile(fileName, data, 'utf-8', complete);

    function complete() {
        console.log("文件生成成功");
    }
}
exports.getFileList = getFileList;