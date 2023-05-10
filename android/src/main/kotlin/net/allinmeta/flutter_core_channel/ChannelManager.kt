package net.allinmeta.flutter_core_channel

import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Flutter通道管理类。主要作用是
 * 1. 注册通道
 * 2. 销毁通道
 * 3. 添加消息处理器
 * 
 */

object ChannelManager: MethodChannel.MethodCallHandler {

    /// 消息通道
    private lateinit var methodChannel: MethodChannel;

    private val messengers: HashMap<String, BaseMessengerHandler> by lazy {
        val ret = HashMap<String, BaseMessengerHandler>()
        ret
    }

    /// 注册通道
    fun registerWithEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_core_channel")
        methodChannel.setMethodCallHandler(this)
    }

    /// 销毁通道
    fun destroy() {
        methodChannel.setMethodCallHandler(null)
    }

    /// 添加多个消息处理器
    @Synchronized
    fun addAllMessengers(messengers: Array<BaseMessengerHandler>) {
        for (m: BaseMessengerHandler in messengers) {
            ChannelManager.messengers.put(key = m.methodName(), value = m)
        }
    }

    /// 添加单个消息处理器
    @Synchronized
    fun addMessenger(messenger: BaseMessengerHandler) {
        messengers.put(key = messenger.methodName(), value = messenger)
    }

    /// 移除单个消息处理器
    @Synchronized
    fun removeMessenger(methodName: String) {
        messengers.remove(methodName)
    }

    /// 移除所有消息处理器
    @Synchronized
    fun removeAllMessengers() {
        messengers.clear()
    }

    /// 发送消息值Flutter
    /// route 消息路由
    /// action 目的地
    /// params 消息参数
    /// result flutter给原生的回调
    fun send(methodName: String, params: FlutterMessengerMap? = FlutterMessengerMap(), result: MessageResult? = null) {
        methodChannel.invokeMethod(
                methodName,
                encode(wrap(msg = "success", data = params)),
                FlutterSendMessageCallBack(result)
        )
    }

    /// 接收Flutter传递的消息
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        var messenger: BaseMessengerHandler? = messengers[call.method]
        if (messenger == null) {
            Log.e("KooChannel","在messengers<${messengers.keys}>中未找到${call.method}对应的messenger，确保调用前已经注册")
            result.success(encode(wrap(msg = "failed", code = -999)))
        }else{
            val params: HashMap<String, Any> = decode((call.arguments as String))
            val action: String = params.remove("action") as String
            var ret: FlutterMessengerMap? = messenger.didReceivedFlutterSignal(params, action)
            result.success(encode(wrap(data = ret, msg = "success")))
        }

    }


}