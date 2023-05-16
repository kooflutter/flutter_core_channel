import Foundation
import Flutter
@objc public class ChannelManager: NSObject {

    @objc public static let sharedInstance = ChannelManager()

    private var lock = NSLock()
    public var channel: FlutterMethodChannel?
    private var messengers = [String: BaseMessengerHandler]()

    private override init() {}

    func register(with registrar: FlutterPluginRegistrar) {
            channel = FlutterMethodChannel(name: "flutter_core_channel", binaryMessenger: registrar.messenger())
            channel?.setMethodCallHandler { [weak self] call, result in
                self?.handleFlutterMessage(call, result: result)
            }
    }

    @objc public func addAllMessengers(_ messengers: [BaseMessengerHandler]?) {
        if let messengers = messengers {
            safeExe {
                for messenger in messengers {
                    self.messengers[messenger.methodName()] = messenger
                }
            }
        }
    }

    @objc func addMessenger(_ messenger: BaseMessengerHandler?) {
        if let messenger = messenger {
            safeExe {
                self.messengers[messenger.methodName()] = messenger
            }
        }
    }

    @objc func removeMessenger(_ methodName: String?) {
        if let methodName = methodName {
            safeExe {
                self.messengers.removeValue(forKey: methodName)
            }
        }
    }

    @objc func removeAllMessengers() {
        safeExe {
            self.messengers.removeAll()
        }
    }

    public func send(_ methodName: String) {
        channel!.invokeMethod(methodName, arguments: encode(wrap(code: 0, data: nil, msg: "success")), result: nil)
    }

    @objc public func send(_ methodName: String, params: FlutterMessengerMap) {
        channel?.invokeMethod(methodName, arguments: encode(wrap(code: 0, data: params, msg: "success")), result: nil)
    }

    @objc public func send(_ methodName: String, params: FlutterMessengerMap, result: MessageResult) {
        channel!.invokeMethod(methodName, arguments: encode(wrap(code: 0, data: params, msg: "success")))
        //, result: result
    }

    private func handleFlutterMessage(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let messenger = messengers[call.method], let json = call.arguments as? String else {
            result(encode(wrap(code: -999, data: nil, msg: "failed")))
            return
        }

        var decode = decode(json) ?? [:]
        let ret = messenger.didReceivedFlutterSignal(params: decode)
        result(encode(wrap(code: 0, data: ret, msg: "success")))
    }

    private func decode(_ data: Any?) -> [String: Any]? {
        guard let data = data as? String, let jsonData = data.data(using: .utf8) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
    }

    private func encode(_ data: [String: Any]?) -> String? {
        guard let data = data else {
            return nil
        }
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed)
        return String(data: jsonData ?? Data(), encoding: .utf8)
    }

    func wrap(code: Int, data: [String: Any]? = nil, msg: String = "") -> [String: Any] {
        var ret = [String: Any]()
        ret["code"] = "\(code)"
        ret["data"] = data ?? [String: Any]()
        ret["msg"] = msg
        return ret
    }

    func safeExe(block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            lock.lock()
            block()
            lock.unlock()
        }
    }

}
