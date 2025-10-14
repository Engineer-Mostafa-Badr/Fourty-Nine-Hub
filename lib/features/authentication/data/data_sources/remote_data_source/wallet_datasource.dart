import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/data/models/wallet_model.dart';

class WalletDataSource {
  final ApiConsumer _apiConsumer;
  Dio dio = Dio();
  WalletDataSource(this._apiConsumer);
  Future<Either<Failure, WalletModel>> getWallet() async {
    // var response = await dio.get(
    //   "https://9ad6cb01f298.ngrok-free.app/api/v1/main-wallet/66b4659d1c9c4b1cb35bfee4",
    //   options: Options(
    //     headers: {
    //       "Authorization":
    //           'Bearer ${"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjY4ZmJiMWYxLTIzNDgtNDQzOC1iNTk1LTNkOTk2MDJjMjlmYyIsImlhdCI6MTcyMzU3ODk1MCwiZXhwIjo1NTcyMzU3ODk1MCwic3ViIjoiNjZiNDY1OWQxYzljNGIxY2IzNWJmZWU0In0.tu8B1stXjAsJzalYyGXzDgl69InB9axF8z46zdiPIl4"}'
    //     },
    //   ),
    // );
    // log(response.data.toString(), name: "WalletDio");
    final result = await _apiConsumer
        .get("https://9ad6cb01f298.ngrok-free.app/api/v1/main-wallet/66b4659d1c9c4b1cb35bfee4");

    return result.fold((failure) {
      log(failure.toString(), name: "Walletfailure");
      return Left(failure);
    }, (response) {
      log(response['data'].toString(), name: "WalletData");
      final user = WalletModel.fromJson(
        response['data'],
      );
      return Right(user);
    });
  }
}
