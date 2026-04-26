import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit90_gym_main/core/widgets/empty_widget.dart';
import 'package:fit90_gym_main/features/subscribtions/data/models/my_messages_model/subscribtions.dart';
import 'package:fit90_gym_main/features/subscribtions/presentation/manager/ta3mem_cubit/subscribtions_cubit.dart';
import 'package:fit90_gym_main/features/subscribtions/presentation/views/widgets/all_subscribtions_list_item.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../../../core/utils/constants.dart';
import '../../../../../../core/widgets/custom_loading_widget.dart';
import '../../../../../../core/widgets/error_text.dart';
import '../../../../bottom_nav/presentation/manger/cubit/bottom_nav_cubit.dart';

// ignore: must_be_immutable
class SubscribtionsViewBody extends StatefulWidget {
  const SubscribtionsViewBody({super.key});

  @override
  State<SubscribtionsViewBody> createState() => _SubscribtionsViewBodyState();
}

class _SubscribtionsViewBodyState extends State<SubscribtionsViewBody> {
  @override
  void initState() {
    _onInit();
    super.initState();
  }

  @override
  void dispose() {
    // BlocProvider.of<MosalatCubit>(context).close();
    super.dispose();
  }

  void _onInit() async {
    await BlocProvider.of<SubscribtionsCubit>(context).getAllMosalat();
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // تكيف عدد الأعمدة حسب عرض الشاشة
    if (width > 600) {
      return 4; // شاشات كبيرة (tablets)
    } else if (width > 400) {
      return 3; // شاشات متوسطة
    } else {
      return 2; // شاشات صغيرة
    }
  }

  double _getChildAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // تكيف نسبة العرض إلى الارتفاع حسب حجم الشاشة
    if (width > 600) {
      return 0.75; // شاشات كبيرة
    } else if (width > 400) {
      return 0.8; // شاشات متوسطة
    } else {
      return 0.85; // شاشات صغيرة
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, kPrimaryColor.withOpacity(0.03), Colors.white],
          stops: const [0.0, 0.3, 1.0],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: BlocBuilder<SubscribtionsCubit, SubscribtionsState>(
          builder: (context, state) {
            if (state is FetchSuccessful) {
              AllSubscribtionsList ta3amemList = state.data!;

              if (ta3amemList.isEmpty) {
                return const EmptyWidget(text: "لا توجد اشتراكات متاحة");
              }

              return GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _getCrossAxisCount(context),
                  mainAxisSpacing: 16.h,
                  crossAxisSpacing: 16.w,
                  childAspectRatio: _getChildAspectRatio(context),
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: ta3amemList.length,
                itemBuilder: (context, index) {
                  return FadeInUp(
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    delay: Duration(milliseconds: index * 50),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          kSubscribtionsDetailsScreenRoute,
                        );
                        BlocProvider.of<BottomNavCubit>(
                          context,
                        ).getDetails(ta3amemList[index]);
                      },
                      child: AllSubscribtionsListItem(
                        ta3amemList: ta3amemList,
                        itemIndex: index,
                      ),
                    ),
                  );
                },
              );
            } else if (state is FetchLoading) {
              return const Center(
                child: CustomLoadingWidget(
                  loadingText: "جاري تحميل الإشتراكات",
                ),
              );
            } else if (state is FetchFailed) {
              return EmptyWidget(text: state.message);
            } else {
              return const ErrorText(text: "حدث خطأ ما");
            }
          },
        ),
      ),
    );
  }
}
