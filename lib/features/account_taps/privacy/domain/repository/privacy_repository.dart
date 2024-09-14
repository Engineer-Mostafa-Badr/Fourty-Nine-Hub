import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/privacy_entity.dart';

abstract class PrivacyRepository{
  Future<Either<Failure,PrivacyEntity>> fetchDataPrivacy();
}