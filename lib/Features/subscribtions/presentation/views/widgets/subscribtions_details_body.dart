import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fit90_gym_main/core/utils/constants.dart';
import 'package:fit90_gym_main/core/utils/gaps.dart';
import 'package:fit90_gym_main/core/utils/image_utils.dart';
import 'package:fit90_gym_main/features/subscribtions/domain/entities/subscribtions_entity.dart';
import 'package:animate_do/animate_do.dart';

class SubscribtionsDetailsBody extends StatelessWidget {
  final SubscribtionsEntity subscribtionsEntity;

  const SubscribtionsDetailsBody({
    super.key,
    required this.subscribtionsEntity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, kPrimaryColor.withOpacity(0.05), Colors.white],
          stops: const [0.0, 0.3, 1.0],
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // الصورة الرئيسية
            FadeInDown(
              duration: const Duration(milliseconds: 600),
              child: Stack(
                children: [
                  Container(
                    height: 250.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.7)],
                      ),
                    ),
                    child: subscribtionsEntity.imagePath != null &&
                            subscribtionsEntity.imagePath.toString().isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: buildImageUrl(
                              subscribtionsEntity.imagePath.toString(),
                            ),
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Container(
                              color: kPrimaryColor.withOpacity(0.3),
                              child: Icon(
                                Icons.fitness_center,
                                size: 80.sp,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              color: kPrimaryColor.withOpacity(0.3),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: kPrimaryColor.withOpacity(0.3),
                            child: Icon(
                              Icons.fitness_center,
                              size: 80.sp,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                  ),
                  // زر الرجوع
                  Positioned(
                    top: 16.h,
                    left: 16.w,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          FontAwesomeIcons.circleArrowLeft,
                          size: 24.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // بطاقة السعر والمعلومات الأساسية
            FadeInUp(
              duration: const Duration(milliseconds: 700),
              delay: const Duration(milliseconds: 100),
              child: Transform.translate(
                offset: Offset(0, -30.h),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(color: Colors.black,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryColor.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // العنوان
                      Text(
                        subscribtionsEntity.title ?? "اشتراك غير محدد",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Gaps.vGap16,
                      // السعر
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              kPrimaryColor,
                              kPrimaryColor.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.attach_money,
                              color: Colors.white,
                              size: 28.sp,
                            ),
                            Gaps.hGap8,
                            Text(
                              subscribtionsEntity.price ?? "0",
                              style: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Gaps.hGap4,
                            Text(
                              "جنيه",
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Gaps.vGap20,

            // الوصف
            if (subscribtionsEntity.details != null &&
                subscribtionsEntity.details!.isNotEmpty)
              FadeInUp(
                duration: const Duration(milliseconds: 700),
                delay: const Duration(milliseconds: 200),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(color: Colors.black,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: kPrimaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.description_outlined,
                            color: kPrimaryColor,
                            size: 20.sp,
                          ),
                          Gaps.hGap8,
                          Text(
                            "الوصف",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
                            ),
                          ),
                        ],
                      ),
                      Gaps.vGap12,
                      Text(
                        subscribtionsEntity.details!,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.grey[700],
                          height: 1.6,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),

            Gaps.vGap20,

            // التفاصيل في Grid
            FadeInUp(
              duration: const Duration(milliseconds: 700),
              delay: const Duration(milliseconds: 300),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                kPrimaryColor,
                                kPrimaryColor.withOpacity(0.5),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                        Gaps.hGap12,
                        Text(
                          "تفاصيل الاشتراك",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                          ),
                        ),
                      ],
                    ),
                    Gaps.vGap16,
                    _buildDetailsGrid(context),
                  ],
                ),
              ),
            ),

            Gaps.vGap30,

            // زر الاشتراك
            FadeInUp(
              duration: const Duration(milliseconds: 700),
              delay: const Duration(milliseconds: 400),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryColor.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        kAddSubscribtionsScreen,
                        arguments: subscribtionsEntity,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60.h),
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        Gaps.hGap12,
                        Text(
                          'اشتراك الآن',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Gaps.vGap30,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsGrid(BuildContext context) {
    final details = [
      _DetailItem(
        icon: Icons.calendar_today_outlined,
        label: "عدد الأيام",
        value: "${subscribtionsEntity.numDays ?? "0"} يوم",
        color: Colors.blue,
      ),
      if (subscribtionsEntity.hesasNumsDaysNum != null &&
          subscribtionsEntity.hesasNumsDaysNum!.isNotEmpty)
        _DetailItem(
          icon: Icons.fitness_center_outlined,
          label: "عدد الحصص",
          value: "${subscribtionsEntity.hesasNumsDaysNum} يوم",
          color: Colors.purple,
        ),
      if (subscribtionsEntity.stoppedDaysNum != null &&
          subscribtionsEntity.stoppedDaysNum!.isNotEmpty)
        _DetailItem(
          icon: Icons.pause_circle_outline,
          label: "أيام الوقف",
          value: "${subscribtionsEntity.stoppedDaysNum} يوم",
          color: Colors.orange,
        ),
      if (subscribtionsEntity.spaDaysNum != null &&
          subscribtionsEntity.spaDaysNum!.isNotEmpty)
        _DetailItem(
          icon: Icons.spa_outlined,
          label: "أيام السبا",
          value: "${subscribtionsEntity.spaDaysNum} يوم",
          color: Colors.pink,
        ),
      if (subscribtionsEntity.invitationsCount != null &&
          subscribtionsEntity.invitationsCount!.isNotEmpty)
        _DetailItem(
          icon: Icons.person_add_outlined,
          label: "عدد الدعوات",
          value: subscribtionsEntity.invitationsCount!,
          color: Colors.green,
        ),
      if (subscribtionsEntity.inbodyCount != null &&
          subscribtionsEntity.inbodyCount!.isNotEmpty)
        _DetailItem(
          icon: Icons.analytics_outlined,
          label: "عدد Inbody",
          value: subscribtionsEntity.inbodyCount!,
          color: Colors.teal,
        ),
      if (subscribtionsEntity.points != null &&
          subscribtionsEntity.points!.isNotEmpty)
        _DetailItem(
          icon: Icons.stars_outlined,
          label: "النقاط",
          value: subscribtionsEntity.points!,
          color: Colors.amber,
        ),
      if (subscribtionsEntity.expireNumDays != null &&
          subscribtionsEntity.expireNumDays!.isNotEmpty)
        _DetailItem(
          icon: Icons.timer_outlined,
          label: "أيام الانتهاء",
          value: "${subscribtionsEntity.expireNumDays} يوم",
          color: Colors.red,
        ),
      if (subscribtionsEntity.target != null &&
          subscribtionsEntity.target!.isNotEmpty)
        _DetailItem(
          icon: Icons.flag_outlined,
          label: "الهدف",
          value: subscribtionsEntity.target!,
          color: Colors.indigo,
        ),
      if (subscribtionsEntity.specialToStd != null &&
          subscribtionsEntity.specialToStd!.isNotEmpty)
        _DetailItem(
          icon: Icons.school_outlined,
          label: "خاص للطلاب",
          value: subscribtionsEntity.specialToStd!,
          color: Colors.cyan,
        ),
      if (subscribtionsEntity.student != null &&
          subscribtionsEntity.student!.isNotEmpty)
        _DetailItem(
          icon: Icons.person_outline,
          label: "الطالب",
          value: subscribtionsEntity.student == "1" ? "نعم" : "لا",
          color: Colors.deepPurple,
        ),
      if (subscribtionsEntity.specialOffer != null &&
          subscribtionsEntity.specialOffer!.isNotEmpty)
        _DetailItem(
          icon: Icons.local_offer_outlined,
          label: "عرض خاص",
          value: subscribtionsEntity.specialOffer == "1" ? "نعم" : "لا",
          color: Colors.deepOrange,
        ),
      if (subscribtionsEntity.approved != null &&
          subscribtionsEntity.approved!.isNotEmpty)
        _DetailItem(
          icon: Icons.verified_outlined,
          label: "معتمد",
          value: subscribtionsEntity.approved == "1" ? "نعم" : "لا",
          color: Colors.green,
        ),
      if (subscribtionsEntity.active != null &&
          subscribtionsEntity.active!.isNotEmpty)
        _DetailItem(
          icon: Icons.power_settings_new_outlined,
          label: "نشط",
          value: subscribtionsEntity.active == "1" ? "نعم" : "لا",
          color: subscribtionsEntity.active == "1" ? Colors.green : Colors.grey,
        ),
      if (subscribtionsEntity.haletEshtrak != null &&
          subscribtionsEntity.haletEshtrak!.isNotEmpty)
        _DetailItem(
          icon: Icons.info_outline,
          label: "حالة الاشتراك",
          value: subscribtionsEntity.haletEshtrak!,
          color: Colors.blueGrey,
        ),
      if (subscribtionsEntity.priceBar != null)
        _DetailItem(
          icon: Icons.attach_money_outlined,
          label: "السعر (بار)",
          value: "${subscribtionsEntity.priceBar}",
          color: Colors.brown,
        ),
      if (subscribtionsEntity.priceTanta != null)
        _DetailItem(
          icon: Icons.attach_money_outlined,
          label: "السعر (طنطا)",
          value: "${subscribtionsEntity.priceTanta}",
          color: Colors.brown,
        ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: MediaQuery.of(context).size.width > 600 ? 1.2 : 1.1,
      ),
      itemCount: details.length,
      itemBuilder: (context, index) {
        return _buildDetailCard(details[index]);
      },
    );
  }

  Widget _buildDetailCard(_DetailItem item) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: Colors.black,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: item.color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: item.color.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(item.icon, color: item.color, size: 28.sp),
          ),
          Gaps.vGap12,
          Text(
            item.label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Gaps.vGap4,
          Text(
            item.value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _DetailItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

