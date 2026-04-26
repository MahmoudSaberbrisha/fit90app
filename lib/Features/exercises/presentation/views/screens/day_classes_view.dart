import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit90_gym_main/core/utils/gaps.dart';
import 'package:fit90_gym_main/core/widgets/custom_simple_app_bar.dart';
import 'package:fit90_gym_main/features/exercises/domain/entities/exercise_entity.dart';
import 'package:fit90_gym_main/features/exercises/presentation/views/widgets/day_class_item.dart';

class DayClassesView extends StatelessWidget {
  final String dayName;
  final List<ExerciseEntity> classes;

  const DayClassesView({
    super.key,
    required this.dayName,
    required this.classes,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: screenSize * .07,
        child: CustomSimpleAppBar(
          appBarTitle: "حصص $dayName",
          backHandler: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: classes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 64.sp, color: Colors.grey[400]),
                  Gaps.vGap12,
                  Text(
                    'لا توجد حصص في $dayName',
                    style: TextStyle(fontSize: 18.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: classes.length,
              itemBuilder: (context, index) {
                return DayClassItem(classData: classes[index]);
              },
            ),
    );
  }
}
