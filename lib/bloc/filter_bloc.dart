import 'package:bloc/bloc.dart';
import 'package:second_project/model/location.dart';

import '../helper.dart';
import 'package:http/http.dart' as http;

import '../model/category.dart';
part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(FilterInitial()) {
    on<SearchLocations>(_searchLocations);
  }
  Future<void> _searchLocations(
      SearchLocations event, Emitter<FilterState> emit) async {
    List<Location> searchLocationList = [];
    for (var i = 0; i < PersonalDataRepo.locationList.length; i++) {
      if (PersonalDataRepo.locationList[i].titleRu
          .toLowerCase()
          .contains(event.queryText.toLowerCase())) {
        searchLocationList.add(Location(
            id: PersonalDataRepo.locationList[i].id,
            titleRu: PersonalDataRepo.locationList[i].titleRu));
      }
      emit(SearchLocationsSuccess(searchLocationList));
    }
  }
}
