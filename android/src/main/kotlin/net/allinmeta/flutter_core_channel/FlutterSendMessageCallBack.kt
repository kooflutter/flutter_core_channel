package net.allinmeta.flutter_core_channel

import io.flutter.plugin.common.MethodChannel

internal class FlutterSendMessageCallBack(result: MessageResult?): MethodChannel.Result {

    val ret: MessageResult? = result

    override fun success(result: Any?) {
        if (ret != null) {
            ret!!(decode((result as String)))
        }
    }

    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {

    }

    override fun notImplemented() {

    }
}