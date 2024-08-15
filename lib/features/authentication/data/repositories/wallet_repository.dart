import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/data/data_sources/remote_data_source/wallet_data_source.dart';
import 'package:fourtyninehub/features/authentication/data/models/wallet_model.dart';

class WalletRepository {
  WalletDataSource dataSource;
  WalletRepository(this.dataSource);
  Future<Either<Failure, WalletModel>> getWallet() {
    log("4444444444444444444444444444");
    return dataSource.getWallet();
  }
}
