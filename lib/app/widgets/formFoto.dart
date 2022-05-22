// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grafika_cafe/app/const/asset.dart';
import 'package:grafika_cafe/app/const/color.dart';
import 'package:grafika_cafe/app/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class FormFoto extends StatelessWidget {
  String oldPath = '';
  String defaultPath;
  bool showButton = true;
  FormFoto({
    this.oldPath = '',
    this.defaultPath = img_logo,
    this.showButton = true,
  });
  final ImagePicker _picker = ImagePicker();
  var xfoto = ''.obs;
  String get newPath => xfoto.value;

  getImage(ImageSource source) async {
    var result = await _picker.pickImage(source: source);
    // if (result is XFile) {
    //   xfoto.value = result.path;
    // }
    if (result is XFile) {
      xfoto.value = result.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 16),
            width: Get.width / 2,
            height: Get.width / 2,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: newPath.isNotEmpty
                  ? Image.file(File(newPath))
                  : oldPath.isNotEmpty
                      ? Image.network(
                          oldPath,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          defaultPath,
                        ),
            ),
          ),
        ),
        if (showButton)
          ElevatedButton(
            child: text(
              "Upload Foto",
            ),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16))),
                  builder: (context) => Container(
                        height: 200,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(top: 16, left: 16),
                              child: text("Image Source"),
                            ),
                            ListTile(
                                title: text("Camera"),
                                leading: Icon(
                                  Icons.camera,
                                  color: clr_primary,
                                ),
                                onTap: () async {
                                  await getImage(ImageSource.camera);
                                  Get.back();
                                }),
                            ListTile(
                                title: text("Gallery"),
                                leading: Icon(
                                  Icons.photo,
                                  color: clr_primary,
                                ),
                                onTap: () async {
                                  await getImage(ImageSource.gallery);
                                  Get.back();
                                }),
                          ],
                        ),
                      ));
            },
          ),
      ],
    );
  }
}
