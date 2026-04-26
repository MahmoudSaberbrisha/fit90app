import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fit90_gym_main/Features/bottom_nav/presentation/manger/cubit/bottom_nav_cubit.dart';
import 'package:fit90_gym_main/core/locale/app_localizations.dart';
import 'package:fit90_gym_main/core/widgets/custom_simple_app_bar.dart';

import 'views/widgets/notification_view_body.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    late AppLocalizations locale;
    locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: MediaQuery.of(context).size * .07,
        child: CustomSimpleAppBar(
          appBarTitle: locale.translate('notifications')!,
          backHandler: () {
            if (Navigator.canPop(context)) {
              // الحالة دي معناها إن الشاشة دي اتفتحت بـ push
              Navigator.pop(context);
            } else {
              // الشاشة دي اتعرضت كواحدة من التابات، نرجّع المستخدم للتاب المناسب
              BlocProvider.of<BottomNavCubit>(context).updateBottomNavIndex(4);
            }
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: FadeInUp(child: const NotificationViewBody()),
    );
  }
}

