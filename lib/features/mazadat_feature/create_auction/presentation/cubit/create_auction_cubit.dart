import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_auction_state.dart';

class CreateAuctionCubit extends Cubit<CreateAuctionState> {
  CreateAuctionCubit() : super(CreateAuctionInitial());
}
