import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import '../helper.dart';
import '../model/item_product.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  List<Datum> _items = [];
  int _page = 0;
  int _lastPage = 1;
  String _queryText = "";
  SearchBloc() : super(SearchInitial()) {
    on<SearchStarted>(_nothing);
    on<SearchFind>(_searchProducts);
    on<SearchLoad>(_loadProducts);
  }

  Future<void> _searchProducts(
      SearchFind event, Emitter<SearchState> emit) async {
    _items = [];
    _page = 0;
    ++_page;
    _queryText = event.queryText;
    final String parameters =
        "${myServer}api/users?product=$_queryText&page=$_page&sorting=${FilterPreferences.sorting.index}&category=${FilterPreferences.category.id}&location=${FilterPreferences.location.id}&min=${FilterPreferences.minPrice}&max=${FilterPreferences.maxPrice}";

    final response = await http.get(Uri.parse(parameters));
    try {
      final result = itemProductFromJson(response.body);
      emit(SearchSuccess(List.from(result.data)));
      _lastPage = result.meta.lastPage;
      _items.addAll(result.data);
    } catch (e) {
      emit(SearchFail());
    }
  }

  Future<void> _loadProducts(
      SearchLoad event, Emitter<SearchState> emit) async {
    ++_page;
    if (_lastPage >= _page) {
      final String parameters =
          "${myServer}api/users?product=$_queryText&page=$_page&sorting=${FilterPreferences.sorting.index}&category=${FilterPreferences.category.id}&location=${FilterPreferences.location.id}&min=${FilterPreferences.minPrice}&max=${FilterPreferences.maxPrice}";

      final response = await http.get(Uri.parse(parameters));
      if (response.body == '[{"status":"failed"}]') {
        emit(SearchFail());
      } else {
        final result = itemProductFromJson(response.body);
        emit(SearchSuccess(List.from(_items..addAll(result.data))));
        _lastPage = result.meta.lastPage;
        _items.addAll(result.data);
      }
    }
  }

  String getQuery() {
    return _queryText;
  }

  void deleteData() {
    _items = [];
    _page = 0;
    _lastPage = 1;
    _queryText = "";
  }

  Future<void> _nothing(SearchStarted event, Emitter<SearchState> emit) async {}
  @override
  Future<void> close() async {
    _items.clear();
  }
}
