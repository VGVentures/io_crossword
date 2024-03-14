import 'package:backend_admin/http_client/http_client.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';

part 'generate_section_snapshots_state.dart';

class GenerateSectionSnapshotsCubit
    extends Cubit<GenerateSectionSnapshotsState> {
  GenerateSectionSnapshotsCubit({
    required this.crosswordRepository,
    required this.httpClient,
  }) : super(const GenerateSectionSnapshotsState());

  final CrosswordRepository crosswordRepository;
  final HttpClient httpClient;

  Future<void> loadSections() async {
    emit(
      state.copyWith(status: GenerateSectionSnapshotsStatus.loadingSections),
    );
    try {
      final sections = await crosswordRepository.listAllSections();
      emit(
        state.copyWith(
          status: GenerateSectionSnapshotsStatus.success,
          sections: sections,
        ),
      );
    } catch (e, s) {
      addError(e, s);
      emit(
        state.copyWith(
          status: GenerateSectionSnapshotsStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> generateSnapshots() async {
    emit(
      state.copyWith(
        status: GenerateSectionSnapshotsStatus.generatingSnapshots,
      ),
    );
    try {
      for (final section in state.sections) {
        await httpClient.generateSectionSnapshot(
          '${section.position.x},${section.position.y}',
        );
        emit(
          state.copyWith(
            sectionsGenerated: state.sectionsGenerated + 1,
          ),
        );
      }
      emit(state.copyWith(status: GenerateSectionSnapshotsStatus.success));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: GenerateSectionSnapshotsStatus.error,
          error: e.toString(),
        ),
      );
    }
  }
}
