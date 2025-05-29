var exec = require('cordova/exec');

//exports.coolMethod = function (arg0, success, error) {
exports.coolMethod = function (success, error) {
    //exec(success, error, 'LocalNotification', 'coolMethod', [arg0]);
    exec(success, error, 'LocalNotifications', 'coolMethod');
};
