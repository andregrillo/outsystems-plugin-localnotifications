import Foundation
import UserNotifications

@objc(LocalNotifications)
class LocalNotifications: CDVPlugin {
    
    @objc(setLocalNotifications:)
    func setLocalNotifications(command: CDVInvokedUrlCommand) {
        
        if !command.arguments.isEmpty, let title = command.arguments[0] as? String, let subtitle = command.arguments[1] as? String, let delayInSeconds = command.arguments[2] as? Int {
            let content = UNMutableNotificationContent()
            content.title = title
            content.subtitle = subtitle
            content.sound = UNNotificationSound.default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delayInSeconds), repeats: false)

            // choose a random identifier
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            // add our notification request
            UNUserNotificationCenter.current().add(request)
            
            sendPluginResult(status: .ok, message: "Local Notification set", callbackId: command.callbackId)
        } else {
            self.sendPluginResult(status: .error, message: "Error: Missing arguments", callbackId: command.callbackId)
        }
        
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
