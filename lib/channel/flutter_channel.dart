import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'base_messenger_handler.dart';

/// 作者: zhangchenzhou
/// 时间: 2023/4/14  14:57
/// 描述: Channel通信插件 单例类 使用极简单例写法
/// 作用：创建一个默认预置的消息通道，从而方便flutter与原生间的方法调用及相互处理。
/// 1. 注册消息通道方法
/// 2. 移除消息通道
/// 3. 发送消息
/// 4. 接收消息

class FlutterChannel {
  /// 注册具体通道
  final MethodChannel _methodChannel = const MethodChannel("flutter_core_channel");

  ///单例写法
  ///FlutterChannel 类的构造函数被标记为私有，以防止在类外部创建新的实例。
  ///在类内部定义一个静态的 instance 变量，并初始化为 Singleton 类的实例。
  ///由于 instance 是静态的，所以只会被初始化一次，并且可以通过类名直接访问。
  ///
  /// 这种写法非常简单，且线程安全，是实现单例模式的一种常用写法
  FlutterChannel._() {
    _registerMethodCallHandler();
  }
  static final FlutterChannel instance = FlutterChannel._();

  /// K-通道名称  Value-通道处理器
  final Map<String, BaseMessengerHandler> _messengers = {};


  /// 注册 方法的消息处理器
  void addMessenger<T extends BaseMessengerHandler>({required T messenger}) {
    if (messenger.methodName.isNotEmpty) {
      _messengers[messenger.methodName] = messenger;
    }
  }

  /// 移除消息处理器
  void removeMessenger(String methodName) {
    if (methodName.isNotEmpty) {
      _messengers.remove(methodName);
    }
  }

  /// 发送发送指定信息到某一个方法中,,,此处action可斟酌。
  Future<Map<String, dynamic>?> send(
      {required String methodName,
      required String action,
      Map<String, dynamic>? params}) {
    Map<String, dynamic>? params0 = params ?? {};
    String json = jsonEncode(_wrap(code: "0", data: params0, action: action));
    return _methodChannel
        .invokeMethod<String>(methodName, json)
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
        }
      );
  }

  /// 注册消息通道，处理原生发过来的消息。
  void _registerMethodCallHandler(){
    instance._methodChannel.setMethodCallHandler((MethodCall call) {
      Uri name = Uri.parse(call.method);
      BaseMessengerHandler? messenger = _messengers[call.method];
      if (messenger == null) {
        debugPrint("在messengers<${instance._messengers.keys}>中未找到${name.toString()}对应的messenger，确保调用前已经注册");
        return Future.value(_wrap(code: "-999", data: {}, msg: "failed", invoke: false));
      }
      String params = call.arguments;
      Map<String, dynamic> arguments =
      jsonDecode(params) as Map<String, dynamic>;
      String action = arguments.remove("action");
      Map<String, dynamic> ret =messenger.didReceivedNativeSignal(action, arguments) ?? {};
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


