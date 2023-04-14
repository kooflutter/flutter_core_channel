import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_core_channel_platform_interface.dart';

/// An implementation of [FlutterCoreChannelPlatform] that uses method channels.
class MethodChannelFlutterCoreChannel extends FlutterCoreChannelPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_core_channel');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
