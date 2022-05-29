// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:grafika_cafe/app/const/asset.dart';
import 'package:grafika_cafe/app/const/color.dart';
import 'package:grafika_cafe/app/data/helpers/Formatter.dart';
import 'package:grafika_cafe/app/data/models/menu_model.dart';
import 'package:grafika_cafe/app/data/models/transaksi_model.dart';
import 'package:grafika_cafe/app/data/models/user_model.dart';
import 'package:grafika_cafe/app/modules/auth/controllers/auth_controller.dart';
import 'package:grafika_cafe/app/modules/index_menu/views/index_menu_view.dart';
import 'package:grafika_cafe/app/modules/transaksi/controllers/transaksi_controller.dart';
import 'package:grafika_cafe/app/routes/app_pages.dart';
import 'package:grafika_cafe/app/widgets/bottomBar.dart';
import 'package:grafika_cafe/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class TransaksiView extends GetView<TransaksiController> {
  AuthController authC = AuthController.instance;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      endDrawer: Container(
        width: Get.width * 3 / 4,
        color: clr_background,
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: Obx(
              () => Stack(
                children: [
                  Column(children: [
                    16.height,
                    Expanded(
                      child: controller.orderMenu.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: controller.orderMenu.length,
                              itemBuilder: ((context, index) => Obx(
                                    () => OrderDetailCard(
                                        orderDetail:
                                            controller.orderMenu[index]),
                                  )),
                            )
                          : text("Add Menu First!"),
                    ),
                    Card(
                      elevation: 8,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(32))),
                      child: Column(
                        children: [
                          16.height,
                          ListTile(
                            title: text("${controller.orderMenu.length} Menu"),
                            subtitle: inputText(
                              textFieldType: TextFieldType.PHONE,
                              label: "Table Number",
                              isValidationRequired: true,
                              controller: controller.noMejaC,
                            ),
                            trailing: text(
                                currencyFormatter(controller.getTotalHarga)),
                          ),
                          16.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton.icon(
                                  onPressed: () {
                                    if (controller.orderMenu.isNotEmpty) {
                                      showConfirmDialog(context,
                                              "Apakah anda yakin menghapus seluruh menu dalam orderan ini?")
                                          .then((value) => (value ?? false)
                                              ? controller.orderMenu.clear()
                                              : null);
                                    }
                                  },
                                  icon: Icon(Icons.delete),
                                  label: text("Clear")),
                              ElevatedButton.icon(
                                  onPressed: () async {
                                    if (controller.orderMenu.length < 1) {
                                      Get.defaultDialog(
                                          onConfirm: () => Get.back(),
                                          middleText: "Add menu first!");
                                    }
                                    if (_formKey.currentState!.validate()) {
                                      await controller.addOrder();
                                      _key.currentState!.isEndDrawerOpen
                                          ? Get.back()
                                          : null;
                                    }
                                  },
                                  icon: Icon(Icons.payment),
                                  label: text("Order")),
                            ],
                          ),
                          16.height,
                        ],
                      ),
                    ),
                  ]),
                  if (controller.isSaving.value)
                    Container(
                      color: clr_black.withOpacity(0.2),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Order'),
        centerTitle: true,
        leading: BackButton(),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {
                // Scaffold.of(context).openEndDrawer();
                _key.currentState!.openEndDrawer();
              },
              icon: Badge(
                showBadge: controller.orderMenu.isNotEmpty,
                badgeContent: text(controller.orderMenu.length.toString(),
                    fontSize: 12, color: Colors.white),
                child: Icon(controller.orderMenu.length > 0
                    ? Icons.shopping_cart_checkout_sharp
                    : Icons.shopping_cart),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(
        currentMenu: BottomBar.ORDER,
      ),
      body: Container(
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
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
                            itemBuilder: (context, index) => Obx(() =>
                                OrderMenuCard(menu: controller.menus[index])));
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderMenuCard extends GetView<TransaksiController> {
  OrderMenuCard({required this.menu});
  MenuModel menu;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              trailing: ElevatedButton(
                onPressed: () {
                  DetailTransaksi? detail = controller.orderMenu
                      .firstWhereOrNull((element) => element.menuId == menu.id);
                  detail == null
                      ? controller.orderMenu.add(DetailTransaksi.fromMenu(menu))
                      : detail.addJumlah();
                },
                child: text(
                  "Add",
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderDetailCard extends GetView<TransaksiController> {
  OrderDetailCard({
    required this.orderDetail,
    this.showOnly = false,
  });
  DetailTransaksi orderDetail;
  bool showOnly;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
          title: text(orderDetail.menuModel?.name ?? "-- Nama Menu --"),
          subtitle: text(
            currencyFormatter(orderDetail.subTotalHarga),
          ),
          trailing: showOnly
              ? CircleAvatar(
                  radius: 12, child: text(orderDetail.jumlah.toString()))
              : Wrap(
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          (orderDetail.jumlah ?? 0) > 1
                              ? orderDetail.removeJumlah()
                              : controller.orderMenu.remove(orderDetail);
                          controller.orderMenu.refresh();
                        },
                        icon: Icon(Icons.remove)),
                    text((orderDetail.jumlah ?? 0).toString()),
                    IconButton(
                        onPressed: () {
                          orderDetail.addJumlah();
                          controller.orderMenu.refresh();
                        },
                        icon: Icon(Icons.add)),
                  ],
                )),
    );
  }
}
