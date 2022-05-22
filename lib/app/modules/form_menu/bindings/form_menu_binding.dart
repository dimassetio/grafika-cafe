import 'package:get/get.dart';

import '../controllers/form_menu_controller.dart';

class FormMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormMenuController>(
      () => FormMenuController(),
    );
  }
}
