import 'package:dartz/dartz.dart';


import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/account_taps/contact_us/domain/entities/contact_us_entity.dart';

import '../../domain/repositories/contact_us_repo.dart';
import '../datasources/contact_us_remote_datasource.dart';
import '../models/contact_us_model.dart';

class ContactUsRepoImpl implements ContactUsRepo {
  final ContactUsRemoteDataSource _remoteDataSource;
  ContactUsRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, bool>> createContactUs(
      {required ContactUsModel item}) {
    return _remoteDataSource.createContactUs(item: item);
  }

  @override
  Future<Either<Failure, List<ContactUsEntity>>> getContactUsMessages() {
    return _remoteDataSource.getContactUsMessages();
  }
}
