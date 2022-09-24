part of 'search_bloc.dart';

abstract class SearchEvent {
  const SearchEvent();
}

class SearchStarted extends SearchEvent {
  @override
  List<Object?> get props => [];
}

class SearchFind extends SearchEvent {
  final String queryText;
  SearchFind(this.queryText);
  @override
  List<Object?> get props => [];
}

class SearchLoad extends SearchEvent {
  @override
  List<Object?> get props => [];
}
