package net.allinmeta.flutter_core_channel_example

import android.os.Bundle
import android.os.Handler
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import net.allinmeta.flutter_core_channel.BaseMessengerHandler
import net.allinmeta.flutter_core_channel.ChannelManager
import net.allinmeta.flutter_core_channel.FlutterMessengerMap

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val messengers: Array<BaseMessengerHandler> = arrayOf(TestMessenger())
        ChannelManager.addAllMessengers(messengers)
    }

}

class TestMessenger : BaseMessengerHandler {
    override fun methodName(): String {
        return "sendMessageToNative"
    }

    override fun didReceivedFlutterSignal(params: FlutterMessengerMap?, action: String): FlutterMessengerMap? {
        Log.e("MainActivity", "收到flutter的消息 == $params, action == $action")
        val ret: FlutterMessengerMap = FlutterMessengerMap()
        ret["native"] = "android"

        Handler().postDelayed({
            val x: FlutterMessengerMap = FlutterMessengerMap()
            x["man"] = "哈哈 - Android"
            ChannelManager.send(methodName(), "share", x) {
                Log.e("MainActivity", "Flutter返回值 == $it")
            }
        }, 5000);
        return ret
    }
}
