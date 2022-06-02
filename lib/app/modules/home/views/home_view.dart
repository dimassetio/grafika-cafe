// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:grafika_cafe/app/modules/auth/controllers/auth_controller.dart';
import 'package:grafika_cafe/app/routes/app_pages.dart';
import 'package:grafika_cafe/app/widgets/bottomBar.dart';
import 'package:grafika_cafe/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  AuthController authC = Get.find();
  @override
  Widget build(BuildContext context) {
    // if (!authC.isLoggedIn) {
    //   print("Redirect to Auth");
    //   Get.toNamed(Routes.AUTH);
    // }
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
        bottomNavigationBar: BottomBar(
          currentMenu: BottomBar.HOME,
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
