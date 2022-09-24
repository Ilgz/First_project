part of 'search_bloc.dart';

abstract class SearchState {
  const SearchState();
}

class SearchInitial extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchSuccess extends SearchState {
  final List<Datum> items;
  SearchSuccess(this.items);
  @override
  List<Object?> get props => [items];
}

class SearchFail extends SearchState {
  @override
  List<Object?> get props => [];
}
