import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:grafika_cafe/app/const/color.dart';

Widget text(
  String? text, {
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  bool isLongText = false,
  bool isCentered = false,
}) =>
    Text(
      text ?? '',
      textAlign: isCentered ? TextAlign.center : null,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        overflow: isLongText ? TextOverflow.visible : TextOverflow.ellipsis,
      ),
    );
inputText(
    {TextFieldType textFieldType = TextFieldType.NAME,
    TextEditingController? controller,
    bool? isValidationRequired,
    bool? isEnabled,
    bool? isReadOnly,
    bool? digitsOnly,
    Icon? icon,
    String? label,
    String? initValue,
    String? hint,
    Color? suffixColor,
    String? Function(String?)? validator}) {
  return AppTextField(
    controller: controller,
    isValidationRequired: isValidationRequired,
    inputFormatters:
        (digitsOnly ?? false) ? [FilteringTextInputFormatter.digitsOnly] : null,
    textFieldType: textFieldType,
    decoration: InputDecoration(
      prefixIcon: icon,
      labelText: label,
      hintText: hint,
      suffixIconColor: suffixColor,
    ),
    enabled: isEnabled,
    readOnly: isReadOnly,
    validator: validator,
    initialValue: initValue,
  );
}

class InputText extends StatelessWidget {
  InputText({
    this.textFieldType = TextFieldType.NAME,
    this.controller,
    this.isValidationRequired,
    this.isEnabled,
    this.isReadOnly,
    this.icon,
    this.label,
    this.initValue,
    this.hint,
    this.suffixColor,
    this.validator,
  });

  TextFieldType textFieldType = TextFieldType.NAME;
  TextEditingController? controller;
  bool? isValidationRequired;
  bool? isEnabled;
  bool? isReadOnly;
  Icon? icon;
  String? label;
  String? initValue;
  String? hint;
  Color? suffixColor;
  String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      isValidationRequired: isValidationRequired,
      textFieldType: textFieldType,
      decoration: InputDecoration(
        prefixIcon: icon,
        labelText: label,
        hintText: hint,
        suffixIconColor: suffixColor,
      ),
      enabled: isEnabled,
      readOnly: isReadOnly,
      validator: validator,
      initialValue: initValue,
    );
  }
}

class DefaultButton extends StatelessWidget {
  DefaultButton({
    this.text,
    this.isSaving = false,
    this.onTap,
    this.width,
  });
  String? text;
  Function? onTap;
  bool isSaving;
  double? width;
  @override
  Widget build(BuildContext context) {
    return AppButton(
      shapeBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      width: width,
      text: text,
      child: isSaving ? CircularProgressIndicator() : null,
      color: clr_primary,
      textColor: clr_white,
      onTap: isSaving ? null : onTap,
    );
  }
}

class BoxContainer extends StatelessWidget {
  BoxContainer(
      {this.children = const [],
      this.padding = 16,
      this.height,
      this.width,
      this.radius,
      this.elevation,
      this.color,
      this.crossAxis,
      this.mainAxis});
  List<Widget> children;
  double padding;
  double? height;
  double? width;
  double? radius;
  double? elevation;
  Color? color;
  MainAxisAlignment? mainAxis;
  CrossAxisAlignment? crossAxis;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: color ?? clr_white,
      elevation: elevation ?? 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 16)),
      child: Container(
        height: height,
        alignment: Alignment.centerLeft,
        width: width,
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: crossAxis ?? CrossAxisAlignment.start,
          mainAxisAlignment: mainAxis ?? MainAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
