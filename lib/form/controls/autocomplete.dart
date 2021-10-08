import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/config/palette.dart';
import 'package:frappe_app/form/controls/base_control.dart';
import 'package:frappe_app/form/controls/base_input.dart';
import 'package:frappe_app/model/common.dart';
import 'package:frappe_app/model/doctype_response.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/widgets/form_builder_typeahead.dart';

typedef String SelectionToTextTransformer<T>(T selection);

class AutoComplete extends StatefulWidget {
  final DoctypeField doctypeField;
  final OnControlChanged? onControlChanged;

  final Map? doc;
  final void Function(dynamic)? onSuggestionSelected;
  final Widget? suffixIcon;
  final Key? key;
  final ItemBuilder? itemBuilder;
  final SuggestionsCallback? suggestionsCallback;
  final SelectionToTextTransformer? selectionToTextTransformer;
  final InputDecoration? inputDecoration;
  final TextEditingController? controller;

  AutoComplete({
    required this.doctypeField,
    this.onControlChanged,
    this.doc,
    this.controller,
    this.inputDecoration,
    this.suffixIcon,
    this.key,
    this.onSuggestionSelected,
    this.itemBuilder,
    this.suggestionsCallback,
    this.selectionToTextTransformer,
  });

  @override
  _AutoCompleteState createState() => _AutoCompleteState();
}

class _AutoCompleteState extends State<AutoComplete>
    with Control, ControlInput {
  late TextEditingController _typeAheadController;

  @override
  void initState() {
    _typeAheadController = widget.controller ?? TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String? Function(dynamic)> validators = [];
    final f = setMandatory(widget.doctypeField);
    if (f != null) {
      validators.add(f(context));
    }

    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.black),
      child: FormBuilderTypeAhead<dynamic>(
        key: widget.key,
        controller: _typeAheadController,
        onSuggestionSelected: widget.onSuggestionSelected,
        onChanged: (val) {
          if (widget.onControlChanged != null) {
            widget.onControlChanged!(
              FieldValue(
                field: widget.doctypeField,
                value: val,
              ),
            );
          }
        },
        direction: AxisDirection.up,
        validator: FormBuilderValidators.compose(validators),
        decoration: widget.inputDecoration ??
            Palette.formFieldDecoration(
              suffixIcon: widget.suffixIcon ??
                  Center(child: FrappeIcon(FrappeIcons.select)),
            ),
        selectionToTextTransformer:
            widget.selectionToTextTransformer ?? (item) => item.toString(),
        name: widget.doctypeField.fieldname,
        itemBuilder: widget.itemBuilder ??
            (context, item) => ListTile(title: Text(item.toString())),
        initialValue: widget.doc?[widget.doctypeField.fieldname],
        suggestionsCallback: widget.suggestionsCallback ??
            (query) {
              final options = widget.doctypeField.options;
              final lowercaseQuery = query.toLowerCase();
              List opts =
                  options is String ? options.split('\n') : options ?? [];
              return opts
                  .where(
                    (option) => option.toLowerCase().contains(lowercaseQuery),
                  )
                  .toList();
            },
      ),
    );
  }
}
