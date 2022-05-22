import 'package:get/get.dart';
import 'package:grafika_cafe/app/data/models/menu_model.dart';

class IndexMenuController extends GetxController {
  var _menus = <MenuModel>[].obs;
  List<MenuModel> get menus => _menus.value;
  set menus(List<MenuModel> value) => _menus.value = value;

  Stream<List<MenuModel>> streamListMenu() {
    var stream = MenuModel().db.snapshots(sortBy: MenuModel.DATECREATED).map(
        (event) =>
            event.docs.map((doc) => MenuModel.fromSnapshot(doc)).toList());
    _menus.bindStream(stream);
    return stream;
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
