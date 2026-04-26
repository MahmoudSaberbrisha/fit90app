import '../../data/data_sources/remote_data_source/spa_remote_data_source.dart';
import '../repositories/spa_repo.dart';

abstract class UseCase<type, Param> {
  Future<SpaResponse> callAllSpaServices();
}

class SpaUseCase extends UseCase<void, void> {
  final SpaRepo spaRepository;
  SpaUseCase(this.spaRepository);
  
  @override
  Future<SpaResponse> callAllSpaServices() async {
    return await spaRepository.fetchAllSpaServices();
  }
}

