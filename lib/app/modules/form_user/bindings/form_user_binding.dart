import 'package:get/get.dart';

import '../controllers/form_user_controller.dart';

class FormUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormUserController>(
      () => FormUserController(),
    );
  }
}
