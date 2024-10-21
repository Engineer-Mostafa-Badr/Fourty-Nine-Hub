import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../reposiory/custom_page_repository.dart';

class UpdateSubTabUseCase extends UseCase<bool, SubTabParams> {
  final CustomPageRepository _customPageRepository;

  UpdateSubTabUseCase(this._customPageRepository);

  @override
  Future<Either<Failure, bool>> call(SubTabParams params) async {
    return await _customPageRepository.updateSubTab(params);
  }
}

class SubTabParams {
  final bool auction;
  final bool carpool;
  final bool booking;
  final bool installment;
  final bool tripJoin;

  SubTabParams(
      {required this.auction,
      required this.carpool,
      required this.booking,
      required this.installment,
      required this.tripJoin});

  Map<String, dynamic> toJson() => {
        "Booking": booking,
        "Installment": installment,
        "Carpool": carpool,
        "Auction": auction,
        "TripJoin": tripJoin,
      };
}
