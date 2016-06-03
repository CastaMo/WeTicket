var DEST_ROOT_PATH 			= "<%= dirs.dest_path %>",
		SOURCE_ROOT_PATH 		= "<%= dirs.source_path %>",
		JADE_PATH 					= "<%= dirs.jade %>",
		STATIC_SUFFIX 			= ".html",
		STATIC_ROOT 				= "module_static",
		DYNAMIC_SUFFIX 			= ".php",
		DYNAMIC_ROOT 				= "module_dynamic",
		CSS_PATH 						= "<%= dirs.css %>",
		LESS_PATH 					= "<%= dirs.less %>",
		JS_PATH 						= "<%= dirs.js %>",
		LS_PATH 						= "<%= dirs.ls %>",
		PROJECT_NAME 				= "CanteenManage";

var quickMap 						= {
		"jade" 			: 			JADE_PATH,
		"css" 			: 			CSS_PATH,
		"less" 			: 			LESS_PATH,
		"js" 				: 			JS_PATH,
		"ls" 				: 			LS_PATH
}


module.exports = function (options) {

	/*
	 * 	@param options 配置对象, 应包含array和isDynamic这两项
	 */

	

	function getAllFirstUpperStrArray(array) {
		function getFirstUpperStr(str) {
			return str.replace(/(^|\s+)\w/g,function(s){
				return s.toUpperCase();
			});
		}
		return array.map(function(item, index, array) {
			return getFirstUpperStr(item);
		});
	}

	function getViewsOptions(array, isDynamic, commonBackPath) {
		var rootForFormalDest,
				suffixForFormalDest;
		if (isDynamic) {
			rootForFormalDest 		= DYNAMIC_ROOT;
			suffixForFormalDest 	= DYNAMIC_SUFFIX; 
		} else {
			rootForFormalDest 		= STATIC_ROOT;
			suffixForFormalDest 	= STATIC_SUFFIX;
		}
		return {
			developSourceURL 			: 		SOURCE_ROOT_PATH + quickMap["jade"] + commonBackPath + "/develop.jade",
			developDestURL 				: 		DEST_ROOT_PATH + commonBackPath + "/" + array[array.length-1] + ".html",
			formalSourceURL 			: 		SOURCE_ROOT_PATH + quickMap["jade"] + commonBackPath + "/formal.jade",
			formalDestURL 				: 		DEST_ROOT_PATH + rootForFormalDest + "/" + array.join("/") + suffixForFormalDest,
		}
	}

	function getCSSOptions(array, isDynamic, commonBackPath) {
		return {
			mainSourceURL 				: 		SOURCE_ROOT_PATH + quickMap["less"] + commonBackPath + "/main.less",
			mainDestURL 					: 		DEST_ROOT_PATH + quickMap["css"] + commonBackPath + "/main.css",
			base64SourceURL 			: 		SOURCE_ROOT_PATH + quickMap["less"] + commonBackPath + "/base64.less",
			base64DestURL 				: 		DEST_ROOT_PATH + quickMap["css"] + commonBackPath + "/base64.css"
		};
	}

	function getJSOptions(array, isDynamic, commonBackPath) {
		return {
			mainSourceURL 				: 		SOURCE_ROOT_PATH + quickMap["ls"] + commonBackPath,
			mainDestURL 					: 		DEST_ROOT_PATH + quickMap["js"] + commonBackPath
		};
	}

	function getBrowserifyOptions(array, isDynamic, commonBackPath) {
		return {
			mainSourceURL 				: 		[DEST_ROOT_PATH + quickMap["js"] + commonBackPath + "/index.js"],
			mainDestURL 					: 		DEST_ROOT_PATH + quickMap["js"] + commonBackPath + "/main.js"
		};
	}

	function getWatchOptions(array, isDynamic, commonBackPath) {
		return {
			sourcePath 						: 		SOURCE_ROOT_PATH + "**/" + commonBackPath + "**/**"
		};
	}

	function getUglifyOptions(array, isDynamic, commonBackPath) {
		return {
			mainSourceURL 				: 		[DEST_ROOT_PATH + quickMap["js"] + commonBackPath + "/main.js"],
			mainDestURL 					: 		DEST_ROOT_PATH + quickMap["js"] + commonBackPath + "/main.min.js"
		}
	}

	function getCSSMinOptions(array, isDynamic, commonBackPath) {
		return {
			mainSourceURL 				: 		[DEST_ROOT_PATH + quickMap["css"] + commonBackPath + "/main.css"],
			mainDestURL 					: 		DEST_ROOT_PATH + quickMap["css"] + commonBackPath + "/main.min.css",
			base64SourceURL 			: 		[DEST_ROOT_PATH + quickMap["css"] + commonBackPath + "/base64.css"],
			base64DestURL 				: 		DEST_ROOT_PATH + quickMap["css"] + commonBackPath + "/base64.min.css"
		};
	}

	//取出参数
	var moduleNameArray = options.array,
			isDynamic 			= options.isDynamic;


	var taskName 								= moduleNameArray.join("_"),
			allFirstUpperStrArray 	= getAllFirstUpperStrArray(moduleNameArray);
			commonBackPath 					= PROJECT_NAME + allFirstUpperStrArray.join("/");

	var viewOptions 	= getViewsOptions(allFirstUpperStrArray, isDynamic, commonBackPath);
			CSSOptions 		= getCSSOptions(allFirstUpperStrArray, isDynamic, commonBackPath);
			JSOptions 		= getJSOptions(allFirstUpperStrArray, isDynamic, commonBackPath);
			browOptions 	= getBrowserifyOptions(allFirstUpperStrArray, isDynamic, commonBackPath);
			watchOptions 	= getWatchOptions(allFirstUpperStrArray, isDynamic, commonBackPath);
			uglifyOptions = getUglifyOptions(allFirstUpperStrArray, isDynamic, commonBackPath);
			CSSMinOptions = getCSSMinOptions(allFirstUpperStrArray, isDynamic, commonBackPath);

	// console.log(taskName);
	// console.log(allFirstUpperStrArray);
	// console.log(commonBackPath);
	// console.log(viewOptions);
	// console.log("\n\n\n\n");
	// console.log(CSSOptions);
	// console.log("\n\n\n\n");
	// console.log(JSOptions);
	// console.log("\n\n\n\n");
	// console.log(browOptions);
	// console.log("\n\n\n\n");
	// console.log(watchOptions);
	// console.log("\n\n\n\n");
	// console.log(uglifyOptions);
	// console.log("\n\n\n\n");
	// console.log(CSSMinOptions);
	return {
		taskName 			: 		taskName,
		jade 					: 		viewOptions,
		less 					: 		CSSOptions,
		ls 						: 		JSOptions,
		browserify 		: 		browOptions,
		watch 				: 		watchOptions,
		uglify 				: 		uglifyOptions,
		cssmin 				: 		CSSMinOptions
	}
}

module.exports({
	array 			: 	["menu","food","single"],
	isDynamic 	: 	false
});