import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'BaseMessengerHandler.dart';

/// 作者: zhangchenzhou
/// 时间: 2023/4/14  14:57
/// 描述: Channel通信插件 单例类
/// 作用：
/// 1. 注册消息通道方法
/// 2. 移除消息通道
/// 3. 发送消息
/// 4. 接收消息
///
///

class FlutterChannel {
  bool _setNativeCallBack = false;
  final Map<String, BaseMessengerHandler> _messengers = {};
  final MethodChannel _methodChannel = const MethodChannel("flutter_core_channel");

  ///单例写法
  FlutterChannel._();
  static final FlutterChannel _channel = FlutterChannel._();
  static FlutterChannel get instance => _channel;

  /// 注册消息通道
  void addMessenger<T extends BaseMessengerHandler>({required T messenger}) {
    if (messenger.methodName.isNotEmpty) {
      _messengers[messenger.methodName] = messenger;
    }
    _receivedNativeMessage();
  }

  /// 移除消息通道
  void removeMessenger(String route) {
    if (route.isNotEmpty) {
      _messengers.remove(route);
    }
  }

  /// 发送消息到Native
  Future<Map<String, dynamic>?> send(
      {required String route,
      required String action,
      Map<String, dynamic>? params}) {
    _receivedNativeMessage();

    Map<String, dynamic>? params0 = params ?? {};
    String json = jsonEncode(_wrap(code: "0", data: params0, action: action));
    return _methodChannel
        .invokeMethod<String>(route, json)
        .then((String? value) {
      if (value == null) {
        return Future.value(_wrap(invoke: false));
      }
      try {
        Map<String, dynamic> result = jsonDecode(value);
        return Future.value(result["data"]);
      } on PlatformException catch (e) {
        debugPrint("KooChannel <${e.toString()}>");
        return Future.value(_wrap(
            code: e.code,
            msg: e.message ?? "",
            data: {"error": e.details},
            invoke: false));
      } on MissingPluginException catch (e) {
        debugPrint("KooChannel <${e.toString()}>");
        return Future.value(_wrap(
            code: "-998",
            msg: e.message ?? "",
            data: {"error": e.toString()},
            invoke: false));
      }
    });
  }

  /// 接收消息
  void _receivedNativeMessage() {
    if (_setNativeCallBack == true) {
      return;
    }
    _setNativeCallBack = true;
    instance._methodChannel!.setMethodCallHandler((MethodCall call) {
      Uri name = Uri.parse(call.method);
      BaseMessengerHandler? messenger = _messengers[call.method];
      if (messenger == null) {
        debugPrint(
            "在messengers<${instance._messengers.keys}>中未找到${name.toString()}对应的messenger，确保调用前已经注册");
        return Future.value(
            _wrap(code: "-999", data: {}, msg: "failed", invoke: false));
      }
      String params = call.arguments;
      Map<String, dynamic> arguments =
          jsonDecode(params) as Map<String, dynamic>;
      String action = arguments.remove("action");
      Map<String, dynamic> ret =
          messenger.didReceivedNativeSignal(action, arguments) ?? {};
      ret = _wrap(data: ret, invoke: false);
      return Future.value(jsonEncode(ret));
    });
  }

  /// 数据封装
  Map<String, dynamic> _wrap(
      {String code = "0",
      Map<String, dynamic> data = const {},
      String msg = "success",
      String action = "",
      bool invoke = true}) {
    if (invoke) {
      return {"code": code, "data": data, "msg": msg, "action": action};
    }
    return {"code": code, "data": data, "msg": msg};
  }
}


