import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fit90_gym_main/core/utils/constants.dart';
import 'package:fit90_gym_main/core/utils/gaps.dart';
import 'package:fit90_gym_main/features/exercises/domain/entities/exercise_entity.dart';
import 'package:fit90_gym_main/core/utils/image_utils.dart';
import 'package:intl/intl.dart';

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({super.key, required this.offersList});
  final ExerciseEntity offersList;

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return "";
    try {
      // إذا كان الوقت بصيغة HH:mm:ss، نأخذ فقط HH:mm
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
    // إذا كانت البيانات من Classes API (تحتوي على className)
    final isClassData = offersList.className != null;

    if (isClassData) {
      // عرض تفاصيل الحصة الكاملة
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان والحالة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      offersList.className ??
                          offersList.title ??
                          "حصة غير محددة",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        offersList.status,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusText(offersList.status),
                      style: TextStyle(
                        color: _getStatusColor(offersList.status),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // الوصف
              if (offersList.description != null &&
                  offersList.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  offersList.description!,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],

              const SizedBox(height: 12),

              // تفاصيل الحصة
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  // المدرب
                  if (offersList.trainer != null &&
                      offersList.trainer!.name != null)
                    _buildInfoRow(
                      icon: Icons.person,
                      label: "المدرب",
                      value: offersList.trainer!.name!,
                    ),

                  // التاريخ
                  if (offersList.classDate != null)
                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      label: "التاريخ",
                      value: _formatDate(offersList.classDate),
                    ),

                  // الوقت
                  if (offersList.startTime != null &&
                      offersList.endTime != null)
                    _buildInfoRow(
                      icon: Icons.access_time,
                      label: "الوقت",
                      value:
                          "${_formatTime(offersList.startTime)} - ${_formatTime(offersList.endTime)}",
                    ),

                  // الفرع
                  if (offersList.branch != null)
                    _buildInfoRow(
                      icon: Icons.location_on,
                      label: "الفرع",
                      value: offersList.branch!.arabicName ??
                          offersList.branch!.englishName ??
                          "غير محدد",
                    ),

                  // السعة
                  if (offersList.maxCapacity != null)
                    _buildInfoRow(
                      icon: Icons.people,
                      label: "السعة",
                      value:
                          "${offersList.currentEnrollments ?? 0}/${offersList.maxCapacity}",
                    ),

                  // السعر
                  if (offersList.price != null && offersList.price! > 0)
                    _buildInfoRow(
                      icon: Icons.attach_money,
                      label: "السعر",
                      value: "${offersList.price!.toStringAsFixed(2)} جنيه",
                    ),
                ],
              ),

              // الملاحظات
              if (offersList.notes != null && offersList.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.note, size: 20, color: Colors.amber),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          offersList.notes!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // الأعضاء المسجلين
              if (offersList.enrollments != null &&
                  offersList.enrollments!.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  "الأعضاء المسجلين (${offersList.enrollments!.length})",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: offersList.enrollments!.map((enrollment) {
                    return Chip(
                      label: Text(
                        enrollment.member?.name ??
                            enrollment.member?.memberCode ??
                            "عضو غير معروف",
                        style: const TextStyle(fontSize: 12),
                      ),
                      avatar: const Icon(Icons.person, size: 16),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      );
    } else {
      // عرض البيانات القديمة (التمارين)
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              height: 120,
              width: MediaQuery.of(context).size.width * .25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: CachedNetworkImage(
                errorWidget: (context, url, error) =>
                    Icon(Icons.person, color: kPrimaryColor),
                progressIndicatorBuilder: (context, url, progress) => Center(
                  child: CircularProgressIndicator(
                    value: progress.progress,
                    color: kPrimaryColor,
                  ),
                ),
                imageUrl: buildImageUrl(offersList.mainImage),
                height: 120,
                width: 100,
                fit: BoxFit.contain,
              ),
            ),
            Gaps.hGap5,
            SizedBox(
              width: MediaQuery.of(context).size.width * .6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    offersList.title ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset("assets/images/calories.svg"),
                      Gaps.hGap4,
                      Text(
                        '${offersList.tkrar ?? ""} مرة  ',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      Gaps.hGap5,
                      const Text(
                        "|",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Gaps.hGap5,
                      SvgPicture.asset("assets/images/clock.svg"),
                      Gaps.hGap4,
                      Text(
                        '${offersList.restInSec ?? ""} ثانية',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${offersList.tamrenFor ?? ""} ',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          "$label: ",
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    );
  }
}
