part of 'favorite_bloc.dart';

abstract class FavoriteState {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class LoadFavoritesSuccess extends FavoriteState {
  final List<Datum> items;
  LoadFavoritesSuccess(this.items);
}

class LoadFavoritesFail extends FavoriteState {}

class AddFavoriteSuccess extends FavoriteState {}

class DeleteFavoriteSuccess extends FavoriteState {}
