import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frappe_app/form/controls/base_control.dart';
import 'package:frappe_app/form/controls/base_input.dart';
import 'package:frappe_app/model/doctype_response.dart';

class Date extends StatelessWidget with Control, ControlInput {
  final DoctypeField doctypeField;

  final Key? key;
  final Map? doc;

  const Date({
    this.key,
    required this.doctypeField,
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

    return FormBuilderDateTimePicker(
      key: key,
      inputType: InputType.date,
      valueTransformer: (val) {
        return val?.toIso8601String();
      },
      initialValue:
          doc != null ? parseDate(doc![doctypeField.fieldname]) : null,
      keyboardType: TextInputType.number,
      name: doctypeField.fieldname,
      decoration: Palette.formFieldDecoration(
        label: doctypeField.label,
      ),
      validator: FormBuilderValidators.compose(validators),
    );
  }
}
