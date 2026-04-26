import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit90_gym_main/core/utils/constants.dart';
import 'package:fit90_gym_main/core/utils/gaps.dart';
import 'package:fit90_gym_main/core/widgets/custom_loading_widget.dart';
import 'package:fit90_gym_main/core/widgets/empty_widget.dart';
import 'package:fit90_gym_main/features/inbody/presentation/views/widgets/all_inbody_view_body.dart';
import 'package:fit90_gym_main/features/spa/domain/entities/spa_entity.dart';
import 'package:fit90_gym_main/features/spa/presentation/manager/spa_cubit/spa_cubit.dart';
import 'package:fit90_gym_main/features/spa/presentation/views/widgets/spa_list_item.dart';
import 'package:hive/hive.dart';
import '../../../../auth/login/domain/entities/employee_entity.dart';
import '../../../../inbody/presentation/manager/news_cubit/all_inbody_cubit.dart'
    as inbody_cubit;

class SpaAndInbodyView extends StatefulWidget {
  const SpaAndInbodyView({super.key});

  @override
  State<SpaAndInbodyView> createState() => _SpaAndInbodyViewState();
}

class _SpaAndInbodyViewState extends State<SpaAndInbodyView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var box = Hive.box<EmployeeEntity>(kEmployeeDataBox);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  void _loadData() {
    // Load spa services - استخدام WidgetsBinding لتأخير الاستدعاء حتى يكون context جاهز
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        BlocProvider.of<SpaCubit>(context).getAllSpaServices();

        // Load inbody data - استخدام نفس الـ API الخاص بالـ spa
        BlocProvider.of<inbody_cubit.AllInbodyCubit>(context).getAllInbody("");
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ال spa و ال inbody"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "ال spa"),
            Tab(text: "ال inbody"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Spa Tab
          BlocBuilder<SpaCubit, SpaState>(
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
                SpaList spaList = state.data!;
                return ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: spaList.length,
                  itemBuilder: (context, index) {
                    return SpaListItem(spa: spaList[index]);
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
          // Inbody Tab
          const AllInbodyViewBody(),
        ],
      ),
    );
  }
}
