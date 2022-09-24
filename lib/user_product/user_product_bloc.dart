import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:second_project/model/user_product.dart';
import 'package:http/http.dart' as http;
import '../helper.dart';

part 'user_product_event.dart';
part 'user_product_state.dart';

class UserProductBloc extends Bloc<UserProductEvent, UserProductState> {
  UserProductBloc() : super(UserProductInitial()) {
    on<ActiveUserProductsLoaded>(_loadProducts);
    on<UserProductStarted>(_Nothing);
  }

  Future<void> _loadProducts(
      ActiveUserProductsLoaded event, Emitter<UserProductState> emit) async {
    final response =
        await http.get(Uri.parse('${myServer}api/users/${event.userId}'));
    final result = itemUserProductsFromJson(response.body);
    emit(ActiveUserProductSuccess(result.data));
  }

  Future<void> _Nothing(
      UserProductStarted event, Emitter<UserProductState> emit) async {}
}
