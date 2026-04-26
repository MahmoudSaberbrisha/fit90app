import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit90_gym_main/core/widgets/custom_loading_widget.dart';
import 'package:fit90_gym_main/core/widgets/empty_widget.dart';
import 'package:fit90_gym_main/features/spa/domain/entities/spa_entity.dart';
import 'package:fit90_gym_main/features/spa/presentation/manager/spa_cubit/spa_cubit.dart';
import 'package:fit90_gym_main/features/spa/presentation/views/widgets/spa_list_item.dart';

class SpaView extends StatefulWidget {
  const SpaView({super.key});

  @override
  State<SpaView> createState() => _SpaViewState();
}

class _SpaViewState extends State<SpaView> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Load spa services - استخدام WidgetsBinding لتأخير الاستدعاء حتى يكون context جاهز
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        BlocProvider.of<SpaCubit>(context).getAllSpaServices();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ال spa")),
      body: BlocBuilder<SpaCubit, SpaState>(
        builder: (context, state) {
          if (state is FetchLoading) {
            return const Center(
              child: CustomLoadingWidget(
                loadingText: "جاري تحميل خدمات الـ spa",
              ),
            );
          } else if (state is FetchSuccessful) {
            if (state.data == null || state.data!.isEmpty) {
              return const EmptyWidget(text: "لا توجد خدمات spa متاحة");
            }
            SpaList allSpaList = state.data!;

            // فلتر خفي: عرض الخدمات التي تحتوي على "spa" في الاسم (arabicName أو englishName)
            final filteredSpaList = allSpaList.where((spa) {
              final arabicName = spa.arabicName?.toLowerCase() ?? "";
              final englishName = spa.englishName?.toLowerCase() ?? "";
              return arabicName.contains("spa") || englishName.contains("spa");
            }).toList();

            if (filteredSpaList.isEmpty) {
              return const EmptyWidget(text: "لا توجد خدمات spa متاحة");
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
            // Initial state - show loading
            return const Center(
              child: CustomLoadingWidget(
                loadingText: "جاري تحميل خدمات الـ spa",
              ),
            );
          }
        },
      ),
    );
  }
}
