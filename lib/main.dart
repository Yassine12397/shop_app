import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/shared/components/blocObserver.dart';
import 'package:shop_application/shared/constant/constant.dart';
import 'package:shop_application/shared/network/local/cache_helper.dart';
import 'package:shop_application/shared/network/remote/dio_helper.dart';
import 'package:shop_application/shared/styles/themes/theme.dart';
import 'layout/shop_app/cubit/cubit.dart';
import 'layout/shop_app/home_screen.dart';
import 'layout/theme_cubit/themeCubit.dart';
import 'layout/theme_cubit/themeState.dart';
import 'modules/login/login_screen.dart';
import 'modules/on_boarding.dart';

void main() {
  BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      DioHelper.init();
      await CacheHelper.init();
      Widget widget;
      bool? isDark = CacheHelper.getData(key: 'isDark');
      bool? onBoard = CacheHelper.getSavedData(key: 'onBoarding');
      token = CacheHelper.getSavedData(key: 'token');
      if (onBoard != null) {
        if (token != null)
          widget = ShopLayout();
        else
          widget = ShopLoginScreen();
      } else {
        widget = OnBoardingScreen();
      }

      print(onBoard);
      runApp(MyApp(isDark, widget));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  final Widget startWidget;

  MyApp(this.isDark, this.startWidget);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit()
            ..changeAppMode(
              fromShared: isDark,
            ),
        ),
        BlocProvider(
          create: (context) => ShopCubit()..getHomeData()..getCategories(),
        )
      ],
      child: BlocConsumer<ThemeCubit, ThemeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeCubit.get(context).isDark
                ? ThemeMode.dark
                : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
