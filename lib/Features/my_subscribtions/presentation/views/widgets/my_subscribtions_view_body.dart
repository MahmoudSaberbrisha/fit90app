import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:fit90_gym_main/core/widgets/empty_widget.dart';
import 'package:fit90_gym_main/features/auth/login/domain/entities/employee_entity.dart';
import 'package:fit90_gym_main/features/my_subscribtions/data/models/my_messages_model/my_subscribtions.dart';
import 'package:fit90_gym_main/features/my_subscribtions/presentation/manager/ta3mem_cubit/my_subscribtions_cubit.dart';
import 'package:fit90_gym_main/features/my_subscribtions/presentation/views/widgets/my_subscribtions_list_item.dart';
import 'package:fit90_gym_main/features/personal_account/presentation/manager/cubit/get_profile_cubit.dart';

import '../../../../../../core/utils/constants.dart';
import '../../../../../../core/widgets/custom_loading_widget.dart';
import '../../../../../../core/widgets/error_text.dart';
import '../../../../bottom_nav/presentation/manger/cubit/bottom_nav_cubit.dart';

// ignore: must_be_immutable
class MySubscribtionsViewBody extends StatefulWidget {
  const MySubscribtionsViewBody({super.key});

  @override
  State<MySubscribtionsViewBody> createState() =>
      _MySubscribtionsViewBodyState();
}

class _MySubscribtionsViewBodyState extends State<MySubscribtionsViewBody> {
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
    // الحصول على memberId من بيانات المستخدم المسجل دخوله
    // نفس الطريقة المستخدمة في صفحة الملف الشخصي
    var box = Hive.box<EmployeeEntity>(kEmployeeDataBox);
    final employeeData = box.get(kEmployeeDataBox);
    final phone = employeeData?.phone?.toString();

    if (phone != null && phone.isNotEmpty) {
      // تنظيف رقم الهاتف قبل البحث
      String cleanPhone = phone.trim().replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
      print('MySubscribtions: Searching for member with phone: $cleanPhone');

      // جلب بيانات المستخدم من API أولاً
      await BlocProvider.of<GetProfileCubit>(context).getProfile(cleanPhone);
    } else {
      print('MySubscribtions: No phone number found in employee data');
      // Fallback: استخدام memId مباشرة من Hive
      int? memberId;
      if (employeeData != null && employeeData.memId != null) {
        try {
          memberId = int.tryParse(employeeData.memId!);
        } catch (e) {
          print('Error parsing memId: $e');
        }
      }
      await BlocProvider.of<MySubscribtionsCubit>(
        context,
      ).getMySubscribtions(memberId: memberId);
    }
  }

  @override
  Widget build(BuildContext context) {
    //  getAllMessages(context);

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
      child: SingleChildScrollView(
        child: BlocListener<GetProfileCubit, GetProfileState>(
          listener: (context, profileState) {
            // عندما يتم جلب بيانات المستخدم بنجاح، جلب الاشتراكات
            if (profileState is GetProfileSuccessful) {
              final employeeData = profileState.data.data;
              if (employeeData != null && employeeData.memId != null) {
                try {
                  final memberId = int.parse(employeeData.memId!);
                  print(
                    'MySubscribtions: Got memberId from profile: $memberId',
                  );
                  BlocProvider.of<MySubscribtionsCubit>(
                    context,
                  ).getMySubscribtions(memberId: memberId);
                } catch (e) {
                  print('Error parsing memId from profile: $e');
                }
              }
            }
          },
          child: BlocBuilder<MySubscribtionsCubit, MySubscribtionsState>(
            builder: (context, state) {
              if (state is FetchSuccessful) {
                AllSubscribtionsList ta3amemList = state.data!;

                return Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.data!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              kMySubscribtionsDetailsScreenRoute,
                            );
                            BlocProvider.of<BottomNavCubit>(
                              context,
                            ).getDetails(state.data![index]);
                          },
                          child: MySubscribtionsListItem(
                            ta3amemList: ta3amemList,
                            itemIndex: index,
                          ),
                        );
                      },
                    ),
                  ],
                );
              } else if (state is FetchLoading) {
                return const Center(
                  child: CustomLoadingWidget(
                    loadingText: "جاري تحميل الإشتراكات ",
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
      ),
    );
  }
}
