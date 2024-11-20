import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/share_app/domain/entity/share_app_entity.dart';

abstract class ShareAppRepository{
  Future<Either<Failure,ShareAppEntity>> shareApp();
}