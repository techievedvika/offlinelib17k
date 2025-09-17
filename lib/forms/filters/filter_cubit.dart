import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:lib17000ft/configs/app_urls.dart';
part 'filter_state.dart';

// filter_cubit.dart
class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterState());

  void updateSelectedState(String states) {
    // Reset dependent fields
    emit(state.copyWith(
      selectedState: states,
      selectedBlock: null,
      selectedSchool: null,
      selectedDistrict: null,
      blocks: [],
      schools: [],
      districts: [],
    ));

    print('values of select $states ');
    // Now fetch blocks for selected state
    fetchDistrict(states);
  }

  void updateSelectedDistrict(String district) {
    // Reset dependent fields
    emit(state.copyWith(
      selectedDistrict: district,
      selectedBlock: null,
      selectedSchool: null,
      blocks: [],
      schools: [],
    ));

    print('values of select $district ');
    // Now fetch blocks for selected state
    fetchBlocks(district);
  }

  void updateSelectedBlock(String? block) {
    emit(state.copyWith(
      selectedBlock: block,
      selectedSchool: null, // reset school when block changes
      schools: [], // clear old schools
    ));

    if (block != null) {
      fetchSchools(block);
    }
  }

  void updateSelectedSchool(String? school) {
    emit(state.copyWith(selectedSchool: school));
  }

  void updateSelectedLevel(String? level) {
    emit(state.copyWith(selectedLevel: level));
  }

  void updateSelectedLanguage(String? language) {
    emit(state.copyWith(selectedLanguage: language));
  }

  Future<void> fetchStates() async {
    emit(state.copyWith(isLoading: true));
    final response = await http.get(Uri.parse(AppUrls.getStateapi));
    final List<String> states = List<String>.from(jsonDecode(response.body));
    emit(state.copyWith(states: states, isLoading: false));
  }

  Future<void> fetchBlocks(String selectedDistrict) async {
    emit(state.copyWith(
        isLoading: true,
        selectedDistrict: selectedDistrict,
        selectedBlock: null,
        selectedSchool: null));
    String url = "${AppUrls.getBlockapi}&district=$selectedDistrict";
    final response = await http.get(
      Uri.parse("${AppUrls.getBlockapi}&district=$selectedDistrict"),
    );
    print(
        'this response we got for fetching block on the basis of district $response $url');

    final List<String> blocks = List<String>.from(jsonDecode(response.body));
    emit(state.copyWith(blocks: blocks, isLoading: false));
  }

  Future<void> fetchDistrict(String selectedState) async {
    emit(state.copyWith(
        isLoading: true,
        selectedState: selectedState,
        selectedDistrict: null,
        selectedBlock: null,
        selectedSchool: null));
    String url = "${AppUrls.getDistrictapi}&state=$selectedState";
    final response = await http.get(
      Uri.parse("${AppUrls.getDistrictapi}&state=$selectedState"),
    );
    print('this response we got district on the basis of state $response $url');

    final List<String> districts = List<String>.from(jsonDecode(response.body));
    emit(state.copyWith(districts: districts, isLoading: false));
  }

  Future<void> fetchSchools(String selectedBlock) async {
    emit(state.copyWith(
        isLoading: true, selectedBlock: selectedBlock, selectedSchool: null));
    final response = await http.get(
      Uri.parse("${AppUrls.getSchoolapi}&block=$selectedBlock"),
    );
    final List<String> schools = List<String>.from(jsonDecode(response.body));
    emit(state.copyWith(schools: schools, isLoading: false));
  }

  Future<void> fetchLevels() async {
    emit(state.copyWith(
      isLoading: true,
    ));
    final response = await http.get(
      Uri.parse(AppUrls.getLevelApi),
    );
    print('this is response i got from $response');
    final List<String> levels = List<String>.from(jsonDecode(response.body));
    emit(state.copyWith(levels: levels, isLoading: false));
  }

  Future<void> fetchLanguage() async {
    emit(state.copyWith(
      isLoading: true,
    ));
    final response = await http.get(
      Uri.parse(AppUrls.getLanguageApi),
    );
    print('this is response i got from $response');
    final List<String> language = List<String>.from(jsonDecode(response.body));
    emit(state.copyWith(languages: language, isLoading: false));
  }

  void selectSchool(String school) {
    emit(state.copyWith(selectedSchool: school));
  }

  void clearFilters() {
    emit(FilterState());
    fetchStates();
  }
}
