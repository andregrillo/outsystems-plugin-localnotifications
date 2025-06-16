var exec = require('cordova/exec');

exports.setLocalNotifications = function (success, error) {
    exec(success, error, 'LocalNotifications', 'setLocalNotifications');
};

exports.checkPermissions = function (success, error) {
    exec(success, error, 'LocalNotifications', 'checkPermissions');
};