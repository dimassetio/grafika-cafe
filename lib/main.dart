import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grafika_cafe/app/modules/auth/controllers/auth_controller.dart';
import 'package:nb_utils/nb_utils.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initialize();
  AuthController authC = Get.put(AuthController());
  runApp(
    GetMaterialApp(
      title: "Grafika Cafe",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(primarySwatch: Colors.amber),
    ),
  );
}
