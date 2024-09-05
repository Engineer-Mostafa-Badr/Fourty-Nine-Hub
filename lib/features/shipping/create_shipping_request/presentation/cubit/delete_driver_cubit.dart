import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';

class DeleteDriverCubit extends Cubit<ShippingState> {
  DeleteDriverCubit() : super(ShippingInitial());
}