import 'package:flutter/material.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

extension ContextExt on BuildContext {
  Future<void> launchUrl(String link) async {
    final url = Uri.parse(link);

    if (!await url_launcher.canLaunchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(this)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(l10n.couldNotOpenUrl),
              behavior: SnackBarBehavior.floating,
            ),
          );
      }

      throw Exception('Could not launch $url');
    }

    await url_launcher.launchUrl(url);
  }
}
