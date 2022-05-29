import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:grafika_cafe/app/const/asset.dart';
import 'package:grafika_cafe/app/data/helpers/Formatter.dart';
import 'package:grafika_cafe/app/data/models/menu_model.dart';
import 'package:grafika_cafe/app/data/models/user_model.dart';
import 'package:grafika_cafe/app/modules/auth/controllers/auth_controller.dart';
import 'package:grafika_cafe/app/routes/app_pages.dart';
import 'package:grafika_cafe/app/widgets/bottomBar.dart';
import 'package:grafika_cafe/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/index_menu_controller.dart';

class IndexMenuView extends GetView<IndexMenuController> {
  AuthController authC = AuthController.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBar(
        currentMenu: BottomBar.MENU,
      ),
      floatingActionButton:
          authC.user.hasRole(Role.manajer) || authC.user.hasRole(Role.admin)
              ? FloatingActionButton(
                  onPressed: () {
                    Get.toNamed(Routes.FORM_MENU);
                  },
                  child: Icon(Icons.add),
                )
              : null,
      appBar: AppBar(
        title: Text('Menues'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: StreamBuilder<List<MenuModel>>(
              stream: controller.streamListMenu(),
              builder: (context, stream) {
                if (stream.hasData) {
                  return GridView.builder(
                      shrinkWrap: true,
                      itemCount: controller.menus.length,
                      physics: ScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5),
                      itemBuilder: (context, index) =>
                          MenuCard(menu: controller.menus[index]));
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  MenuCard({required this.menu});
  MenuModel menu;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => Get.toNamed(Routes.DETAIL_MENU, arguments: menu),
        child: Column(
          children: [
            Expanded(
              child: menu.photo.isEmptyOrNull
                  ? Image.asset(img_logo)
                  : Image.network(
                      menu.photo!,
                    ),
            ),
            ListTile(
              title: text(menu.name ?? "Nama Menu"),
              subtitle: text(currencyFormatter(menu.harga)),
            )
          ],
        ),
      ),
    );
  }
}
