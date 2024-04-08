import 'package:flutter/material.dart';
import 'package:io_crossword/assets/assets.gen.dart';
import 'package:io_crossword/welcome/welcome.dart';

/// {@template welcome_header_image}
/// An image that is displayed at the top of the [WelcomePage].
///
/// See also:
///
/// * [WelcomePage], a page that displays the [WelcomeHeaderImage]
/// on smaller screens, such as mobile devices.
/// {@endtemplate}
class WelcomeHeaderImage extends StatelessWidget
    implements PreferredSizeWidget {
  /// {@macro welcome_header_image}
  const WelcomeHeaderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: preferredSize,
      child: Assets.images.welcomeBackground.image(
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 187);
}
