import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../reposiory/custom_page_repository.dart';

class UpdateNavigateBarUseCase extends UseCase<bool, NavigateBarParams> {
  final CustomPageRepository _customPageRepository;

  UpdateNavigateBarUseCase(this._customPageRepository);

  @override
  Future<Either<Failure, bool>> call(NavigateBarParams params) async {
    return await _customPageRepository.updateNavigateBar(params);
  }
}

class NavigateBarParams {
  final bool find;
  final bool health;
  final bool live;
  final bool loading;
  final bool meal;
  final bool meet;
  final bool reel;
  final bool ride;
  final bool snap;
  final bool spotlight;

  NavigateBarParams(
      {
      required this.find,
      required this.health,
      required this.live,
      required this.loading,
      required this.meal,
      required this.meet,
      required this.reel,
      required this.ride,
      required this.snap,
      required this.spotlight,
      });

  Map<String, dynamic> toJson() {
    return {
      'Find': find,
      'Health': health,
      'Live': live,
      'Loading': loading,
      'Meal': meal,
      'Meet': meet,
      'Reel': reel,
      'Ride': ride,
      'Snap': snap,
      'Spotlight': spotlight,
    };
  }
}
