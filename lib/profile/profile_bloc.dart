import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:second_project/model/item_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper.dart';
import '../model/item_product.dart';
import '../model/user_product.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileShow>(_showData);
    on<LoadActiveProducts>(_loadMyActiveProducts);
    on<LoadInactiveProducts>(_loadMyInactiveProducts);
  }
  Future<void> _showData(ProfileShow event, Emitter<ProfileState> emit) async {
    try {
      if (event.user == null) {
        final prefs = await SharedPreferences.getInstance();
        PersonalDataRepo.apiKey = prefs.getString('apiKey')!;
        Map<String, String> requestHeaders = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${PersonalDataRepo.apiKey}',
        };

        final responseProfile = await http.post(
            Uri.parse('${myServer}api/auth/profile'),
            headers: requestHeaders);
        var result = profileFromJson(responseProfile.body);
        PersonalDataRepo.myProfile = profileFromJson(responseProfile.body);

        emit(MyProfileShowSuccess(User(
            userId: result.id,
            name: result.name,
            email: result.email!,
            phoneNumber: result.phoneNumber)));
      } else {
        emit(GuestProfileShowSuccess(event.user!));
      }
    } catch (e) {
      emit(ProfileShowFail());
    }
  }

  Future<void> _loadMyActiveProducts(
      LoadActiveProducts event, Emitter<ProfileState> emit) async {
    final response =
        await http.get(Uri.parse('${myServer}api/users/${event.userId}'));
    final resultItems = itemUserProductsFromJson(response.body);
    if (event.occasion == 1) {
      emit(LoadGuestActiveProductsSuccess(resultItems.data));
    } else {
      emit(LoadMyActiveProductsSuccess(resultItems.data));
    }
  }

  Future<void> _loadMyInactiveProducts(
      LoadInactiveProducts event, Emitter<ProfileState> emit) async {
    final response = await http
        .get(Uri.parse('${myServer}api/users/${event.userId}?state=inactive'));
    final resultItems = itemUserProductsFromJson(response.body);
    if (event.occasion == 1) {
      emit(LoadGuestInactiveProductsSuccess(resultItems.data));
    } else {
      emit(LoadMyInactiveProductsSuccess(resultItems.data));
    }
  }
}
