cordova.define("com-mikhailcreate-plugins-test.coolMethod", function(require, exports, module) {
var exec = require('cordova/exec');

exports.coolMethod = function(arg0, success, error) {
    exec(success, error, "coolMethod", "coolMethod", [arg0]);
};

});
