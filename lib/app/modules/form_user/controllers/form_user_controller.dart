import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:grafika_cafe/app/data/models/user_model.dart';
import 'package:grafika_cafe/app/modules/auth/controllers/auth_controller.dart';
import 'package:nb_utils/nb_utils.dart';

class FormUserController extends GetxController {
  AuthController authC = Get.find();
  var isSaving = false.obs;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cpassword = TextEditingController();
  String? selectedRole;
  String? cpasswordValidator(String? value) {
    if (value.isEmptyOrNull) {
      return "This field is required";
    }
    if (value != password.text) {
      return "Password must be same!";
    }
    return null;
  }

  store(UserModel user) async {
    try {
      isSaving.value = true;
      if (user.id.isEmptyOrNull) {
        await authC.register(
            email.text, password.text, name.text, selectedRole ?? '', null);
      } else {
        user.email = email.text;
        user.name = name.text;
        user.role = selectedRole;
        await user.save();
        Get.back();
        toast("Update Success");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isSaving.value = false;
    }
  }

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
