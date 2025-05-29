import Foundation

@objc(LocalNotifications)
class LocalNotifications: CDVPlugin {
    @objc(coolMethod:)
    func coolMethod(command: CDVInvokedUrlCommand) {
         print("Cool method called")
    }
}
