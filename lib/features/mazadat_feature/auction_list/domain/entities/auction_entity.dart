import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_details/domain/entities/bidding_entity.dart';

import '../../../../../service_locator/service_locator.dart';

class AuctionEntity {
  final String id;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final bool isFinished;
  final num minPrice;
  final num currentPrice;
  final num rate;
  final AdEntity ad;
  final UserEntity? user;
  final List<BiddingEntity>? biddings;
  bool get isMine =>
      serviceLocator<UserCubit>().state.data?.isMyAccount(user?.id ?? '') ??
      false;

  AuctionEntity({
    required this.id,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.minPrice,
    required this.currentPrice,
    required this.rate,
    required this.ad,
    required this.isFinished,
    this.user,
    this.biddings,
  });
}
