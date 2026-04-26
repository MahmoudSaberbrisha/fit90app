import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit90_gym_main/core/utils/constants.dart';
import 'package:fit90_gym_main/features/app_home/presentation/manger/toggle_cubit.dart';
import 'package:fit90_gym_main/features/auth/register/presentation/manager/cubit/radio_cubit.dart';
import 'package:fit90_gym_main/features/personal_account/presentation/manager/cubit/get_profile_cubit.dart';
import 'package:fit90_gym_main/features/subscribtions/presentation/manager/pick_cubit/pick_date_cubit.dart';

import 'core/locale/app_localizations_setup.dart';
import 'core/utils/functions/setup_service_locator.dart';
import 'core/utils/routes/app_routes.dart';
import 'features/auth/fire_base_token/presentation/manger/token_cubit.dart';
import 'features/bottom_nav/presentation/manger/cubit/bottom_nav_cubit.dart';
import 'features/splash/presentation/manger/locale_cubit/locale_cubit.dart';

class FingerPrint extends StatelessWidget {
  const FingerPrint({super.key});

  @override
  Widget build(BuildContext context) {
    // final GlobalKey<NavigatorState> navigatorKey =
    //     GlobalKey(debugLabel: "Main Navigator");

    //  mNotificationSettings.registerNotification(context, navigatorKey);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<BottomNavCubit>()),
        BlocProvider(create: (_) => getIt<LocaleCubit>()),
        BlocProvider(create: (_) => getIt<TokenCubit>()),
        BlocProvider(create: (_) => getIt<PickDateCubit>()),
        BlocProvider(create: (_) => getIt<ToggleCubit>()),
        BlocProvider(create: (_) => getIt<GetProfileCubit>()),
        BlocProvider(create: (_) => getIt<RadioCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        buildWhen: (previousState, currentState) =>
            previousState != currentState,
        builder: (_, localeState) {
          return ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                // navigatorKey: navigatorKey,
                locale: localeState.locale,
                onGenerateRoute: AppRoutes.onGenerateRoute,
                supportedLocales: AppLocalizationsSetup.supportedLocales,
                localeResolutionCallback:
                    AppLocalizationsSetup.localeResolutionCallback,
                localizationsDelegates:
                    AppLocalizationsSetup.localizationsDelegates,
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  scaffoldBackgroundColor: Colors.black, // Black background
                  primarySwatch: Colors.red,
                  fontFamily: "ElMessiri",
                  brightness: Brightness.dark,
                  colorScheme: const ColorScheme.dark(
                    primary: Color(0xFFED402F), // Red F I T 9 0
                    secondary: Color(0xFF00D774), // Green F I T 9 0
                    surface: Colors.black, // Black surface
                    background: Colors.black, // Black background
                    onPrimary: Colors.white,
                    onSecondary: Colors.white,
                    onSurface: Color(0xFFE5E5E5), // Light text
                    onBackground: Color(0xFFE5E5E5), // Light text
                    error: Color(0xFFED402F), // Red for errors
                    onError: Colors.white,
                  ),
                  textTheme: const TextTheme(
                    titleSmall:
                        TextStyle(fontSize: 10, color: Color(0xFFE5E5E5)),
                    titleMedium:
                        TextStyle(fontSize: 12, color: Color(0xFFE5E5E5)),
                    bodyLarge: TextStyle(color: Color(0xFFE5E5E5)),
                    bodyMedium: TextStyle(color: Color(0xFFE5E5E5)),
                    bodySmall: TextStyle(color: Color(0xFFB0B0B0)),
                    headlineLarge: TextStyle(color: Color(0xFFE5E5E5)),
                    headlineMedium: TextStyle(color: Color(0xFFE5E5E5)),
                    headlineSmall: TextStyle(color: Color(0xFFE5E5E5)),
                    labelLarge: TextStyle(color: Color(0xFFE5E5E5)),
                    labelMedium: TextStyle(color: Color(0xFFB0B0B0)),
                    labelSmall: TextStyle(color: Color(0xFF707070)),
                  ),
                  progressIndicatorTheme: const ProgressIndicatorThemeData(
                    color: Color(0xFFED402F), // Red F I T 9 0
                  ),
                  appBarTheme: const AppBarTheme(
                    backgroundColor: Colors.black, // Black app bar
                    foregroundColor: Color(0xFFE5E5E5),
                    elevation: 0,
                  ),
                  cardTheme: const CardThemeData(
                    color: Colors.black, // Black card
                    shadowColor: Colors.black,
                    elevation: 2,
                  ),
                  canvasColor: Colors.black,
                  dialogBackgroundColor: Colors.black,
                  bottomAppBarTheme: const BottomAppBarThemeData(
                    color: Colors.black,
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFED402F),
                      foregroundColor: Colors.white,
                      elevation: 2,
                    ),
                  ),
                  outlinedButtonTheme: OutlinedButtonThemeData(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFED402F),
                      side: const BorderSide(color: Color(0xFFED402F)),
                    ),
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFED402F),
                    ),
                  ),
                  inputDecorationTheme: const InputDecorationTheme(
                    filled: true,
                    fillColor: Colors.black, // Black input field
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF2A2B2F)),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF2A2B2F)),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFED402F)),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFED402F)),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    labelStyle: TextStyle(color: Color(0xFFB0B0B0)),
                    hintStyle: TextStyle(color: Color(0xFF707070)),
                  ),
                  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                    backgroundColor: Colors.black, // Black bottom nav
                    selectedItemColor: Color(0xFFED402F),
                    unselectedItemColor: Color(0xFF707070),
                    type: BottomNavigationBarType.fixed,
                  ),
                  dividerTheme: const DividerThemeData(
                    color: Color(0xFF2A2B2F), // Dark divider
                  ),
                  iconTheme: const IconThemeData(
                    color: Color(0xFFE5E5E5), // Light icons
                  ),
                  listTileTheme: const ListTileThemeData(
                    tileColor: Colors.black, // Black list tiles
                    textColor: Color(0xFFE5E5E5),
                    iconColor: Color(0xFFE5E5E5),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
