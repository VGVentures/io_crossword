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
    }

    await url_launcher.launchUrl(url);
  }

  // TODO(any): Consider relying on built-in Uri encoding.
  // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6444093330
  String _encode(List<String> content) =>
      content.join('%0a').replaceAll(' ', '%20').replaceAll('#', '%23');

  Future<void> shareTwitter({required String shareUrl}) {
    final content = _encode([
      'Check out IOCrossword #GoogleIO!',
      shareUrl,
    ]);

    final url = 'https://twitter.com/intent/tweet?text=$content';

    return launchUrl(url);
  }

  Future<void> shareFacebook({required String shareUrl}) {
    final url = 'https://www.facebook.com/sharer.php?u=$shareUrl';
    return launchUrl(url);
  }

  Future<void> shareLinkedIn({required String shareUrl}) {
    final url = 'https://www.linkedin.com/sharing/share-offsite/?url=$shareUrl';
    return launchUrl(url);
  }
}
