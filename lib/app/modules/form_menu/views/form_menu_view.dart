import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:grafika_cafe/app/data/models/menu_model.dart';
import 'package:grafika_cafe/app/data/models/user_model.dart';
import 'package:grafika_cafe/app/modules/auth/controllers/auth_controller.dart';
import 'package:grafika_cafe/app/routes/app_pages.dart';
import 'package:grafika_cafe/app/widgets/formFoto.dart';
import 'package:grafika_cafe/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/form_menu_controller.dart';

class FormMenuView extends GetView<FormMenuController> {
  GlobalKey<FormState> _key = GlobalKey();
  FormMenuView({required this.enableEdit});
  bool enableEdit;
  MenuModel menu = Get.arguments ?? MenuModel();
  AuthController authC = AuthController.instance;
  @override
  Widget build(BuildContext context) {
    FormFoto formFoto = FormFoto(
      showButton: enableEdit,
      oldPath: menu.photo ?? '',
    );
    controller.name.text = menu.name ?? '';
    controller.harga.text = (menu.harga ?? 0).toString();
    controller.keterangan.text = menu.keterangan ?? '';
    controller.selectedJenis = menu.jenis;

    return Scaffold(
        appBar: AppBar(
          title: Text('Form Menu'),
          centerTitle: true,
        ),
        floatingActionButton: !enableEdit &&
                (authC.user.hasRole(Role.admin) ||
                    authC.user.hasRole(Role.manajer))
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: '1',
                    onPressed: () {
                      Get.toNamed(Routes.FORM_MENU, arguments: menu);
                    },
                    child: Icon(Icons.edit),
                  ),
                  16.height,
                  FloatingActionButton(
                    heroTag: '2',
                    onPressed: () {
                      showConfirmDialog(context,
                          "Are you sure to delete user ${menu.name?.toUpperCase()}?",
                          onAccept: () async {
                        await menu.db.delete(menu.id!, url: menu.photo);
                        Get.back();
                      });
                    },
                    child: Icon(Icons.delete),
                  ),
                ],
              )
            : null,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Obx(
              () => Form(
                key: _key,
                child: Column(
                  children: [
                    formFoto,
                    16.height,
                    inputText(
                        label: "Name",
                        icon: Icon(Icons.receipt),
                        isValidationRequired: true,
                        controller: controller.name,
                        isEnabled: !controller.isSaving.value && enableEdit),
                    16.height,
                    DropdownSearch<String>(
                      enabled: !controller.isSaving.value && enableEdit,
                      items: Jenis.list,
                      mode: Mode.MENU,
                      selectedItem: controller.selectedJenis,
                      onChanged: (value) => controller.selectedJenis = value,
                      validator: (value) =>
                          value.isEmptyOrNull ? "This field is required" : null,
                      dropdownSearchDecoration: InputDecoration(
                          labelText: "Jenis Menu",
                          prefixIcon: Icon(Icons.person_pin_rounded)),
                    ),
                    16.height,
                    inputText(
                      isEnabled: menu.id.isEmptyOrNull && enableEdit,
                      label: "Harga",
                      digitsOnly: true,
                      icon: Icon(Icons.email_outlined),
                      textFieldType: TextFieldType.PHONE,
                      controller: controller.harga,
                      isValidationRequired: true,
                    ),
                    16.height,
                    inputText(
                      label: "Keterangan",
                      isEnabled: enableEdit && menu.id.isEmptyOrNull,
                      icon: Icon(Icons.lock_outline),
                      textFieldType: TextFieldType.MULTILINE,
                      controller: controller.keterangan,
                      isValidationRequired: false,
                    ),
                    16.height,
                    if (enableEdit)
                      DefaultButton(
                        text: "Submit",
                        width: Get.width,
                        isSaving: controller.isSaving.value,
                        onTap: () async {
                          if (_key.currentState!.validate()) {
                            await controller.save(menu, path: formFoto.newPath);
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
