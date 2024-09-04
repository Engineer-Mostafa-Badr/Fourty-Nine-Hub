import 'package:equatable/equatable.dart';

// Base Response Entity
class GiftEntities<T> extends Equatable {
  final bool status;
  final String message;
  final T data;

  const GiftEntities({
    required this.status,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [status, message, data];
}

// Data Entity
class DataEntity extends Equatable {
  final GiftWallet giftWallet;
  final List<CompetitionWallet> competitionsWallet;

  const DataEntity({
    required this.giftWallet,
    required this.competitionsWallet,
  });

  @override
  List<Object?> get props => [giftWallet, competitionsWallet];
}

// GiftWallet Entity
class GiftWallet extends Equatable {
  final String id;
  final String userId;
  final int amount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GiftWallet({
    required this.id,
    required this.userId,
    required this.amount,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, userId, amount, isActive, createdAt, updatedAt];
}

// CompetitionWallet Entity
class CompetitionWallet extends Equatable {
  final Competition competition;
  final int countOfRequest;

  const CompetitionWallet({
    required this.competition,
    required this.countOfRequest,
  });

  @override
  List<Object?> get props => [competition, countOfRequest];
}

// Competition Entity
class Competition extends Equatable {
  final String id;
  final int maxRequests;
  final String nameEn;
  final String nameAr;
  final String descriptionEn;
  final String descriptionAr;

  const Competition({
    required this.id,
    required this.maxRequests,
    required this.nameEn,
    required this.nameAr,
    required this.descriptionEn,
    required this.descriptionAr,
  });

  @override
  List<Object?> get props => [id, maxRequests, nameEn, nameAr, descriptionEn, descriptionAr];
}



