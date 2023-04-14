import Foundation
import Flutter

class ChannelManager {

    static let sharedInstance = ChannelManager()

    private var lock = NSLock()
    private var channel: FlutterMethodChannel?
    private var messengers = [String: BaseMessengerHandler]()

    private init() {}

    func register(with registrar: FlutterPluginRegistrar) {
        if channel == nil {
            channel = FlutterMethodChannel(name: "flutter_core_channel", binaryMessenger: registrar.messenger())
            channel?.setMethodCallHandler { [weak self] call, result in
                self?.handleFlutterMessage(call, result: result)
            }
        }
    }

    func addAllMessengers(_ messengers: [BaseMessengerHandler]?) {
        if let messengers = messengers {
            safeExe {
                for messenger in messengers {
                    self.messengers[messenger.methodName] = messenger
                }
            }
        }
    }

    func addMessenger(_ messenger: BaseMessengerHandler?) {
        if let messenger = messenger {
            safeExe {
                self.messengers[messenger.methodName] = messenger
            }
        }
    }

    func removeMessenger(_ route: String?) {
        if let route = route {
            safeExe {
                self.messengers.removeValue(forKey: route)
            }
        }
    }

    func removeAllMessengers() {
        safeExe {
            self.messengers.removeAll()
        }
    }

    func send(_ route: String?, action: String?, result: MessageResult? = nil) {
        guard let route = route, let action = action else {
            return
        }
        channel?.invokeMethod(route, arguments: encode(wrap(0, data: nil, msg: "success", action: action)), result: result)
    }

    func send(_ route: String?, action: String?, params: KooMessengerMap?, result: MessageResult? = nil) {
        guard let route = route, let action = action, let params = params else {
            return
        }
        channel?.invokeMethod(route, arguments: encode(wrap(0, data: params, msg: "success", action: action)), result: result)
    }

    private func handleFlutterMessage(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let messenger = messengers[call.method], let json = call.arguments as? String else {
            result(encode(wrap(-999, data: nil, msg: "failed", action: nil)))
            return
        }

        var decode = decode(json) ?? [:]
        let action = decode["action"] as? String
        decode.removeValue(forKey: "action")
        let ret = messenger.didReceivedFlutterSignal(decode, action: action)
        result(encode(wrap(0, data: ret, msg: "success", action: nil)))
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

    func wrap(code: Int, data: [String: Any]? = nil, msg: String = "", action: String? = nil) -> [String: Any] {
        var ret = [String: Any]()
        ret["code"] = "\(code)"
        ret["data"] = data ?? [String: Any]()
        ret["msg"] = msg
        if let action = action {
            ret["action"] = action
        }
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

    var messengers: [String: BaseMessengerHandler] {
        if _messengers == nil {
            _messengers = [String: BaseMessengerHandler]()
        }
        return _messengers
    }

    var lock: NSLock {
        if _lock == nil {
            _lock = NSLock()
        }
        return _lock
    }

}