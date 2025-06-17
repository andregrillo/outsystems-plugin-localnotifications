var exec = require('cordova/exec');

exports.setLocalNotifications = function (title, subtitle, delayInSeconds, success, error) {
    exec(success, error, 'LocalNotifications', 'setLocalNotifications', [title, subtitle, delayInSeconds]);
};

exports.checkPermissions = function (success, error) {
    exec(success, error, 'LocalNotifications', 'checkPermissions');
};