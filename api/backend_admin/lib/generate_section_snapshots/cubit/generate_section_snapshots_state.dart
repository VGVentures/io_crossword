part of 'generate_section_snapshots_cubit.dart';

enum GenerateSectionSnapshotsStatus {
  initial,
  loadingSections,
  generatingSnapshots,
  success,
  error,
}

class GenerateSectionSnapshotsState extends Equatable {
  const GenerateSectionSnapshotsState({
    this.status = GenerateSectionSnapshotsStatus.initial,
    this.sections = const [],
    this.error = '',
    this.sectionsGenerated = 0,
  });

  final GenerateSectionSnapshotsStatus status;
  final List<BoardSection> sections;
  final String error;
  final int sectionsGenerated;

  GenerateSectionSnapshotsState copyWith({
    GenerateSectionSnapshotsStatus? status,
    List<BoardSection>? sections,
    String? error,
    int? sectionsGenerated,
  }) {
    return GenerateSectionSnapshotsState(
      status: status ?? this.status,
      sections: sections ?? this.sections,
      error: error ?? this.error,
      sectionsGenerated: sectionsGenerated ?? this.sectionsGenerated,
    );
  }

  @override
  List<Object?> get props => [
        status,
        sections,
        error,
        sectionsGenerated,
      ];
}
