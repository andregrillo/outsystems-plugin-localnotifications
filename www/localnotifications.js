var exec = require('cordova/exec');

exports.setLocalNotifications = function (title, subtitle, success, error) {
    exec(success, error, 'LocalNotifications', 'setLocalNotifications', [title, subtitle]);
};

exports.checkPermissions = function (success, error) {
    exec(success, error, 'LocalNotifications', 'checkPermissions');
};