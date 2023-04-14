import Foundation

typealias FlutterMessengerMap = [String: Any]
typealias MessageResult = ((FlutterMessengerMap?) -> Void)

protocol BaseMessengerHandler: NSObjectProtocol {
    func methodName() -> String
    func didReceivedFlutterSignal(params: KooMessengerMap?, action: String) -> KooMessengerMap?
}