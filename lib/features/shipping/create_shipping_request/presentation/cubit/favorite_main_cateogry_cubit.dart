import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/shipping_repository.dart';
import 'shipping_state.dart';

class FavoriteMainCateogryCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  FavoriteMainCateogryCubit({required this.repository})
      : super(ShippingInitial());
  favorite(String id) async {
    var response = await repository.favoriteMain(id: id);
  }
}
