//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <system_theme/system_theme_plugin.h>
#include <win_toast/win_toast_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  SystemThemePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SystemThemePlugin"));
  WinToastPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WinToastPlugin"));
}
