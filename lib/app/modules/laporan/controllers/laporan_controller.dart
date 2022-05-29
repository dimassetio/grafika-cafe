import 'package:get/get.dart';
import 'package:grafika_cafe/app/data/helpers/Formatter.dart';
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

  List<TransaksiModel> get todayTransaksies =>
      _transaksies.where((item) => isToday(item.dateCreated)).toList();

  List<TransaksiModel> get singleDayTransaksies => _transaksies
      .where((item) => matchDay(currentSingleDate.value, item.dateCreated))
      .toList();

  int calculateIncome(List<TransaksiModel> list) {
    int total = 0;
    for (var item in list) {
      total = total + (item.totalHarga ?? 0);
    }
    return total;
  }

  var currentSingleDate = DateTime.now().obs;

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
