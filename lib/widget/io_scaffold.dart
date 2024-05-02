import 'package:flutter/material.dart';
import 'package:io_crossword/drawer/drawer.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/music/music.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class IoScaffold extends StatelessWidget {
  const IoScaffold({
    required this.child,
    this.title,
    this.bottom,
    super.key,
  });

  final Widget child;
  final Widget? title;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      endDrawer: const CrosswordDrawer(),
      appBar: IoAppBar(
        crossword: l10n.crossword,
        title: title,
        bottom: bottom,
        actions: (context) {
          return const Row(
            children: [
              MuteButton(),
              SizedBox(width: 7),
              EndDrawerButton(),
            ],
          );
        },
      ),
      body: child,
    );
  }
}
