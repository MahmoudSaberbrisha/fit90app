import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit90_gym_main/core/widgets/empty_widget.dart';
import 'package:fit90_gym_main/features/inbody/presentation/manager/news_cubit/all_inbody_cubit.dart';
import 'package:fit90_gym_main/features/spa/presentation/views/widgets/spa_list_item.dart';
import 'package:hive/hive.dart';

import '../../../../../../core/utils/constants.dart';
import '../../../../../../core/widgets/custom_loading_widget.dart';
import '../../../../auth/login/domain/entities/employee_entity.dart';

// ignore: must_be_immutable
class AllInbodyViewBody extends StatefulWidget {
  const AllInbodyViewBody({super.key});

  @override
  State<AllInbodyViewBody> createState() => _AllInbodyViewBodyState();
}

class _AllInbodyViewBodyState extends State<AllInbodyViewBody> {
  var box = Hive.box<EmployeeEntity>(kEmployeeDataBox);

  @override
  void initState() {
    _onInit();
    super.initState();
  }

  // @override
  // void dispose() {
  //   BlocProvider.of<NewsCubit>(context).close();
  //   super.dispose();
  // }

  void _onInit() async {
    // استخدام WidgetsBinding لتأخير الاستدعاء حتى يكون context جاهز
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        // استخدام نفس الـ API الخاص بالـ spa (لا يحتاج userId)
        await BlocProvider.of<AllInbodyCubit>(context).getAllInbody("");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //  getAllMessages(context);

    return BlocBuilder<AllInbodyCubit, AllInbodyState>(
      builder: (context, state) {
        if (state is FetchLoading) {
          return const Center(
            child: CustomLoadingWidget(
              loadingText: "جاري تحميل خدمات الـ inbody",
            ),
          );
        } else if (state is FetchSuccessful) {
          final allSpaList = state.data;

          // التحقق من أن القائمة فارغة
          if (allSpaList == null || allSpaList.isEmpty) {
            return const EmptyWidget(text: "لا توجد خدمات inbody متاحة");
          }

          // فلتر خفي: عرض الخدمات التي تحتوي على "inbody" في الاسم (arabicName أو englishName)
          final filteredSpaList = allSpaList.where((spa) {
            final arabicName = spa.arabicName?.toLowerCase() ?? "";
            final englishName = spa.englishName?.toLowerCase() ?? "";
            return arabicName.contains("inbody") ||
                englishName.contains("inbody");
          }).toList();

          if (filteredSpaList.isEmpty) {
            return const EmptyWidget(text: "لا توجد خدمات inbody متاحة");
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: filteredSpaList.length,
            itemBuilder: (context, index) {
              return SpaListItem(spa: filteredSpaList[index]);
            },
          );
        } else if (state is FetchFailed) {
          return EmptyWidget(text: state.message);
        } else {
          return const Center(
            child: CustomLoadingWidget(
              loadingText: "جاري تحميل خدمات الـ inbody",
            ),
          );
        }
      },
    );
  }
}
