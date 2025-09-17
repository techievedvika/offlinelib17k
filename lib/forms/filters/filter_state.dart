// filter_state.dart
part of 'filter_cubit.dart';

class FilterState {
  final List<String> states;
    final List<String> districts;
  final List<String> blocks;
  final List<String> schools;
   final List<String> levels;
   final List<String> languages;
  final bool isLoading;

  final String? selectedState;
  final String? selectedDistrict;
  final String? selectedBlock;
  final String? selectedSchool;
  final String? selectedLevel;
  final String? selectedLanguage;

  FilterState({
    this.states = const [],
    this.blocks = const [],
    this.schools = const [],
    this.districts = const[],
    this.levels = const[],
    this.languages = const[],
    this.isLoading = false,
    this.selectedState,
    this.selectedBlock,
    this.selectedSchool,
    this.selectedDistrict,
    this.selectedLevel,
    this.selectedLanguage,
  });

  FilterState copyWith({
    List<String>? states,
    List<String>? blocks,
    List<String>? schools,
    List<String>? districts,
    List<String>? levels,
    List<String>? languages,
    bool? isLoading,
    String? selectedState,
    String? selectedBlock,
    String? selectedSchool,
    String? selectedDistrict,
    String? selectedLevel,
    String? selectedLanguage
  }) {
    return FilterState(
      states: states ?? this.states,
      blocks: blocks ?? this.blocks,
      schools: schools ?? this.schools,
      districts: districts ?? this.districts,
      levels: levels ?? this.levels,
      languages: languages ?? this.languages,
      isLoading: isLoading ?? this.isLoading,
      selectedState: selectedState ?? this.selectedState,
      selectedBlock: selectedBlock ?? this.selectedBlock,
      selectedSchool: selectedSchool ?? this.selectedSchool,
      selectedDistrict: selectedDistrict ?? this.selectedDistrict,
      selectedLevel: selectedLevel ?? this.selectedLevel,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage
    );
  }
}
