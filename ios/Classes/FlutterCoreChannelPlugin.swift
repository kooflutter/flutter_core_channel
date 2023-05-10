import Foundation
import Flutter
import UIKit
@objc public class FlutterCoreChannelPlugin: NSObject, FlutterPlugin {
      public static func register(with registrar: FlutterPluginRegistrar) {
              ChannelManager.sharedInstance.register(with: registrar)
          }
}