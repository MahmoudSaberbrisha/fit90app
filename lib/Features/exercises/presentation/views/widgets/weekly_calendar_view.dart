import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit90_gym_main/core/utils/constants.dart';
import 'package:fit90_gym_main/core/utils/gaps.dart';
import 'package:fit90_gym_main/features/exercises/domain/entities/exercise_entity.dart';

class WeeklyCalendarView extends StatefulWidget {
  final List<ExerciseEntity> classes;

  const WeeklyCalendarView({super.key, required this.classes});

  @override
  State<WeeklyCalendarView> createState() => _WeeklyCalendarViewState();
}

class _WeeklyCalendarViewState extends State<WeeklyCalendarView> {
  int? _selectedDayIndex; // 0 = السبت, 1 = الأحد, ..., 6 = الجمعة

  // الحصول على يوم الأسبوع من التاريخ (0 = السبت, 1 = الأحد, ..., 6 = الجمعة)
  int _getDayOfWeek(String? dateString) {
    if (dateString == null || dateString.isEmpty) return -1;
    try {
      final date = DateTime.parse(dateString);
      // DateTime.weekday: 1 = Monday, 7 = Sunday
      // نحتاج: 0 = Saturday, 1 = Sunday, ..., 6 = Friday
      int weekday = date.weekday;
      // تحويل: Monday(1) -> 2, Tuesday(2) -> 3, ..., Sunday(7) -> 1
      // ثم: 1 -> 1, 2 -> 2, 3 -> 3, 4 -> 4, 5 -> 5, 6 -> 6, 7 -> 0
      int dayIndex = (weekday + 1) % 7;
      return dayIndex;
    } catch (e) {
      return -1;
    }
  }

  List<ExerciseEntity> _getClassesForDay(int dayIndex) {
    return widget.classes.where((classItem) {
      final dayOfWeek = _getDayOfWeek(classItem.classDate);
      return dayOfWeek == dayIndex;
    }).toList();
  }

  String _getDayName(int dayIndex) {
    final days = [
      'السبت',
      'الأحد',
      'الإثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
    ];
    return days[dayIndex];
  }

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return "";
    try {
      if (time.length >= 5) {
        return time.substring(0, 5);
      }
      return time;
    } catch (e) {
      return time;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'scheduled':
        return Colors.blue;
      case 'ongoing':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(12.w),
      itemCount: 7,
      itemBuilder: (context, index) {
        final classesForDay = _getClassesForDay(index);

        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(color: Colors.black,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey[300]!, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Day header (always visible)
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    kDayClassesScreenRoute,
                    arguments: {
                      'dayName': _getDayName(index),
                      'classes': classesForDay,
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: kPrimaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.calendar_today,
                                color: kPrimaryColor,
                                size: 24.sp,
                              ),
                            ),
                            Gaps.hGap16,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getDayName(index),
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[900],
                                    ),
                                  ),
                                  Gaps.vGap4,
                                  Text(
                                    '${classesForDay.length} حصة',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: kPrimaryColor,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClassItem(ExerciseEntity classItem) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h, left: 16.w, right: 16.w, top: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Class name and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  classItem.className ?? "حصة غير محددة",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(classItem.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  _getStatusText(classItem.status),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: _getStatusColor(classItem.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          if (classItem.description != null &&
              classItem.description!.isNotEmpty) ...[
            Gaps.vGap8,
            Text(
              classItem.description!,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
          ],

          Gaps.vGap12,

          // Details row
          Wrap(
            spacing: 16.w,
            runSpacing: 8.h,
            children: [
              if (classItem.trainer != null && classItem.trainer!.name != null)
                _buildDetailChip(
                  icon: Icons.person_outline,
                  text: classItem.trainer!.name!,
                ),
              if (classItem.startTime != null && classItem.endTime != null)
                _buildDetailChip(
                  icon: Icons.access_time_outlined,
                  text:
                      "${_formatTime(classItem.startTime)} - ${_formatTime(classItem.endTime)}",
                ),
              if (classItem.branch != null)
                _buildDetailChip(
                  icon: Icons.location_on_outlined,
                  text: classItem.branch!.arabicName ??
                      classItem.branch!.englishName ??
                      "غير محدد",
                ),
              if (classItem.maxCapacity != null)
                _buildDetailChip(
                  icon: Icons.people_outline,
                  text:
                      "${classItem.currentEnrollments ?? 0}/${classItem.maxCapacity}",
                ),
            ],
          ),

          // Price
          if (classItem.price != null && classItem.price! > 0) ...[
            Gaps.vGap8,
            Row(
              children: [
                Icon(
                  Icons.attach_money_outlined,
                  size: 16.sp,
                  color: Colors.amber[700],
                ),
                Gaps.hGap4,
                Text(
                  "${classItem.price!.toStringAsFixed(2)} جنيه",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[900],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailChip({required IconData icon, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.sp, color: Colors.grey[600]),
        Gaps.hGap4,
        Text(
          text,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
        ),
      ],
    );
  }

  String _getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'scheduled':
        return 'مجدولة';
      case 'ongoing':
        return 'جارية';
      case 'completed':
        return 'مكتملة';
      case 'cancelled':
        return 'ملغاة';
      default:
        return status ?? 'غير محدد';
    }
  }
}

