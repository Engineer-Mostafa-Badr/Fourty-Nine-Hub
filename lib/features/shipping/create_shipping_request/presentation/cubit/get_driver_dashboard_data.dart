import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/shipping_repository.dart';
import 'shipping_state.dart';

class GetDriverDashboardData extends Cubit<ShippingState> {
  final ShippingRepository repository;
  GetDriverDashboardData({required this.repository}) : super(ShippingInitial());
}
