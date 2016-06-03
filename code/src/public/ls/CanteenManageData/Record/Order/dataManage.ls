main = null
data-manage = let
    

    
    _init-depend-module = !->
        main 	:= require "./mainManage.js"
    
    initial: !->
        _init-depend-module!
        
        
module.exports = data-manage