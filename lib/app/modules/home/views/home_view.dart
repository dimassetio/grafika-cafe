// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:grafika_cafe/app/modules/auth/controllers/auth_controller.dart';
import 'package:grafika_cafe/app/routes/app_pages.dart';
import 'package:grafika_cafe/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  AuthController authC = Get.find();
  @override
  Widget build(BuildContext context) {
    if (!authC.isLoggedIn) {
      print("Redirect to Auth");
      Get.toNamed(Routes.AUTH);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async => await authC.signOut(),
                icon: Icon(Icons.logout))
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            switch (index) {
              case 0:
                Get.toNamed(Routes.HOME);
                break;
              case 1:
                Get.toNamed(Routes.INDEX_MENU);
                break;
              case 2:
                Get.toNamed(Routes.TRANSAKSI);
                break;
              case 3:
                Get.toNamed(Routes.LAPORAN);
                break;
              case 4:
                Get.toNamed(Routes.USERS);
                break;
              default:
            }
          },
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fastfood_rounded),
              label: "Menu",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart_rounded),
              label: "Order",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: "Report",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: "Users",
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Obx(
            () => Column(
              children: [
                // BoxContainer(
                //   children: [
                ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                    radius: 40,
                  ),
                  contentPadding: EdgeInsets.zero,
                  title: text("Hai", fontSize: 20),
                  subtitle: text(
                      authC.user.name ?? authC.firebaseUser.value?.email,
                      fontSize: 16),
                ),
                //   ],
                // ),
              ],
            ),
          ),
        ));
  }
}
