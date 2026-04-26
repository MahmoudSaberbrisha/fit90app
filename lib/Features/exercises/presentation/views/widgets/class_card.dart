import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit90_gym_main/core/utils/gaps.dart';
import 'package:fit90_gym_main/features/exercises/domain/entities/exercise_entity.dart';
import 'package:intl/intl.dart';

class ClassCard extends StatelessWidget {
  const ClassCard({super.key, required this.classData});
  final ExerciseEntity classData;

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

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return "";
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('yyyy-MM-dd', 'ar').format(parsedDate);
    } catch (e) {
      return date;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(color: Colors.black,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            // يمكن إضافة navigation للتفاصيل لاحقاً
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // العنوان والحالة
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            classData.className ?? "حصة غير محددة",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
                            ),
                          ),
                          if (classData.description != null &&
                              classData.description!.isNotEmpty) ...[
                            Gaps.vGap4,
                            Text(
                              classData.description!,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          classData.status,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: _getStatusColor(
                            classData.status,
                          ).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _getStatusText(classData.status),
                        style: TextStyle(
                          color: _getStatusColor(classData.status),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                Gaps.vGap16,

                // تفاصيل الحصة في Grid
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      // الصف الأول: المدرب والفرع
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailItem(
                              icon: Icons.person_outline,
                              iconColor: Colors.blue,
                              label: "المدرب",
                              value: classData.trainer?.name ?? "غير محدد",
                            ),
                          ),
                          Expanded(
                            child: _buildDetailItem(
                              icon: Icons.location_on_outlined,
                              iconColor: Colors.red,
                              label: "الفرع",
                              value: classData.branch?.arabicName ??
                                  classData.branch?.englishName ??
                                  "غير محدد",
                            ),
                          ),
                        ],
                      ),

                      Gaps.vGap12,

                      // الصف الثاني: التاريخ والوقت
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailItem(
                              icon: Icons.calendar_today_outlined,
                              iconColor: Colors.orange,
                              label: "التاريخ",
                              value: _formatDate(classData.classDate),
                            ),
                          ),
                          Expanded(
                            child: _buildDetailItem(
                              icon: Icons.access_time_outlined,
                              iconColor: Colors.purple,
                              label: "الوقت",
                              value: classData.startTime != null &&
                                      classData.endTime != null
                                  ? "${_formatTime(classData.startTime)} - ${_formatTime(classData.endTime)}"
                                  : "غير محدد",
                            ),
                          ),
                        ],
                      ),

                      Gaps.vGap12,

                      // الصف الثالث: السعة والسعر
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailItem(
                              icon: Icons.people_outline,
                              iconColor: Colors.green,
                              label: "السعة",
                              value:
                                  "${classData.currentEnrollments ?? 0}/${classData.maxCapacity ?? 0}",
                            ),
                          ),
                          if (classData.price != null && classData.price! > 0)
                            Expanded(
                              child: _buildDetailItem(
                                icon: Icons.attach_money_outlined,
                                iconColor: Colors.amber,
                                label: "السعر",
                                value:
                                    "${classData.price!.toStringAsFixed(2)} جنيه",
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // الملاحظات
                if (classData.notes != null && classData.notes!.isNotEmpty) ...[
                  Gaps.vGap12,
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: Colors.amber.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.note_outlined,
                          size: 20.sp,
                          color: Colors.amber[700],
                        ),
                        Gaps.hGap8,
                        Expanded(
                          child: Text(
                            classData.notes!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.amber[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 18.sp, color: iconColor),
        ),
        Gaps.hGap8,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

