import 'package:get/get.dart';
import 'package:grafika_cafe/app/data/models/transaksi_model.dart';

class LaporanController extends GetxController {
  var _transaksies = <TransaksiModel>[].obs;
  List<TransaksiModel> get transaksies => _transaksies.value;
  set transaksies(List<TransaksiModel> value) => _transaksies.value = value;

  Stream<List<TransaksiModel>> streamListMenu() {
    var stream = TransaksiModel()
        .db
        .snapshots(sortBy: TransaksiModel.DATECREATED, descending: true)
        .map((event) =>
            event.docs.map((doc) => TransaksiModel.fromSnapshot(doc)).toList());
    _transaksies.bindStream(stream);
    return stream;
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
}
