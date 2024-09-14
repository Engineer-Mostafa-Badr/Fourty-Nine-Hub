import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';

abstract class SettingRepository{
  Future<Either<Failure,bool>> deleteAccount();
}