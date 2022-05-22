import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grafika_cafe/app/data/models/menu_model.dart';
import 'package:nb_utils/nb_utils.dart';

class FormMenuController extends GetxController {
  //TODO: Implement FormMenuController
  var isSaving = false.obs;

  TextEditingController name = TextEditingController();
  TextEditingController harga = TextEditingController();
  TextEditingController keterangan = TextEditingController();
  String? selectedJenis;
  final count = 0.obs;

  save(MenuModel menu, {String? path}) async {
    try {
      isSaving.value = true;
      menu.name = name.text;
      menu.keterangan = keterangan.text;
      menu.harga = harga.text.toInt();
      menu.jenis = selectedJenis;
      if (!path.isEmptyOrNull) {
        File file = File(path!);
        await menu.save(file: file);
      } else {
        await menu.save();
      }
      Get.back();
      toast("Data Saved Success");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isSaving.value = false;
    }
  }

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
