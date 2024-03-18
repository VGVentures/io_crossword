import 'package:backend_admin/generate_section_snapshots/generate_section_snapshots.dart';
import 'package:backend_admin/http_client/http_client.dart';
import 'package:backend_admin/l10n/l10n.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({
    required this.crosswordRepository,
    required this.httpClient,
    super.key,
  });

  final CrosswordRepository crosswordRepository;
  final HttpClient httpClient;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: crosswordRepository),
        RepositoryProvider.value(value: httpClient),
      ],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          useMaterial3: true,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const _HomeView(),
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            children: [
              Column(
                children: [
                  IconButton(
                    tooltip: l10n.generateSectionSnapshots,
                    onPressed: () {
                      Navigator.of(context).push<void>(
                        GenerateSectionSnapshotsPage.route(),
                      );
                    },
                    icon: const Icon(Icons.image),
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.generateSectionSnapshots),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
