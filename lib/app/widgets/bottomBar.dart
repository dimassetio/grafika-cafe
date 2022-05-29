// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grafika_cafe/app/const/color.dart';
import 'package:grafika_cafe/app/data/models/user_model.dart';
import 'package:grafika_cafe/app/modules/auth/controllers/auth_controller.dart';
import 'package:grafika_cafe/app/routes/app_pages.dart';

class BottomBar extends GetView<AuthController> {
  BottomBar({
    Key? key,
    required this.currentMenu,
  }) : super(key: key);
  String currentMenu;
  static String HOME = "Home";
  static String MENU = "Menu";
  static String ORDER = "Order";
  static String REPORT = "Report";
  static String USERS = "Users";

  static Map<String, BottomNavigationBarItem> itemList = {
    HOME: BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: HOME,
    ),
    MENU: BottomNavigationBarItem(
      icon: Icon(Icons.fastfood_rounded),
      label: MENU,
    ),
    ORDER: BottomNavigationBarItem(
      icon: Icon(Icons.add_shopping_cart_rounded),
      label: ORDER,
    ),
    REPORT: BottomNavigationBarItem(
      icon: Icon(Icons.receipt_long),
      label: REPORT,
    ),
    USERS: BottomNavigationBarItem(
      icon: Icon(Icons.group),
      label: USERS,
    ),
  };

  int get currIndex => botBarItem.indexOf(
      botBarItem.firstWhere((element) => element.label == currentMenu));

  List<BottomNavigationBarItem> get botBarItem {
    switch (controller.user.role) {
      case Role.kasir:
        return [
          itemList[HOME]!,
          itemList[ORDER]!,
          itemList[REPORT]!,
        ];
      case Role.manajer:
        return [
          itemList[HOME]!,
          itemList[MENU]!,
          itemList[REPORT]!,
          itemList[USERS]!,
        ];
      default:
        return [
          itemList[HOME]!,
          itemList[MENU]!,
          itemList[ORDER]!,
          itemList[REPORT]!,
          itemList[USERS]!,
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (botBarItem[index].label) {
            case "Home":
              Get.toNamed(Routes.HOME);
              break;
            case "Menu":
              Get.toNamed(Routes.INDEX_MENU);
              break;
            case "Order":
              Get.toNamed(Routes.TRANSAKSI);
              break;
            case "Report":
              Get.toNamed(Routes.LAPORAN);
              break;
            case "Users":
              Get.toNamed(Routes.USERS);
              break;
            default:
          }
        },
        currentIndex: currIndex,
        showUnselectedLabels: false,
        items: botBarItem);
  }
}
