import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:second_project/model/item_product.dart';
import 'package:http/http.dart' as http;
import '../helper.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailBloc() : super(DetailInitial()) {
    on<LoadRelated>(_loadProducts);
    on<ChangeStateStatus>(_changeStateStatus);
  }
  Future<void> _changeStateStatus(
      ChangeStateStatus event, Emitter<DetailState> emit) async {
    final String parameters = "${myServer}api/auc/${event.id}";
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PersonalDataRepo.apiKey}',
    };
    final response =
        await http.put(Uri.parse(parameters), headers: requestHeaders);
    emit(ChangeStateStatusSuccess());
  }

  Future<void> _loadProducts(
      LoadRelated event, Emitter<DetailState> emit) async {
    final String parameters = "${myServer}api/users?category=${event.category}";
    final response = await http.get(Uri.parse(parameters));
    final result = itemProductFromJson(response.body);
    for (int i = 0; i < result.data.length; i++) {
      if (result.data[i].id == event.id) {
        result.data.removeAt(i);
      }
    }
    result.data.shuffle();
    emit(LoadRelatedSuccess(result.data));
  }
}
