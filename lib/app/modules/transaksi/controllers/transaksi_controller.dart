import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grafika_cafe/app/data/models/menu_model.dart';
import 'package:grafika_cafe/app/data/models/transaksi_model.dart';
import 'package:grafika_cafe/app/modules/auth/controllers/auth_controller.dart';
import 'package:nb_utils/nb_utils.dart';

class TransaksiController extends GetxController {
  //TODO: Implement TransaksiController
  RxBool isSaving = false.obs;

  var _menus = <MenuModel>[].obs;
  List<MenuModel> get menus => _menus.value;
  set menus(List<MenuModel> value) => _menus.value = value;

  var tesString = "".obs;
  TextEditingController noMejaC = TextEditingController();
  Stream<List<MenuModel>> streamListMenu() {
    var stream = MenuModel().db.snapshots(sortBy: MenuModel.DATECREATED).map(
        (event) =>
            event.docs.map((doc) => MenuModel.fromSnapshot(doc)).toList());
    _menus.bindStream(stream);
    return stream;
  }

  RxList<DetailTransaksi> orderMenu = <DetailTransaksi>[].obs;
  int get getTotalHarga {
    int harga = 0;
    orderMenu
        .forEach((element) => harga = harga + (element.subTotalHarga ?? 0));
    return harga;
  }

  addOrder() async {
    try {
      isSaving.value = true;
      TransaksiModel transaksi = TransaksiModel(
        noMeja: noMejaC.text,
        totalHarga: getTotalHarga,
        userId: AuthController.instance.user.id,
        detailTransaksi: orderMenu.value,
      );
      await transaksi.save();
      toast("Order berhasil ditambahkan");
      orderMenu.clear();
    } catch (e) {
      Get.snackbar("error", e.toString());
    } finally {
      isSaving.value = false;
    }
  }
  // List<MenuModel> get orderMenu => _orderMenu.value;
  // set orderMenu(List<MenuModel> value) => _orderMenu.value = value;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
