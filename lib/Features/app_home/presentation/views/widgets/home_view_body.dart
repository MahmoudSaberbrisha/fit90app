import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit90_gym_main/core/utils/constants.dart';
import 'package:fit90_gym_main/features/app_home/presentation/views/widgets/app_bar_home.dart';
import 'package:fit90_gym_main/features/auth/login/domain/entities/employee_entity.dart';
import 'package:fit90_gym_main/features/bottom_nav/presentation/manger/cubit/bottom_nav_cubit.dart';
import 'package:fit90_gym_main/Features/offers/presentation/views/widgets/offers_view_body.dart';
import 'package:fit90_gym_main/core/utils/image_utils.dart';
import 'package:hive/hive.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/utils/gaps.dart';
import '../../manger/ads_cubit/ads_cubit.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    var box = Hive.box<EmployeeEntity>(kEmployeeDataBox);
    int index = 0;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Gaps.vGap10,
            FadeInDown(
              duration: const Duration(milliseconds: 600),
              child: AppBarHome(box: box),
            ),
            Gaps.vGap20,
            FadeInUp(
              duration: const Duration(milliseconds: 700),
              delay: const Duration(milliseconds: 100),
              child: BlocBuilder<AdsCubit, AdsState>(
                builder: (context, state) {
                  if (state is FetchAdsLoading) {
                    return Container(
                      height: 150.h,
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is FetchAdsFailed) {
                    return const SizedBox();
                  } else if (state is FetchAdsSuccessful) {
                    // التحقق من أن البيانات موجودة وليست فارغة
                    if (state.data == null || state.data!.isEmpty) {
                      return const SizedBox();
                    }

                    List<String> data = [];

                    for (int i = 0; i < state.data!.length; i++) {
                      final ad = state.data![i];
                      final imagePath = ad.imagePath;
                      if (imagePath != null && imagePath.isNotEmpty) {
                        data.add(buildImageUrl(imagePath));
                      }
                    }

                    // إذا لم تكن هناك صور صالحة، لا نعرض شيء
                    if (data.isEmpty) {
                      return const SizedBox();
                    }

                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, kAdsDetailsScreenRoute);

                        // state.data ليس null بعد التحقق في السطر 40
                        if (index < state.data!.length) {
                          BlocProvider.of<BottomNavCubit>(
                            context,
                          ).getDetails(state.data![index]);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: kPrimaryColor.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: CarouselSlider(
                          items: data.map((offer) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24.r),
                                    color: Colors.black,
                                    image: DecorationImage(
                                      image: NetworkImage(offer),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(0.5),
                                        BlendMode.darken,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                          options: CarouselOptions(
                            viewportFraction: 0.9,
                            autoPlay: true,
                            height: 160.h,
                            autoPlayInterval: const Duration(seconds: 4),
                            autoPlayAnimationDuration: const Duration(
                              milliseconds: 800,
                            ),
                            enlargeCenterPage: true,
                            onPageChanged: (val, _) {
                              index = val;
                            },
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),

            Gaps.vGap30,
            // عنوان القسم
            FadeInLeft(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 200),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
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
                    const Text(
                      'الخدمات',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Gaps.vGap20,

            // الأزرار مع animations
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  // الصف الأول: العروض، المدربين، الاشتراكات
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 300),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildModernButton(
                          context: context,
                          onTap: () {
                            Navigator.pushNamed(context, kOffersScreenRoute);
                          },
                          label: 'العروض',
                          image: "assets/images/Frame (4).svg",
                          index: 0,
                        ),
                        _buildModernButton(
                          context: context,
                          onTap: () {
                            Navigator.pushNamed(context, kCaptainsScreenRoute);
                          },
                          label: 'المدربين',
                          image: "assets/images/Frame (3).svg",
                          index: 1,
                        ),
                        _buildModernButton(
                          context: context,
                          onTap: () {
                            Navigator.pushNamed(context, kSubscribtionsScreen);
                          },
                          label: 'الإشتراكات',
                          image: "assets/images/Frame (2).svg",
                          index: 2,
                        ),
                      ],
                    ),
                  ),
                  Gaps.vGap20,
                  // الصف الثاني: الحصص، ال spa، ال inbody
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 400),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildModernButton(
                          context: context,
                          onTap: () {
                            Navigator.pushNamed(context, kExercisesScreenRoute);
                          },
                          label: 'الحصص',
                          image: "assets/images/Frame (1).svg",
                          index: 3,
                        ),
                        _buildModernButton(
                          context: context,
                          onTap: () {
                            Navigator.pushNamed(context, kSpaScreenRoute);
                          },
                          label: 'ال spa',
                          image: "assets/images/Frame (5).svg",
                          index: 4,
                        ),
                        _buildModernButton(
                          context: context,
                          onTap: () {
                            Navigator.pushNamed(context, kAllIndodyScreenRoute);
                          },
                          label: 'ال inbody',
                          image: "assets/images/Frame (5).svg",
                          index: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Gaps.vGap30,
            // عنوان قسم "ما يميزنا"
            FadeInLeft(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 500),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        const Text(
                          'ما يميزنا',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, kOffersScreenRoute);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              kPrimaryColor,
                              kPrimaryColor.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          'عرض المزيد',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Gaps.vGap20,

            // const TabButtonListView(paymentMethodItems: [
            //   'التمارين',
            //   'المدربين',
            //   'الإشتراكات',
            //   'العروض',
            // ]),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 600),
              child: const OffersViewBody(home: true),
            ),
            Gaps.vGap100,
          ],
        ),
      ),
    );
  }

  Widget _buildModernButton({
    required BuildContext context,
    required VoidCallback onTap,
    required String label,
    required String image,
    required int index,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.26,
              height: 110.h,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: kPrimaryColor.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.05),
                    blurRadius: 15,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
                    ),
                    child: SvgPicture.asset(
                      image,
                      width: 40.w,
                      height: 40.h,
                      colorFilter: ColorFilter.mode(
                        kPrimaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Gaps.vGap8,
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Container slider(BuildContext context) {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Image.asset("assets/images/slider.png", fit: BoxFit.fill),
    );
  }
}
