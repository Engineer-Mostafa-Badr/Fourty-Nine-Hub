import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';

enum StarStates { loading, initial, success, error }

class StarState {
  final StarStates status;
  final Failure? failure;
  final List<StarEntity>? star;

  StarState({
    this.status = StarStates.loading,
    this.failure,
    this.star,
  });

  StarState copyWith({
    StarStates? status,
    Failure? failure,
    String? filter,
    List<StarEntity>? star,
  }) {
    return StarState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      star: star ?? this.star,
    );
  }
}
