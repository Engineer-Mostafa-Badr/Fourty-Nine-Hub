import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/account_taps/contact_us/data/models/contact_us_model.dart';
import 'package:fourtyninehub/features/account_taps/contact_us/domain/entities/contact_us_entity.dart';
import '../../../../../core/error/failure.dart';

abstract class ContactUsRemoteDataSource {
  Future<Either<Failure, bool>> createContactUs({required ContactUsModel item});
  Future<Either<Failure, List<ContactUsEntity>>> getContactUsMessages();
}

class ContactUsRemoteDataSourceImpl implements ContactUsRemoteDataSource {
  final ApiConsumer _apiConsumer;
  ContactUsRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, bool>> createContactUs(
      {required ContactUsModel item}) async {
    final response =
        await _apiConsumer.post(EndPoints.contactUs, data: item.toJson());
    return response.fold(
        (l) => Left(l), (data) => Right(data['status'] as bool));
  }

  @override
  Future<Either<Failure, List<ContactUsEntity>>> getContactUsMessages() async {
    final response = await _apiConsumer.get(
      EndPoints.helpMessages,
    );
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data']['docs'] as List)
            .map((e) => ContactUsModel.fromJson(e))
            .toList()));
  }
}
