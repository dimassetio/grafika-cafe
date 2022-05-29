// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:grafika_cafe/app/const/color.dart';
import 'package:grafika_cafe/app/data/helpers/Formatter.dart';
import 'package:grafika_cafe/app/data/models/transaksi_model.dart';
import 'package:grafika_cafe/app/data/models/user_model.dart';
import 'package:grafika_cafe/app/modules/transaksi/views/transaksi_view.dart';
import 'package:grafika_cafe/app/modules/users/views/users_view.dart';
import 'package:grafika_cafe/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/detail_laporan_controller.dart';

class DetailLaporanView extends GetView<DetailLaporanController> {
  TransaksiModel? transaksi = Get.arguments[0];
  UserModel? user = Get.arguments[1];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Detail'),
        centerTitle: true,
      ),
      body: Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(
                  "User Information",
                  fontSize: 16,
                ),
                12.height,
                UserCard(user: user ?? UserModel()),
                text(
                  "Transaction Overview",
                  fontSize: 16,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  margin: EdgeInsets.symmetric(vertical: 16),
                  elevation: 4,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.calendar_today,
                          color: clr_primary,
                        ),
                        title: text("Date"),
                        subtitle:
                            text(dateTimeFormatter(transaksi?.dateCreated)),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.attach_money,
                          color: clr_primary,
                        ),
                        title: text("Total Price"),
                        subtitle:
                            text(currencyFormatter(transaksi?.totalHarga)),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.table_bar,
                          color: clr_primary,
                        ),
                        title: text("Table Number"),
                        subtitle: text(transaksi?.noMeja),
                      ),
                    ],
                  ),
                ),
                text("Order Detail", fontSize: 16),
                16.height,
                if (transaksi is TransaksiModel)
                  FutureBuilder<List<DetailTransaksi>>(
                    future: transaksi?.getAllDetail(),
                    builder: (context, future) => future.hasData
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: future.data!.length,
                            itemBuilder: (context, index) => FutureBuilder(
                                future: future.data![index].getMenu(),
                                builder: (context, snapshot) {
                                  return OrderDetailCard(
                                    orderDetail: future.data![index],
                                    showOnly: true,
                                  );
                                }))
                        : Card(
                            child: Center(
                                child:
                                    CircularProgressIndicator().marginAll(32))),
                  )
              ],
            ),
          )),
    );
  }
}
