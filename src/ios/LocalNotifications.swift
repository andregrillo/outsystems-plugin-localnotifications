import Foundation
import UserNotifications

@objc(LocalNotifications)
class LocalNotifications: CDVPlugin {
    
    @objc(setLocalNotifications:)
    func setLocalNotifications(command: CDVInvokedUrlCommand) {
        print("Cool method called")
        
        sendPluginResult(status: .ok, message: "All good", callbackId: command.callbackId)
    }
    
    @objc(checkPermissions:)
    func checkPermissions(command: CDVInvokedUrlCommand) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if error != nil {
                print(error!.localizedDescription)
                self.sendPluginResult(status: .error, message: error!.localizedDescription, callbackId: command.callbackId)
            } else {
                if success {
                    print("All set!")
                    self.sendPluginResult(status: .ok, message: "Permission IS allowed!", callbackId: command.callbackId)
                } else {
                    print("Permission not allowed!")
                    self.sendPluginResult(status: .ok, message: "Permission NOT allowed!", callbackId: command.callbackId)
                }
            }
        }
    }
    
    func sendPluginResult(status: CDVCommandStatus, message: String = "", callbackId: String, keepCallback: Bool = false) {
        let pluginResult = CDVPluginResult(status: status, messageAs: message)
        pluginResult?.setKeepCallbackAs(keepCallback)
        self.commandDelegate!.send(pluginResult, callbackId: callbackId)
    }
}
