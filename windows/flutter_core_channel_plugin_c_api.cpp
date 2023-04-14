#include "include/flutter_core_channel/flutter_core_channel_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_core_channel_plugin.h"

void FlutterCoreChannelPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_core_channel::FlutterCoreChannelPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
