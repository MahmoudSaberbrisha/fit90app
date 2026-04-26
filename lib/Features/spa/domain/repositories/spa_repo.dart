import '../../data/data_sources/remote_data_source/spa_remote_data_source.dart';

abstract class SpaRepo {
  Future<SpaResponse> fetchAllSpaServices();
}

