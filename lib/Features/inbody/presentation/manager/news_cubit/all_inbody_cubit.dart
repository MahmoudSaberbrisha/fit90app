// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:fit90_gym_main/features/spa/domain/entities/spa_entity.dart';

import '../../../domain/use_cases/all_inbody_use_case.dart';

part 'all_inbody_state.dart';

class AllInbodyCubit extends Cubit<AllInbodyState> {
  AllInbodyUseCase allInbodyUseCase;
  AllInbodyCubit(this.allInbodyUseCase) : super(AllInbodyInitial());

  Future<void> getAllInbody(String userId) async {
    if (isClosed) return;
    emit(const FetchLoading());

    final result = await allInbodyUseCase.callAllInbody(userId);

    // التحقق من أن الـ Cubit لم يتم إغلاقه قبل emit حالة جديدة
    if (!isClosed) {
      emit(result.fold(FetchFailed.new, FetchSuccessful.new));
    }
  }
}
