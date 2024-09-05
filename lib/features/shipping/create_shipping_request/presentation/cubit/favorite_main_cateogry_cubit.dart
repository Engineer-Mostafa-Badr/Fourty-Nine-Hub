import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/shipping_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';

class FavoriteMainCateogryCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  FavoriteMainCateogryCubit({required this.repository})
      : super(ShippingInitial());
  favorite(String id) async {
    var response = await repository.favoriteMain(id: id);
  }
}
