import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_core_channel_method_channel.dart';

abstract class FlutterCoreChannelPlatform extends PlatformInterface {
  /// Constructs a FlutterCoreChannelPlatform.
  FlutterCoreChannelPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterCoreChannelPlatform _instance = MethodChannelFlutterCoreChannel();

  /// The default instance of [FlutterCoreChannelPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterCoreChannel].
  static FlutterCoreChannelPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterCoreChannelPlatform] when
  /// they register themselves.
  static set instance(FlutterCoreChannelPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
