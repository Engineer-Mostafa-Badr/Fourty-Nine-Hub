import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/cahnce_rate_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/chance_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/main_category_drop_entity.dart';

import '../../../../../../core/error/failure.dart';

enum ChanceStates { loading, initial, error, success }

class ChanceState extends Equatable {
  final ChanceStates status;
  final Failure? failure;
  final List<ChanceEntity>? chance;
  final ChanceRateEntity? rate;
  final List<MainCategoryDropEntity>? mainCategory ;

  const ChanceState( {
    this.status = ChanceStates.loading,
    this.failure,
    this.chance,
    this.rate,
    this.mainCategory,
  });

  ChanceState copyWith({
    ChanceStates? status,
    Failure? failure,
    List<ChanceEntity>? chance,
    ChanceRateEntity? rate,
    List<MainCategoryDropEntity>? mainCategory ,
  }) {
    return ChanceState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      chance: chance ?? this.chance,
      rate:  rate ?? this.rate,
      mainCategory: mainCategory ?? this.mainCategory
    );
  }

  @override
  List<Object?> get props => [status , failure , chance , rate ,mainCategory];


}
extension ChanceStateX on ChanceState
{
  bool get isInitial => status == ChanceStates.initial;

  bool get isLoading => status == ChanceStates.loading;

  bool get isSuccess => status == ChanceStates.success;

  bool get isFailure => status == ChanceStates.error;

}


