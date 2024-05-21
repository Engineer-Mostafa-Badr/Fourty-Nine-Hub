part of 'shipping_bloc.dart';

abstract class ShippingState extends Equatable {
  const ShippingState();  

  @override
  List<Object> get props => [];
}
class ShippingInitial extends ShippingState {}
