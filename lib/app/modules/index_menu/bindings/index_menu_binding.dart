import 'package:get/get.dart';

import '../controllers/index_menu_controller.dart';

class IndexMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IndexMenuController>(
      () => IndexMenuController(),
    );
  }
}
