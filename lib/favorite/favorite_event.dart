part of 'favorite_bloc.dart';

abstract class FavoriteEvent {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class AddFavorite extends FavoriteEvent {
  final int productId;
  AddFavorite(this.productId);
}

class LoadFavorites extends FavoriteEvent {}

class DeleteFavorite extends FavoriteEvent {
  final int productId;
  DeleteFavorite(this.productId);
}
