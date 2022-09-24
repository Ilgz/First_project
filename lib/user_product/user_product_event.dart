part of 'user_product_bloc.dart';

abstract class UserProductEvent  {
  const UserProductEvent();
}
class UserProductStarted extends UserProductEvent{

}
class ActiveUserProductsLoaded extends UserProductEvent{
  final int userId;
  const ActiveUserProductsLoaded({required this.userId});
  @override
  List<Object?> get props => [];
}