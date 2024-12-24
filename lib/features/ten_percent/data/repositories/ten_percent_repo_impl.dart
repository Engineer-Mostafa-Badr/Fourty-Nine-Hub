import '../../domain/repositories/ten_percent_repo.dart';
import '../datasources/ad_requests_remote_data_source.dart';

class TenPercentRepoImpl implements TenPercentRepo {
  final TenPercentRemoteDataSource _remoteDataSource;
  TenPercentRepoImpl(this._remoteDataSource);

}
