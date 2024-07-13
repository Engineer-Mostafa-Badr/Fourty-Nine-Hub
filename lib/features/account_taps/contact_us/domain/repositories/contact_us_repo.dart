import 'package:dartz/dartz.dart';


import '../../../../../core/error/failure.dart';
import '../../data/models/contact_us_model.dart';
import '../entities/contact_us_entity.dart';

abstract class ContactUsRepo {
  Future<Either<Failure, bool>> createContactUs({required ContactUsModel item});
  Future<Either<Failure, List<ContactUsEntity>>> getContactUsMessages();
}