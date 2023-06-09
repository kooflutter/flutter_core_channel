abstract class BaseMessengerHandler {
  /// Messenger的类名
  String get methodName;
  /// 处理来自Native的消息
  Map<String, dynamic>? didReceivedNativeSignal(Map<String, dynamic>? params);
}