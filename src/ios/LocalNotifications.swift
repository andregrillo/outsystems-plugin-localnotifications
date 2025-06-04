import Foundation

@objc(LocalNotifications)
class LocalNotifications: CDVPlugin {
    
    @objc(setLocalNotifications:)
    func setLocalNotifications(command: CDVInvokedUrlCommand) {
        print("Cool method called")
        
        sendPluginResult(status: .ok, message: "Everything went ok", callbackId: command.callbackId)
    }
    
    func sendPluginResult(status: CDVCommandStatus, message: String = "", callbackId: String, keepCallback: Bool = false) {
        let pluginResult = CDVPluginResult(status: status, messageAs: message)
        pluginResult?.setKeepCallbackAs(keepCallback)
        self.commandDelegate!.send(pluginResult, callbackId: callbackId)
    }
}
