import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:grafika_cafe/app/const/asset.dart';
import 'package:grafika_cafe/app/const/color.dart';
import 'package:grafika_cafe/app/data/helpers/Formatter.dart';
import 'package:grafika_cafe/app/data/models/menu_model.dart';
import 'package:grafika_cafe/app/data/models/user_model.dart';
import 'package:grafika_cafe/app/modules/auth/controllers/auth_controller.dart';
import 'package:grafika_cafe/app/modules/index_menu/views/index_menu_view.dart';
import 'package:grafika_cafe/app/modules/transaksi/controllers/transaksi_controller.dart';
import 'package:grafika_cafe/app/routes/app_pages.dart';
import 'package:grafika_cafe/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class TransaksiView extends GetView<TransaksiController> {
  AuthController authC = AuthController.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text('Order'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: StreamBuilder<List<MenuModel>>(
              stream: controller.streamListMenu(),
              builder: (context, stream) {
                if (stream.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.menus.length,
                      physics: ScrollPhysics(),
                      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //     crossAxisCount: 2,
                      //     mainAxisSpacing: 5,
                      //     crossAxisSpacing: 5),
                      itemBuilder: (context, index) =>
                          OrderMenuCard(menu: controller.menus[index]));
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

class OrderMenuCard extends StatelessWidget {
  OrderMenuCard({required this.menu});
  MenuModel menu;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => Get.toNamed(Routes.DETAIL_MENU, arguments: menu),
        child: Row(
          children: [
            menu.photo.isEmptyOrNull
                ? Image.asset(
                    img_logo,
                    width: Get.width / 4,
                    height: Get.width / 4,
                  )
                : Image.network(
                    menu.photo!,
                    height: Get.width / 4,
                    width: Get.width / 4,
                    fit: BoxFit.cover,
                  ),
            Expanded(
                child: ListTile(
              title: text(menu.name ?? "Nama Menu"),
              subtitle: text(
                currencyFormatter(menu.harga),
              ),
              trailing: Wrap(
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.remove,
                      color: clr_primary,
                    ),
                  ),
                  text("0"),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.add, color: clr_primary),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
