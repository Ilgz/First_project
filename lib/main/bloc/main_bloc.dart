import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:second_project/helper.dart';
import 'package:second_project/model/item_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../model/category.dart';
import '../../model/location.dart';
part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainInitial()) {
    on<LoadStartData>(_loadStartData);
  }

  Future<void> _loadStartData(
      LoadStartData event, Emitter<MainState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      PersonalDataRepo.apiKey = prefs.getString('apiKey')!;
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${PersonalDataRepo.apiKey}',
      };
      var client = http.Client();
      try {
        final _responseLocation =
            await client.get(Uri.parse('${myServer}api/location'));
        PersonalDataRepo.locationList =
            locationFromJson(_responseLocation.body);
        final _responseCategory =
            await http.get(Uri.parse('${myServer}api/category'));
        PersonalDataRepo.categoryList =
            categoryFromJson(_responseCategory.body);
        final responseProfile = await client.post(
            Uri.parse('${myServer}api/auth/profile'),
            headers: requestHeaders);
        print(responseProfile.body);
        PersonalDataRepo.myProfile = profileFromJson(responseProfile.body);
      } finally {
        client.close();
        emit(LoadStartDataSuccess());
      }
    } catch (e) {
      emit(LoadStartDataFail());
    }
  }
}
