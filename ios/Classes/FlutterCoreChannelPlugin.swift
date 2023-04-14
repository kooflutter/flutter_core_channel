import Flutter
import UIKit

public class FlutterCoreChannelPlugin: NSObject, FlutterPlugin {
      static func register(with registrar: FlutterPluginRegistrar) {
          let channel = FlutterMethodChannel(name: "flutter_core_channel", binaryMessenger: registrar.messenger())
          let instance = KooChannelPlugin()
          registrar.addMethodCallDelegate(instance, channel: channel)
      }

      func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
          // Your implementation of method call handling goes here
      }
}
