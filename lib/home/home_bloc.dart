import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../helper.dart';
import '../model/item_product.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<Datum> items = [];
  int _page = 0;
  int _lastPage = 1;

  HomeBloc() : super(HomeInitial()) {
    on<HomeLoadProducts>(_loadProducts);
  }

  Future<void> _loadProducts(
      HomeLoadProducts event, Emitter<HomeState> emit) async {
    ++_page;
    try {
      if (_lastPage >= _page) {
        String parameters =
            "${myServer}api/users?page=$_page&sorting=${FilterPreferences.sorting.index}&category=${FilterPreferences.category.id}&location=${FilterPreferences.location.id}&min=${FilterPreferences.minPrice}&max=${FilterPreferences.maxPrice}";
        if (PersonalDataRepo.myProfile.id != 0) {
          parameters = parameters + "&exc=${PersonalDataRepo.myProfile.id}";
        }
        final response = await http.get(Uri.parse(parameters));
        final result = itemProductFromJson(response.body);
        //final result =itemProductFromJson(jsonDecode(response.body.replaceAll(r"\'", "'")));
        _lastPage = result.meta.lastPage;
        emit(HomeSuccess(List.from(items)..addAll(result.data)));
        items.addAll(result.data);
      }
    } catch (e) {
      emit(HomeFail());
    }
  }

  void deleteData() {
    items.clear();
    _lastPage = 1;
    _page = 0;
  }
}
