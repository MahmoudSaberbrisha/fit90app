// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:fit90_gym_main/features/spa/domain/entities/spa_entity.dart';

import '../../../domain/use_cases/spa_use_case.dart';

part 'spa_state.dart';

class SpaCubit extends Cubit<SpaState> {
  SpaUseCase spaUseCase;
  SpaCubit(this.spaUseCase) : super(SpaInitial());

  Future<void> getAllSpaServices() async {
    if (isClosed) return;
    emit(FetchLoading());

    final result = await spaUseCase.callAllSpaServices();

    // التحقق من أن الـ Cubit لم يتم إغلاقه قبل emit حالة جديدة
    if (!isClosed) {
      emit(result.fold(FetchFailed.new, FetchSuccessful.new));
    }
  }
}
