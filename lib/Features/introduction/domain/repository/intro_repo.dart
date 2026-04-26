import 'package:fit90_gym_main/features/introduction/data/dat_source/remote_data_source/all_intro_remote_data_source.dart';

abstract class IntroRepository {
  Future<AllIntroResponse> fetchAllServices();
}
