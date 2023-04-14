import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_core_channel/flutter_core_channel.dart';
import 'package:flutter_core_channel/flutter_core_channel_platform_interface.dart';
import 'package:flutter_core_channel/flutter_core_channel_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterCoreChannelPlatform
    with MockPlatformInterfaceMixin
    implements FlutterCoreChannelPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterCoreChannelPlatform initialPlatform = FlutterCoreChannelPlatform.instance;

  test('$MethodChannelFlutterCoreChannel is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterCoreChannel>());
  });

  test('getPlatformVersion', () async {
    FlutterCoreChannel flutterCoreChannelPlugin = FlutterCoreChannel();
    MockFlutterCoreChannelPlatform fakePlatform = MockFlutterCoreChannelPlatform();
    FlutterCoreChannelPlatform.instance = fakePlatform;

    expect(await flutterCoreChannelPlugin.getPlatformVersion(), '42');
  });
}
