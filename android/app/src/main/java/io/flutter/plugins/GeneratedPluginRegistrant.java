package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.gainsight.px.mobile.GainsightpxFlutterPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    GainsightpxFlutterPlugin.registerWith(registry.registrarFor("com.gainsight.px.mobile.GainsightpxFlutterPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
