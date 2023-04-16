import Foundation
import Flutter
public typealias FlutterMessengerMap = [String: Any]
public typealias  MessageResult = ((FlutterMessengerMap?) -> Void)
public protocol BaseMessengerHandler: NSObjectProtocol {
    func methodName() -> String
    func didReceivedFlutterSignal(params: FlutterMessengerMap?, action: String?) -> FlutterMessengerMap?
}