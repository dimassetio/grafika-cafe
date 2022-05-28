import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:grafika_cafe/app/const/color.dart';
import 'package:grafika_cafe/app/data/helpers/Formatter.dart';
import 'package:grafika_cafe/app/data/models/transaksi_model.dart';
import 'package:grafika_cafe/app/data/models/user_model.dart';
import 'package:grafika_cafe/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/laporan_controller.dart';

class LaporanView extends GetView<LaporanController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LaporanView'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: StreamBuilder<List<TransaksiModel>>(
              stream: controller.streamListMenu(),
              builder: (context, stream) {
                if (stream.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.transaksies.length,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) => LaporanCard(
                      transaksi: controller.transaksies[index],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}

class LaporanCard extends GetView<LaporanController> {
  LaporanCard({
    required this.transaksi,
  });
  TransaksiModel transaksi;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: FutureBuilder<UserModel?>(
          future: UserModel(id: transaksi.userId).getUser(),
          builder: (context, future) => text(future.data?.name ?? "-- --"),
        ),
        subtitle: text(dateTimeFormatter(transaksi.dateCreated)),
        trailing: Card(
          child: text(currencyFormatter(transaksi.totalHarga), color: clr_white)
              .marginAll(4),
          color: clr_primary,
        ),
      ),
    );
  }
}
