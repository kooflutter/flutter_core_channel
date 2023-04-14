package net.allinmeta.flutter_core_channel

typealias FlutterMessengerMap = HashMap<String, Any>
typealias MessageResult = (result: FlutterMessengerMap?) -> Unit

/**
 * Flutter 消息处理器基类。外部继承实现此接口，即可处理指定通道方法的消息
 */
interface BaseMessengerHandler {

    /// 当前通道的调用的方法名称
    fun methodName(): String

    /// 收到来自Flutter的消息
    /// params: 消息参数
    /// action: 执行目的
    /// 返回给Flutter的值
    fun didReceivedFlutterSignal(params: FlutterMessengerMap?, action: String): FlutterMessengerMap?
}