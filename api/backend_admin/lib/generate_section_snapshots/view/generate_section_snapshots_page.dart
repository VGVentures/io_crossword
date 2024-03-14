import 'package:backend_admin/generate_section_snapshots/generate_section_snapshots.dart';
import 'package:backend_admin/http_client/http_client.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenerateSectionSnapshotsPage extends StatelessWidget {
  const GenerateSectionSnapshotsPage({
    super.key,
  });

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (context) {
          return GenerateSectionSnapshotsCubit(
            crosswordRepository: context.read<CrosswordRepository>(),
            httpClient: context.read<HttpClient>(),
          );
        },
        child: const GenerateSectionSnapshotsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const GenerateSectionSnapshotsView();
  }
}

class GenerateSectionSnapshotsView extends StatelessWidget {
  const GenerateSectionSnapshotsView({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select(
      (GenerateSectionSnapshotsCubit cubit) => cubit.state.status,
    );

    switch (status) {
      case GenerateSectionSnapshotsStatus.initial:
        return const _InitialView();
      case GenerateSectionSnapshotsStatus.loadingSections:
        return const _LoadingView();
      case GenerateSectionSnapshotsStatus.success:
        return const _SectionsView();
      case GenerateSectionSnapshotsStatus.generatingSnapshots:
        return const _GeneratingSnapshotsView();
      case GenerateSectionSnapshotsStatus.error:
        return const _ErrorView();
    }
  }
}

class _InitialView extends StatelessWidget {
  const _InitialView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<GenerateSectionSnapshotsCubit>().loadSections();
          },
          child: const Text('Load Sections'),
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _SectionsView extends StatelessWidget {
  const _SectionsView();

  @override
  Widget build(BuildContext context) {
    final sections = context.select(
      (GenerateSectionSnapshotsCubit cubit) => cubit.state.sections,
    );
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Loaded ${sections.length} sections',
            ),
            ElevatedButton(
              onPressed: () {
                context
                    .read<GenerateSectionSnapshotsCubit>()
                    .generateSnapshots();
              },
              child: const Text('Generate Snapshots'),
            ),
          ],
        ),
      ),
    );
  }
}

class _GeneratingSnapshotsView extends StatelessWidget {
  const _GeneratingSnapshotsView();

  @override
  Widget build(BuildContext context) {
    final sections = context.select(
      (GenerateSectionSnapshotsCubit cubit) => cubit.state.sections,
    );
    final sectionsGenerated = context.select(
      (GenerateSectionSnapshotsCubit cubit) => cubit.state.sectionsGenerated,
    );
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Generated $sectionsGenerated of ${sections.length} sections',
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          context.read<GenerateSectionSnapshotsCubit>().state.error,
        ),
      ),
    );
  }
}
