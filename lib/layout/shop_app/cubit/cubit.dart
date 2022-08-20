import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_application/layout/shop_app/cubit/states.dart';
import 'package:shop_application/models/categories_model.dart';
import 'package:shop_application/models/home_model.dart';
import 'package:shop_application/modules/shop_app_screens/categories/categories_screen.dart';
import 'package:shop_application/modules/shop_app_screens/favorites/favorites_screen.dart';
import 'package:shop_application/modules/shop_app_screens/products/products_screen.dart';
import 'package:shop_application/modules/shop_app_screens/settings/settings_screen.dart';
import 'package:shop_application/shared/components/component.dart';
import 'package:shop_application/shared/constant/constant.dart';
import 'package:shop_application/shared/network/end_points.dart';
import 'package:shop_application/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;

  List<Widget> bottomScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottom(index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;

  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(
      url: Home,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      printFullText(homeModel?.data?.banners[0].image);
      print(homeModel?.status);
      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState(error.toString()));
    });
  }

  CategoriesModel? categoriesModel;

  void getCategories() {
    DioHelper.getData(
      url: GET_CATEGORIES,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState(error.toString()));
    });
  }
}
