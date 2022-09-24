part of 'filter_bloc.dart';

abstract class FilterEvent {
  const FilterEvent();

  @override
  List<Object> get props => [];
}

class LoadCategories extends FilterEvent {}

class LoadLocations extends FilterEvent {}

class Load extends FilterEvent {}

class SearchLocations extends FilterEvent {
  final String queryText;
  SearchLocations(this.queryText);
}
