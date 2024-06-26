import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:io_crossword/assets/assets.gen.dart';
import 'package:io_crossword/challenge/challenge.dart';
import 'package:io_crossword/end_game/end_game.dart';
import 'package:io_crossword/extensions/extensions.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/project_details/project_details.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class CrosswordDrawer extends StatelessWidget {
  const CrosswordDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final mascot = context.select((PlayerBloc bloc) => bloc.state.mascot);
    final l10n = context.l10n;
    final layout = IoLayout.of(context);
    final textTheme = Theme.of(context).io.textStyles;
    const iconColor = IoCrosswordColors.softGray;
    final items = [
      DrawerItem(
        title: l10n.finishAndSubmitScore,
        icon: Icons.sports_score,
        onPressed: () {
          EndGameCheck.openDialog(context);
        },
      ),
      DrawerItem(
        title: l10n.howToPlay,
        icon: Icons.games,
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (context) => BlocProvider(
              create: (_) => HowToPlayCubit(),
              child: Align(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: switch (layout) {
                      IoLayoutData.small => 375,
                      IoLayoutData.large => 500,
                    },
                  ),
                  child: HowToPlayContent(
                    mascot: mascot,
                    onDonePressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      DrawerItem(
        title: l10n.projectDetails,
        icon: Icons.info,
        onPressed: () {
          showDialog<AlertDialog>(
            context: context,
            builder: (context) => const ProjectDetailsView(),
          );
        },
      ),
      DrawerItem(
        title: l10n.claimBadge,
        icon: IoIcons.google,
        onPressed: () {
          context.launchUrl(ProjectDetailsLinks.claimBadge);
        },
      ),
      DrawerItem(
        title: l10n.googleIO,
        svgIcon: Assets.icons.io.svg(
          colorFilter: const ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        onPressed: () {
          context.launchUrl(ProjectDetailsLinks.googleIO);
        },
      ),
      DrawerItem(
        title: l10n.exploreAiStudio,
        icon: IoIcons.gemini,
        onPressed: () {
          context.launchUrl(ProjectDetailsLinks.googleAI);
        },
      ),
      DrawerItem(
        title: l10n.privacyPolicy,
        icon: Icons.text_snippet,
        onPressed: () {
          context.launchUrl(ProjectDetailsLinks.privacyPolicy);
        },
      ),
      DrawerItem(
        title: l10n.termsOfService,
        icon: Icons.note_alt,
        onPressed: () {
          context.launchUrl(ProjectDetailsLinks.termsOfService);
        },
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
          const ChallengeProgressStatus(),
          const SizedBox(height: 48),
          ...items.map(
            (item) => ListTile(
              leading: item.icon != null
                  ? Icon(item.icon, color: iconColor)
                  : item.svgIcon,
              title: Text(item.title, style: textTheme.body3),
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
