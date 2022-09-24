part of 'user_product_bloc.dart';

abstract class UserProductState  {
  const UserProductState();
}

class UserProductInitial extends UserProductState {
  @override
  List<Object> get props => [];
}
class ActiveUserProductSuccess extends UserProductState {
  final Data items;
  const ActiveUserProductSuccess(this.items);
  @override
  List<Object> get props => [];
}
