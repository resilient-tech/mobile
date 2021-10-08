import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frappe_app/config/frappe_palette.dart';
import 'package:frappe_app/config/palette.dart';
import 'package:frappe_app/form/controls/base_control.dart';
import 'package:frappe_app/form/controls/base_input.dart';
import 'package:frappe_app/model/common.dart';
import 'package:frappe_app/model/doctype_response.dart';
import 'package:frappe_app/widgets/custom_form_builder_checkbox.dart';

class Check extends StatelessWidget with Control, ControlInput {
  final DoctypeField doctypeField;
  final OnControlChanged? onControlChanged;
  final Key? key;
  final Map? doc;
  final Function? onChanged;

  const Check({
    required this.doctypeField,
    this.onChanged,
    this.onControlChanged,
    this.key,
    this.doc,
  });

  @override
  Widget build(BuildContext context) {
    List<String? Function(dynamic)> validators = [];

    var f = setMandatory(doctypeField);

    if (f != null) {
      validators.add(
        f(context),
      );
    }

    return CustomFormBuilderCheckbox(
      name: doctypeField.fieldname,
      key: key,
      valueTransformer: (val) {
        return val == true ? 1 : 0;
      },
      activeColor: FrappePalette.blue,
      initialValue: doc != null ? doc![doctypeField.fieldname] == 1 : null,
      onChanged: (val) {
        if (onControlChanged != null) {
          onControlChanged!(
            FieldValue(
              field: doctypeField,
              value: val == true ? 1 : 0,
            ),
          );
        }
      },
      label: Text(
        doctypeField.label!,
      ),
      decoration: Palette.formFieldDecoration(
        label: doctypeField.label,
        filled: false,
        field: "check",
      ),
      validator: FormBuilderValidators.compose(validators),
    );
  }
}
