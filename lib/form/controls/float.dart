import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frappe_app/form/controls/base_control.dart';
import 'package:frappe_app/form/controls/base_input.dart';
import 'package:frappe_app/model/doctype_response.dart';

class Float extends StatelessWidget with Control, ControlInput {
  final DoctypeField doctypeField;

  final Key? key;
  final Map? doc;

  const Float({
    required this.doctypeField,
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

    return FormBuilderTextField(
      key: key,
      initialValue: doc != null
          ? doc![doctypeField.fieldname] != null
              ? doc![doctypeField.fieldname].toString()
              : null
          : null,
      keyboardType: TextInputType.number,
      name: doctypeField.fieldname,
      decoration: Palette.formFieldDecoration(
        label: doctypeField.label,
      ),
      validator: FormBuilderValidators.compose(validators),
    );
  }
}
