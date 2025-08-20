import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/shipping_repository.dart';
import 'shipping_state.dart';

class RegisterShippingCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  RegisterShippingCubit({required this.repository}) : super(ShippingInitial());
}
