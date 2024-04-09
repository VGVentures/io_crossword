import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/drawer/bloc/drawer_bloc.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/welcome/welcome.dart';

class CrosswordDrawer extends StatelessWidget {
  const CrosswordDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DrawerBloc(
        boardInfoRepository: context.read(),
      )..add(const RecordDataRequested()),
      child: const CrosswordDrawerView(),
    );
  }
}

class CrosswordDrawerView extends StatelessWidget {
  @visibleForTesting
  const CrosswordDrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      DrawerItem(
        title: l10n.settings,
        icon: Icons.settings,
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
              onPressed: () {
                Scaffold.of(context).closeEndDrawer();
              },
              icon: const Icon(
                Icons.close,
              ),
            ),
          ),
          const SizedBox(height: 20),
          BlocSelector<DrawerBloc, DrawerState, (int, int)>(
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
    required this.icon,
    required this.onPressed,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPressed;
}
