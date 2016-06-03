var getConfigForGrunt 	= require("../common/getConfigForGrunt"),
		readFiles 				 	= require("../common/readFiles");

module.exports = function (componentPath) {
	var jade,
			less,
			livescript,
			browserify,
			watch,
			cssmin,
			uglify;

	jade = {
		options: {
      data: {
      	debug: false,
      },
      pretty: true
    }
	};

	less = {
		options: {
			compress: false,
      yuicompress: false
		}
	};

	livescript = {
		options: {
      bare: true,
      join: true,
      flatten: true
    }
	};

	browserify = {};

	watch = {};

	cssmin = {
		options: {
      keepSpecialComments: 0
    },
    compress: {
    	files: {
    		'<%= dirs.dest_path %><%= dirs.css %>common/extra.min.css': ['<%= dirs.dest_path %><%= dirs.css %>common/*.css']
    	}
    }
	};

	uglify = {
		options: {
			report: "min"
		},
		dist: {
			files: {
				'<%= dirs.dest_path %><%= dirs.js %>common/extra.min.js': ['<%= dirs.dest_path %><%= dirs.js %>common/*.js']
			}
		}
	}

	function getJadeConfigObject(jade, taskName) {
		var files = {};
		files[jade.developDestURL] 		= jade.developSourceURL;
		files[jade.formalDestURL] 		= jade.formalSourceURL;
		return {
			files: files
		};
	};

	function getLessConfigObject(less, taskName) {
		var files = {};
		files[less.mainDestURL] 			= less.mainSourceURL;
		files[less.base64DestURL] 		= less.base64SourceURL;
		return {
			files: files
		};
	};

	function getLSConfigObject(ls, taskName) {
		return {
			expand 			: 			true,
			cwd 				: 			ls.mainSourceURL,
			src 				: 			["**/*.ls"],
			dest 				: 			ls.mainDestURL,
			ext 				: 			".js"
		};
	};

	function getBrowserifyConfigObject(browserify, taskName) {
		var files = {};
		files[browserify.mainDestURL] = browserify.mainSourceURL;
		return {
			files: files
		};
	};

	function getWatchConfigObject(watch, taskName) {
		var options,
				files,
				tasks;
		options = {
			livereload 			: 			35729,
			debounceDelay 	: 			0
		};
		files = [watch.sourcePath];
		tasks = [
			"less:" 			+ taskName,
			"livescript:" + taskName,
			"browserify:" + taskName,
			"jade:" 			+ taskName
		];
		return {
			options 				: 			options,
			files 					: 			files,
			tasks 					: 			tasks
		};
	};

	function configForCSSMin(cssmin, taskName, cssminTask) {
		var files = cssminTask.compress.files;
		files[cssmin.mainDestURL] 		= cssmin.mainSourceURL;
		files[cssmin.base64DestURL] 	= cssmin.base64SourceURL;
	}

	function configForUglify(uglify, taskName, uglifyTask) {
		var files = uglifyTask.dist.files;
		files[uglify.mainDestURL] 		= uglify.mainSourceURL;
	}

	function configFromFile(file) {
		var temp,
				flag,
				task,
				files,
				taskName;
		temp 		= file.name.replace(".js", "").split("_");
		flag 		= temp.pop();
		flag 		= (Number(flag) === 1);
		config 	= getConfigForGrunt({
			array 		: 		temp,
			isDynamic : 		flag
		});

		taskName = config.taskName

		jade[taskName] 				= getJadeConfigObject(config.jade, taskName);

		less[taskName] 				= getLessConfigObject(config.less, taskName);

		livescript[taskName] 	= getLSConfigObject(config.ls, taskName);

		browserify[taskName] 	= getBrowserifyConfigObject(config.browserify, taskName);

		watch[taskName] 			= getWatchConfigObject(config.watch, taskName);

		configForCSSMin(config.cssmin, taskName, cssmin);

		configForUglify(config.uglify, taskName, uglify);

	};


	readFiles.getFileList(componentPath, configFromFile);
	return {
		jade 				: 			jade,
		less 				: 			less,
		livescript 	: 			livescript,
		browserify 	: 			browserify,
		watch 			: 			watch,
		cssmin 			: 			cssmin,
		uglify 			: 			uglify
	}
};