import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit90_gym_main/core/utils/gaps.dart';
import 'package:fit90_gym_main/features/exercises/domain/entities/exercise_entity.dart';

class DayClassItem extends StatelessWidget {
  final ExerciseEntity classData;

  const DayClassItem({super.key, required this.classData});

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
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Class name and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  classData.className ?? "حصة غير محددة",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(classData.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: _getStatusColor(classData.status).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  _getStatusText(classData.status),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: _getStatusColor(classData.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          if (classData.description != null &&
              classData.description!.isNotEmpty) ...[
            Gaps.vGap12,
            Text(
              classData.description!,
              style: TextStyle(fontSize: 15.sp, color: Colors.grey[600]),
            ),
          ],

          Gaps.vGap16,

          // Details in rows
          _buildDetailRow(
            icon: Icons.person_outline,
            iconColor: Colors.blue,
            label: "المدرب",
            value: classData.trainer?.name ?? "غير محدد",
          ),

          Gaps.vGap12,

          _buildDetailRow(
            icon: Icons.access_time_outlined,
            iconColor: Colors.purple,
            label: "الوقت",
            value: classData.startTime != null && classData.endTime != null
                ? "${_formatTime(classData.startTime)} - ${_formatTime(classData.endTime)}"
                : "غير محدد",
          ),

          Gaps.vGap12,

          _buildDetailRow(
            icon: Icons.people_outline,
            iconColor: Colors.green,
            label: "العدد",
            value:
                "${classData.currentEnrollments ?? 0}/${classData.maxCapacity ?? 0}",
          ),

          if (classData.price != null && classData.price! > 0) ...[
            Gaps.vGap12,
            _buildDetailRow(
              icon: Icons.attach_money_outlined,
              iconColor: Colors.amber,
              label: "السعر",
              value: "${classData.price!.toStringAsFixed(2)} جنيه",
            ),
          ],

          if (classData.branch != null) ...[
            Gaps.vGap12,
            _buildDetailRow(
              icon: Icons.location_on_outlined,
              iconColor: Colors.red,
              label: "الفرع",
              value: classData.branch!.arabicName ??
                  classData.branch!.englishName ??
                  "غير محدد",
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 20.sp, color: iconColor),
        ),
        Gaps.hGap12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

