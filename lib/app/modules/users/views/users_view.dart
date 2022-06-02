// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:grafika_cafe/app/const/color.dart';
import 'package:grafika_cafe/app/data/models/user_model.dart';
import 'package:grafika_cafe/app/modules/auth/controllers/auth_controller.dart';
import 'package:grafika_cafe/app/routes/app_pages.dart';
import 'package:grafika_cafe/app/widgets/bottomBar.dart';
import 'package:grafika_cafe/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/users_controller.dart';

class UsersView extends GetView<UsersController> {
  AuthController authC = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Manage User'),
          centerTitle: true,
        ),
        bottomNavigationBar: BottomBar(
          currentMenu: BottomBar.USERS,
        ),
        floatingActionButton: Obx(() =>
            authC.user.hasRole(Role.admin) || authC.user.hasRole(Role.manajer)
                ? FloatingActionButton(
                    onPressed: () {
                      Get.toNamed(Routes.FORM_USER);
                    },
                    child: Icon(Icons.add),
                  )
                : SizedBox()),
        body: Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: text("List All User",
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                16.height,
                StreamBuilder(
                  stream: controller.streamListUser(),
                  builder: (context, stream) {
                    if (stream.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: controller.users.length,
                          // itemCount: 100,
                          itemBuilder: ((context, index) =>
                              UserCard(user: controller.users[index])));
                    } else {
                      return Center(
                        child: Container(
                            height: 32,
                            width: 32,
                            child: CircularProgressIndicator()),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}

class UserCard extends StatelessWidget {
  UserCard({
    required this.user,
  });
  UserModel user;
  Color color_from_role(String role) {
    switch (role) {
      case Role.admin:
        return clr_secondary;
      case Role.kasir:
        return clr_accent;
      case Role.manajer:
        return clr_primary;
      default:
        return clr_white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: () {
          Get.toNamed(Routes.DETAIL_USER, arguments: user);
        },
        horizontalTitleGap: 8,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              child: Icon(
                Icons.person,
                // color: clr_primary,
              ),
            )
          ],
        ),
        title: text(user.name ?? "--"),
        subtitle: text(user.email ?? "--@--.--", color: clr_primary),
        trailing: Card(
            elevation: 4,
            color: color_from_role(user.role ?? ''),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
              child: text(user.role ?? "--", fontSize: 12, color: clr_white),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16))),
      ),
    );
  }
}
