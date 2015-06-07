var argscheck = require('cordova/argscheck'),
    channel = require('cordova/channel'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec'),
    cordova = require('cordova');

channel.createSticky('onCordovaInfoReady');
// Tell cordova channel to wait on the CordovaInfoReady event
channel.waitForInitialization('onCordovaInfoReady');

/**
 * This represents the mobile device, and provides properties for inspecting the model, version, UUID of the
 * phone, etc.
 * @constructor
 */
function Device() {
    this.available = false;
    this.platform = null;
    this.version = null;
    this.uuid = null;
    this.cordova = null;
    this.model = null;
    this.manufacturer = null;

    var me = this;

    channel.onCordovaReady.subscribe(function() {
        me.getInfo(function(info) {
            //ignoring info.cordova returning from native, we should use value from cordova.version defined in cordova.js
            //TODO: CB-5105 native implementations should not return info.cordova
            var buildLabel = cordova.version;
            me.available = true;
            me.platform = info.platform;
            me.version = info.version;
            me.uuid = info.uuid;
            me.cordova = buildLabel;
            me.model = info.model;
            me.manufacturer = info.manufacturer || 'unknown';
            channel.onCordovaInfoReady.fire();
        },function(e) {
            me.available = false;
            utils.alert("[ERROR] Error initializing Cordova: " + e);
        });
    });
}

/**
 * Initialize ZOOM service
 *
 * @param {Function} appKey As provided by ZOOM service
 * @param {Function} appSecret As provided by ZOOM service
 * @param {Function} sdkDomain Which will be used to host the meetings
 * @param {Function} successCallback The function to call when the heading data is available
 * @param {Function} errorCallback The function to call when there is an error getting the heading data. (OPTIONAL)
 */
Zoom.prototype.initService = function(appKey, appSecret, sdkDomain, successCallback, errorCallback) {
    exec(successCallback, errorCallback, "Zoom", "initService", [appKey, appSecret, sdkDomain]);
};

/**
 * Initialize ZOOM service
 *
 * @param {Function} userName Display name
 * @param {Function} meetingNumber Meeting idetifier to be joint
 * @param {Function} successCallback The function to call when the heading data is available
 * @param {Function} errorCallback The function to call when there is an error getting the heading data. (OPTIONAL)
 */
Zoom.prototype.joinMeeting = function(userName, meetingNumber, successCallback, errorCallback) {
    exec(successCallback, errorCallback, "Zoom", "joinMeeting", [userName, meetingNumber]);
};

/**
 * Initialize ZOOM service
 *
 * @param {Function} userID The user idetifier
 * @param {Function} userName Display name
 * @param {Function} userToken Authentication token
 * @param {Function} successCallback The function to call when the heading data is available
 * @param {Function} errorCallback The function to call when there is an error getting the heading data. (OPTIONAL)
 */
Zoom.prototype.createInstantMeeting = function(userID, userName, userToken, successCallback, errorCallback) {
    exec(successCallback, errorCallback, "Zoom", "createInstantMeeting", [userID, userName, userToken]);
};

module.exports = new Zoom();
