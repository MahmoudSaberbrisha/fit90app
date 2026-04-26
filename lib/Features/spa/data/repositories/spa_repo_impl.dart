import '../../domain/repositories/spa_repo.dart';
import '../data_sources/remote_data_source/spa_remote_data_source.dart';

class SpaRepositoryImpl extends SpaRepo {
  final SpaRemoteDataSource spaRemoteDataSource;

  SpaRepositoryImpl(this.spaRemoteDataSource);

  @override
  Future<SpaResponse> fetchAllSpaServices() async {
    return await spaRemoteDataSource.fetchAllSpaServices();
  }
}

