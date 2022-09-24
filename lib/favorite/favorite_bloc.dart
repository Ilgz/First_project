import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:second_project/model/user_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper.dart';
import '../model/item_product.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteInitial()) {
    on<AddFavorite>(_addFavorite);
    on<DeleteFavorite>(_deleteFavorite);
    on<LoadFavorites>(_loadFavorite);
  }
  Future<void> _loadFavorite(
      LoadFavorites event, Emitter<FavoriteState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      PersonalDataRepo.apiKey = prefs.getString('apiKey')!;
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${PersonalDataRepo.apiKey}',
      };
      String request = '${myServer}api/favorites';
      final response =
          await http.get(Uri.parse(request), headers: requestHeaders);
      var result = itemProductFromJson(response.body);
      PersonalDataRepo.favoritedIds.clear();
      for (int i = 0; i < result.data.length; i++) {
        PersonalDataRepo.favoritedIds.add(result.data[i].id);
      }
      emit(LoadFavoritesSuccess(List.from(result.data)));
    } catch (e) {
      emit(LoadFavoritesFail());
    }
  }

  Future<void> _deleteFavorite(
      DeleteFavorite event, Emitter<FavoriteState> emit) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PersonalDataRepo.apiKey}',
    };
    String request = '${myServer}api/favorites/${event.productId}';
    final response =
        await http.delete(Uri.parse(request), headers: requestHeaders);
    emit(DeleteFavoriteSuccess());
  }

  Future<void> _addFavorite(
      AddFavorite event, Emitter<FavoriteState> emit) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PersonalDataRepo.apiKey}',
    };
    String request =
        '${myServer}api/favorites?user_id=${PersonalDataRepo.myProfile.id}&auction_id=${event.productId}';
    final response =
        await http.post(Uri.parse(request), headers: requestHeaders);
    emit(AddFavoriteSuccess());
  }
}
