import Foundation
import Flutter
public typealias FlutterMessengerMap = [String: Any]
public typealias  MessageResult = ((FlutterMessengerMap?) -> Void)
@objc public protocol BaseMessengerHandler: NSObjectProtocol {
    func methodName() -> String
    func didReceivedFlutterSignal(params: FlutterMessengerMap?) -> FlutterMessengerMap?
}