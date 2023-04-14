import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_core_channel/channel/BaseMessengerHandler.dart';
import 'package:flutter_core_channel/flutter_core_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  // final _flutterCoreChannelPlugin = FlutterCoreChannel();


  @override
  void initState() {
    super.initState();
    FlutterChannel.instance.addMessenger(messenger: TestMessenger());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: InkWell(onTap:(){
            FlutterChannel.instance.send(
                route: "sendMessageToNative",
                action: "version",
                params: {
                  "id": "2222",
                  "data": {"name": "fsafldkj"}
                }).then((value) => {print("main.dart   原生返回值 === ${value}")});
          },child: Text('向原生发送消息')),
        ),
      ),
    );
  }
}
class TestMessenger extends BaseMessengerHandler {
  @override
  Map<String, dynamic>? didReceivedNativeSignal(
      String action, Map<String, dynamic>? params) {
    print("接受到原生消息 == $action, params == $params");
    return {"woman": "嗯嗯嗯 - Flutter"};
  }

  @override
  String get methodName => "sendMessageToNative";
}