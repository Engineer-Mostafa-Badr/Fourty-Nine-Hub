import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';

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
  final bool marriage;
  final bool reel;
  final bool ride;
  final bool snap;
  final bool spotlight;

  NavigateBarParams({
    required this.find,
    required this.health,
    required this.live,
    required this.loading,
    required this.meal,
    required this.marriage,
    required this.reel,
    required this.ride,
    required this.snap,
    required this.spotlight,
  });

  factory NavigateBarParams.fromJson(Map<String, dynamic> json) {
    return NavigateBarParams(
      find: json['Find']['enabled'] ?? false,
      health: json['Health']['enabled'] ?? false,
      live: json['Live']['enabled'] ?? false,
      loading: json['Loading']['enabled'] ?? false,
      meal: json['Meal']['enabled'] ?? false,
      marriage: json['Marriage']['enabled'] ?? false,
      reel: json['Reel']['enabled'] ?? false,
      ride: json['Ride']['enabled'] ?? false,
      snap: json['Snap']['enabled'] ?? false,
      spotlight: json['Spotlight']['enabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Find': {'enabled': find},
      'Health': {'enabled': health},
      'Live': {'enabled': live},
      'Loading': {'enabled': loading},
      'Meal': {'enabled': meal},
      'Marriage': {'enabled': marriage},
      'Reel': {'enabled': reel},
      'Ride': {'enabled': ride},
      'Snap': {'enabled': snap},
      'Spotlight': {'enabled': spotlight},
    };
  }
}
