import UIKit
import Flutter
import flutter_core_channel
class TestMessenger: NSObject, BaseMessengerHandler {

    func didReceivedFlutterSignal(params: FlutterMessengerMap?) -> FlutterMessengerMap? {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            ChannelManager.sharedInstance.send(self.methodName(), params: ["man": "哈哈 - iOS"]) { result in
                print("Flutter返回值 == (result)")
            }
        }
        return ["native": "uuuuuu"]
    }

    func methodName() -> String {
        return "sendMessageToNative"
    }

}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        ChannelManager.sharedInstance.addAllMessengers([TestMessenger()])
        return true
    }

}
