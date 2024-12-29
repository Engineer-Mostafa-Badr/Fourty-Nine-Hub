import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/banner_talent_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_winner_entity.dart';

import '../../../../../common/functions/global/upload_file.dart';

enum StarStates { loading, initial, success, uploadSuccess, error }

class StarState {
  final StarStates status;
  final Failure? failure;
  final List<StarEntity>? star;
  final List<StarWinnerEntity>? winner;
  final List<UploadFileEntity>? video;
  final BannerTalentEntity? banner;

  StarState({
    this.status = StarStates.loading,
    this.failure,
    this.star,
    this.winner,
    this.video,
    this.banner,
  });

  StarState copyWith({
    StarStates? status,
    Failure? failure,
    String? filter,
    List<StarEntity>? star,
    List<StarWinnerEntity>? winner,
    List<UploadFileEntity>? video,
    BannerTalentEntity? banner,
  }) {
    return StarState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      star: star ?? this.star,
      winner: winner ?? this.winner,
      video: video ?? this.video,
      banner: banner ?? this.banner,
    );
  }
}
