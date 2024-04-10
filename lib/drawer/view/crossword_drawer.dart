import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:io_crossword/assets/assets.gen.dart';
import 'package:io_crossword/challenge/challenge.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/welcome/welcome.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class CrosswordDrawer extends StatelessWidget {
  const CrosswordDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      DrawerItem(
        title: l10n.settings,
        icon: Icons.settings,
        onPressed: () {}, // coverage:ignore-line
      ),
      DrawerItem(
        title: l10n.howToPlay,
        icon: Icons.games,
        onPressed: () {}, // coverage:ignore-line
      ),
      DrawerItem(
        title: l10n.submitScore,
        icon: Icons.sports_score,
        onPressed: () {}, // coverage:ignore-line
      ),
      DrawerItem(
        title: l10n.projectDetails,
        icon: Icons.info,
        onPressed: () {}, // coverage:ignore-line
      ),
      DrawerItem(
        title: l10n.exploreAiStudio,
        icon: IoIcons.gemini,
        onPressed: () {}, // coverage:ignore-line
      ),
      DrawerItem(
        title: l10n.googleIO,
        svgIcon: Assets.icons.io.svg(),
        onPressed: () {}, // coverage:ignore-line
      ),
      DrawerItem(
        title: l10n.developerProfile,
        svgIcon: Assets.icons.google.svg(),
        onPressed: () {}, // coverage:ignore-line
      ),
      DrawerItem(
        title: l10n.privacyPolicy,
        icon: Icons.text_snippet,
        onPressed: () {}, // coverage:ignore-line
      ),
      DrawerItem(
        title: l10n.termsOfService,
        icon: Icons.note_alt,
        onPressed: () {}, // coverage:ignore-line
      ),
      DrawerItem(
        title: l10n.faqs,
        icon: Icons.chat,
        onPressed: () {}, // coverage:ignore-line
      ),
    ];

    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Scaffold.of(context).closeEndDrawer(),
              icon: const Icon(
                Icons.close,
              ),
            ),
          ),
          const SizedBox(height: 20),
          BlocSelector<ChallengeBloc, ChallengeState, (int, int)>(
            selector: (state) => (state.solvedWords, state.totalWords),
            builder: (context, words) {
              return ChallengeProgress(
                solvedWords: words.$1,
                totalWords: words.$2,
              );
            },
          ),
          const SizedBox(height: 48),
          ...items.map(
            (item) => ListTile(
              leading: Icon(item.icon),
              title: Text(item.title),
              onTap: item.onPressed,
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerItem {
  DrawerItem({
    required this.title,
    required this.onPressed,
    this.icon,
    this.svgIcon,
  }) : assert(icon != null || svgIcon != null, 'item must have an icon');

  final String title;
  final IconData? icon;
  final SvgPicture? svgIcon;
  final VoidCallback onPressed;
}
