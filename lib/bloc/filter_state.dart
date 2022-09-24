part of 'filter_bloc.dart';

abstract class FilterState {
  const FilterState();

  @override
  List<Object> get props => [];
}

class FilterInitial extends FilterState {}

class LoadCategoriesSuccess extends FilterState {
  final List<Category> list;
  LoadCategoriesSuccess(this.list);
}

class LoadLocationsSuccess extends FilterState {
  final List<Location> list;
  LoadLocationsSuccess(this.list);
}

class SearchLocationsSuccess extends FilterState {
  final List<Location> list;
  SearchLocationsSuccess(this.list);
}
