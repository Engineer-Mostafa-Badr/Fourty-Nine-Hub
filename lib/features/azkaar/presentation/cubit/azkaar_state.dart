import 'package:fourtyninehub/features/azkaar/domain/entity/azkar_details_entity.dart';
import 'package:fourtyninehub/features/azkaar/domain/entity/azkar_entity.dart';

import '../../../../../../core/error/failure.dart';
import '../../domain/entity/azkar_search_entity.dart';

enum AzkarStates { loading, initial, error, success }

class AzkarState {
  final AzkarStates status;
  final Failure? failure;
  final List<AzkarEntity>? akar;
  final List<AzkarDetailsEntity>? azkarDetail;
  final List<AzkarSearchEntity>? azkarSearch;

  const AzkarState({
    this.status = AzkarStates.loading,
    this.failure,
    this.akar,
    this.azkarDetail,
    this.azkarSearch,
  });
  AzkarState copyWith({
    AzkarStates? status,
    Failure? failure,
    List<AzkarEntity>? akar,
    List<AzkarDetailsEntity>? azkarDetail,
    List<AzkarSearchEntity>? azkarSearch,
  }) {
    return AzkarState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      akar: akar ?? this.akar,
      azkarDetail: azkarDetail ?? this.azkarDetail,
      azkarSearch: azkarSearch ?? this.azkarSearch,
    );
  }
}
