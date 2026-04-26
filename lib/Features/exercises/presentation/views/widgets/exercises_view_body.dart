import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fit90_gym_main/features/exercises/data/models/my_messages_model/exercise.dart';
import 'package:fit90_gym_main/features/exercises/presentation/views/widgets/weekly_calendar_view.dart';
import 'package:hive/hive.dart';
import 'package:fit90_gym_main/core/widgets/empty_widget.dart';

import '../../../../../../core/utils/constants.dart';
import '../../../../../../core/widgets/custom_loading_widget.dart';
import '../../../../auth/login/domain/entities/employee_entity.dart';
import '../../manager/exercise_cubit/exercise_cubit.dart';

// ignore: must_be_immutable
class ExercisesViewBody extends StatefulWidget {
  const ExercisesViewBody({super.key});

  @override
  State<ExercisesViewBody> createState() => _ExercisesViewBodyState();
}

class _ExercisesViewBodyState extends State<ExercisesViewBody> {
  var box = Hive.box<EmployeeEntity>(kEmployeeDataBox);

  @override
  void initState() {
    _onInit();
    super.initState();
  }

  void _onInit() async {
    final employee = box.get(kEmployeeDataBox);
    if (employee != null && employee.memId != null) {
      // جلب الحصص مباشرة بدون تصنيفات
      WidgetsBinding.instance.addPostFrameCallback((_) {
        BlocProvider.of<ExerciseCubit>(context).getAllExercise("");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseCubit, ExerciseState>(
      builder: (context, state) {
        if (state is FetchLoading) {
          return const Center(
            child: CustomLoadingWidget(loadingText: "جاري تحميل الحصص"),
          );
        } else if (state is FetchSuccessful) {
          if (state.data == null || state.data!.isEmpty) {
            return const EmptyWidget(text: "لا توجد حصص متاحة");
          }

          AllExercisesList classesList = state.data!;

          // فلتر الحصص فقط (التي تحتوي على className)
          final filteredClasses = classesList
              .where(
                (item) => item.className != null && item.className!.isNotEmpty,
              )
              .toList();

          if (filteredClasses.isEmpty) {
            return const EmptyWidget(text: "لا توجد حصص متاحة");
          }

          return WeeklyCalendarView(classes: filteredClasses);
        } else if (state is FetchFailed) {
          return EmptyWidget(text: state.message);
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
