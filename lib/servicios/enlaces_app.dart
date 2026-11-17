import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_links.dart';

/// Resuelve las direcciones de distribución sin guardar datos del usuario.
abstract final class EnlacesApp {
  static Uri get web => Uri.parse(AppLinks.webUrl);
  static Uri get apk => Uri.parse(AppLinks.apkUrl);

  /// Abre una dirección web válida fuera de la app y devuelve false si el plugin falla.
  static Future<bool> abrir(Uri direccion) async {
    if (!['http', 'https'].contains(direccion.scheme) ||
        direccion.host.isEmpty) {
      return false;
    }
    try {
      return await launchUrl(direccion, mode: LaunchMode.externalApplication);
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}
