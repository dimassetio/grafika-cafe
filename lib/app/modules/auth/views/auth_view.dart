// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grafika_cafe/app/const/asset.dart';
import 'package:grafika_cafe/app/const/color.dart';
import 'package:grafika_cafe/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  GlobalKey<FormState> _form = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('AuthView'),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: Container(
          height: Get.height,
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Obx(
              () => Form(
                key: _form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    16.height,
                    Container(
                        height: Get.height / 3, child: Image.asset(img_logo)),
                    16.height,
                    BoxContainer(
                      children: [
                        AppTextField(
                          controller: controller.emailC,
                          textFieldType: TextFieldType.EMAIL,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: "Email"),
                          errorInvalidEmail: "Invalid Email",
                        ),
                        16.height,
                        AppTextField(
                          controller: controller.passwordC,
                          isValidationRequired: true,
                          textFieldType: TextFieldType.PASSWORD,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              labelText: "Password",
                              suffixIconColor: clr_primary),
                        ),
                        16.height,
                      ],
                    ),
                    32.height,
                    AppButton(
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      width: Get.width,
                      text: controller.isSaving ? "" : "Submit",
                      child: controller.isSaving
                          ? CircularProgressIndicator()
                          : null,
                      color: clr_primary,
                      textColor: clr_white,
                      onTap: controller.isSaving
                          ? null
                          : () async {
                              if (_form.currentState!.validate()) {
                                await controller.signIn();
                              }
                              // Get.toNamed(Routes.HOME);
                            },
                    ),

                    // 16.height,

                    TextButton(
                      style: ButtonStyle(visualDensity: VisualDensity.compact),
                      onPressed: () {},
                      child: Text("Forgot Password?"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
