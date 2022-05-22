// ignore_for_file: prefer_const_constructors

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:grafika_cafe/app/const/color.dart';
import 'package:grafika_cafe/app/data/models/user_model.dart';
import 'package:grafika_cafe/app/modules/auth/controllers/auth_controller.dart';
import 'package:grafika_cafe/app/routes/app_pages.dart';
import 'package:grafika_cafe/app/widgets/formFoto.dart';
import 'package:grafika_cafe/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/form_user_controller.dart';

class FormUserView extends GetView<FormUserController> {
  AuthController authC = Get.find();
  GlobalKey<FormState> _key = GlobalKey();
  FormUserView({required this.enableEdit});

  bool enableEdit;
  @override
  Widget build(BuildContext context) {
    UserModel user = Get.arguments ?? UserModel();
    controller.name.text = user.name ?? '';
    controller.email.text = user.email ?? '';
    controller.selectedRole = user.role;
    return Scaffold(
      floatingActionButton: !enableEdit &&
              (authC.user.hasRole(Role.admin) ||
                  authC.user.hasRole(Role.manajer))
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: '1',
                  onPressed: () {
                    Get.toNamed(Routes.FORM_USER, arguments: user);
                  },
                  child: Icon(Icons.edit),
                ),
                16.height,
                FloatingActionButton(
                  heroTag: '2',
                  onPressed: () {
                    showConfirmDialog(context,
                        "Are you sure to delete user ${user.name?.toUpperCase()}?",
                        onAccept: () async {
                      await user.db.delete(user.id!);
                      Get.back();
                    });
                  },
                  child: Icon(Icons.delete),
                ),
              ],
            )
          : null,
      appBar: AppBar(
        title: Text(enableEdit ? 'Form User' : 'Detail User'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Obx(
            () => Form(
              key: _key,
              child: Column(
                children: [
                  inputText(
                      label: "Name",
                      icon: Icon(Icons.person),
                      isValidationRequired: true,
                      controller: controller.name,
                      isEnabled: !controller.isSaving.value && enableEdit),
                  16.height,
                  DropdownSearch<String>(
                    enabled: !controller.isSaving.value && enableEdit,
                    items: Role.list,
                    mode: Mode.MENU,
                    selectedItem: controller.selectedRole,
                    onChanged: (value) => controller.selectedRole = value,
                    validator: (value) =>
                        value.isEmptyOrNull ? "This field is required" : null,
                    dropdownSearchDecoration: InputDecoration(
                        labelText: "Role",
                        prefixIcon: Icon(Icons.person_pin_rounded)),
                  ),
                  16.height,
                  inputText(
                    isEnabled: user.id.isEmptyOrNull && enableEdit,
                    label: "Email",
                    icon: Icon(Icons.email_outlined),
                    textFieldType: TextFieldType.EMAIL,
                    controller: controller.email,
                    isValidationRequired: true,
                  ),
                  16.height,
                  inputText(
                    label: "Password",
                    isEnabled: enableEdit && user.id.isEmptyOrNull,
                    icon: Icon(Icons.lock_outline),
                    textFieldType: TextFieldType.PASSWORD,
                    controller: controller.password,
                    isValidationRequired: user.id.isEmptyOrNull,
                  ),
                  inputText(
                    isEnabled: enableEdit && user.id.isEmptyOrNull,
                    label: "Confirm Password",
                    icon: Icon(Icons.lock_outline),
                    textFieldType: TextFieldType.PASSWORD,
                    controller: controller.cpassword,
                    isValidationRequired: user.id.isEmptyOrNull,
                    validator: user.id.isEmptyOrNull
                        ? controller.cpasswordValidator
                        : null,
                  ),
                  16.height,
                  if (enableEdit)
                    DefaultButton(
                      text: "Submit",
                      width: Get.width,
                      isSaving: controller.isSaving.value,
                      onTap: () async {
                        if (_key.currentState!.validate()) {
                          await controller.store(user);
                        }
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
