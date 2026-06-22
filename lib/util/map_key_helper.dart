import 'package:zerin_express/features/splash/controllers/config_controller.dart';
import 'package:zerin_express/util/env_config.dart';
import 'package:get/get.dart';

/// Resolves Google Maps API key: backend config first, then --dart-define.
String resolveMapApiKey() {
  final fromBackend = Get.isRegistered<ConfigController>()
      ? Get.find<ConfigController>().config?.mapApiKey
      : null;
  if (fromBackend != null && fromBackend.isNotEmpty) {
    return fromBackend;
  }
  return EnvConfig.googleMapsApiKey;
}
