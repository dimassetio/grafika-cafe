import 'package:get/get.dart';
import 'package:grafika_cafe/app/data/helpers/Database.dart';
import 'package:grafika_cafe/app/data/models/user_model.dart';

class UsersController extends GetxController {
  Database dbUser = UserModel().db;

  var _users = <UserModel>[].obs;
  List<UserModel> get users => _users.value;
  set users(List<UserModel> value) => _users.value = value;

  Stream<List<UserModel>> streamListUser() {
    var stream = dbUser
        // .snapshots(sortBy: sortby.value, descending: descending.value)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => UserModel.fromSnapshot(doc)).toList());
    _users.bindStream(stream);
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
