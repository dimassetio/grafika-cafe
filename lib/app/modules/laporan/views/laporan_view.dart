import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:grafika_cafe/app/const/color.dart';
import 'package:grafika_cafe/app/data/helpers/Formatter.dart';
import 'package:grafika_cafe/app/data/models/transaksi_model.dart';
import 'package:grafika_cafe/app/data/models/user_model.dart';
import 'package:grafika_cafe/app/routes/app_pages.dart';
import 'package:grafika_cafe/app/widgets/bottomBar.dart';
import 'package:grafika_cafe/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/laporan_controller.dart';

class LaporanView extends GetView<LaporanController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomBar(
        currentMenu: BottomBar.REPORT,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text("Reporting Overview", fontSize: 16),
              Obx(
                () => Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  margin: EdgeInsets.symmetric(vertical: 16),
                  child: Container(
                    // padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.calendar_month_outlined,
                            color: clr_primary,
                          ),
                          onTap: () async {
                            var date = await showDatePicker(
                                initialDate: controller.currentSingleDate.value,
                                context: context,
                                lastDate: controller.transaksies
                                        .firstWhereOrNull((element) =>
                                            element.dateCreated != null)
                                        ?.dateCreated ??
                                    DateTime.now(),
                                firstDate: controller.transaksies
                                        .lastWhere(
                                            (element) =>
                                                element.dateCreated != null,
                                            orElse: () => TransaksiModel())
                                        .dateCreated ??
                                    DateTime.now());
                            if (date is DateTime) {
                              controller.currentSingleDate.value = date;
                            }
                          },
                          title: text(dateFormatter(
                              controller.currentSingleDate.value)),
                          subtitle: text(
                              "${controller.singleDayTransaksies.length} Transaction"),
                          trailing: Card(
                              color: clr_primary,
                              child: text(
                                currencyFormatter(controller.calculateIncome(
                                    controller.singleDayTransaksies)),
                                color: clr_white,
                              ).marginAll(4)),
                        ),
                        // ListTile(
                        //   leading: Icon(
                        //     Icons.calendar_month_outlined,
                        //     color: clr_primary,
                        //   ),
                        //   onTap: () {
                        //     // showDateRangePicker(
                        //     //     context: context,
                        //     //     lastDate: controller.transaksies
                        //     //             .firstWhereOrNull((element) =>
                        //     //                 element.dateCreated != null)
                        //     //             ?.dateCreated ??
                        //     //         DateTime.now(),
                        //     //     firstDate: controller.transaksies
                        //     //             .lastWhere(
                        //     //                 (element) =>
                        //     //                     element.dateCreated != null,
                        //     //                 orElse: () => TransaksiModel())
                        //     //             .dateCreated ??
                        //     //         DateTime.now());
                        //   },
                        //   title: text("Today Sales"),
                        //   subtitle: text(
                        //       "${controller.todayTransaksies.length} Transaction"),
                        //   trailing: Card(
                        //       color: clr_primary,
                        //       child: text(
                        //         currencyFormatter(controller.calculateIncome(
                        //             controller.todayTransaksies)),
                        //         color: clr_white,
                        //       ).marginAll(4)),
                        // ),
                        ListTile(
                          leading: Icon(
                            Icons.shopping_cart_checkout,
                            color: clr_primary,
                          ),
                          title: text("All Time Sales"),
                          subtitle: text(
                              "${controller.transaksies.length} Transaction"),
                          trailing: Card(
                              color: clr_primary,
                              child: text(
                                currencyFormatter(controller
                                    .calculateIncome(controller.transaksies)),
                                color: clr_white,
                              ).marginAll(4)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              text("Transaction History", fontSize: 16),
              16.height,
              StreamBuilder<List<TransaksiModel>>(
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
            ],
          ),
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
      child: FutureBuilder<UserModel?>(
        future: UserModel(id: transaksi.userId).getUser(),
        builder: (context, future) => ListTile(
          onTap: () => Get.toNamed(Routes.DETAIL_LAPORAN,
              arguments: [transaksi, future.data]),
          title: text(future.data?.name ?? "-- --"),
          subtitle: text(dateTimeFormatter(transaksi.dateCreated)),
          trailing: Card(
            child:
                text(currencyFormatter(transaksi.totalHarga), color: clr_white)
                    .marginAll(4),
            color: clr_primary,
          ),
        ),
      ),
    );
  }
}
