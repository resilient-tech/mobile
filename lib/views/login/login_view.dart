import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frappe_app/config/palette.dart';
import 'package:frappe_app/form/controls/control.dart';
import 'package:frappe_app/model/common.dart';
import 'package:frappe_app/model/doctype_response.dart';
import 'package:frappe_app/model/login_request.dart';
import 'package:frappe_app/utils/enums.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/utils/http.dart';
import 'package:frappe_app/utils/navigation_helper.dart';
import 'package:frappe_app/views/base_view.dart';
import 'package:frappe_app/views/home_view.dart';
import 'package:frappe_app/views/login/login_viewmodel.dart';
import 'package:frappe_app/widgets/frappe_bottom_sheet.dart';
import 'package:frappe_app/widgets/frappe_button.dart';
import 'package:frappe_app/widgets/frappe_logo.dart';
import 'package:frappe_app/widgets/password_field.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 60),
              FrappeLogo(),
              SizedBox(height: 24),
              _buildTitle(),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    FormBuilder(
                      key: _fbKey,
                      child: Column(
                        children: <Widget>[
                          buildDecoratedControl(
                            control: FormBuilderTextField(
                              name: 'serverURL',
                              initialValue: model.savedCreds.serverURL,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                                FormBuilderValidators.url(context),
                              ]),
                              decoration: Palette.formFieldDecoration(
                                label: "Server URL",
                              ),
                            ),
                            field: DoctypeField(
                              fieldname: 'serverUrl',
                              label: "Server URL",
                            ),
                          ),
                          buildDecoratedControl(
                            control: FormBuilderTextField(
                              name: 'usr',
                              initialValue: model.savedCreds.usr,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                              ]),
                              decoration: Palette.formFieldDecoration(
                                label: "Email Address",
                              ),
                            ),
                            field: DoctypeField(
                                fieldname: "email", label: "Email Address"),
                          ),
                          PasswordField(),
                          FrappeFlatButton(
                            title: model.loginButtonLabel,
                            fullWidth: true,
                            height: 46,
                            buttonType: ButtonType.primary,
                            onPressed: () async {
                              FocusScope.of(context).requestFocus(
                                FocusNode(),
                              );

                              if (_fbKey.currentState != null) {
                                if (_fbKey.currentState!.saveAndValidate()) {
                                  var formValue = _fbKey.currentState?.value;

                                  try {
                                    await setBaseUrl(formValue!["serverURL"]);

                                    var loginRequest = LoginRequest(
                                      usr: formValue["usr"].trimRight(),
                                      pwd: formValue["pwd"],
                                    );

                                    var loginResponse = await model.login(
                                      loginRequest,
                                    );

                                    if (loginResponse.verification != null &&
                                        loginResponse.tmpId != null) {
                                      showModalBottomSheet(
                                        context: context,
                                        useRootNavigator: true,
                                        isScrollControlled: true,
                                        builder: (context) =>
                                            VerificationBottomSheetView(
                                          loginRequest: loginRequest,
                                          tmpId: loginResponse.tmpId!,
                                          message: loginResponse
                                              .verification!.prompt,
                                        ),
                                      );
                                    } else {
                                      NavigationHelper.pushReplacement(
                                        context: context,
                                        page: HomeView(),
                                      );
                                    }
                                  } on ErrorResponse catch (e) {
                                    if (e.statusCode ==
                                        HttpStatus.unauthorized) {
                                      FrappeAlert.errorAlert(
                                        title: "Not Authorized",
                                        subtitle: e.statusMessage,
                                        context: context,
                                      );
                                    } else {
                                      FrappeAlert.errorAlert(
                                        title: "Error",
                                        subtitle: e.statusMessage,
                                        context: context,
                                      );
                                    }
                                  } catch (e) {
                                    print("$e");
                                    FrappeAlert.errorAlert(
                                      title: "Error",
                                      subtitle: "Internal error occured!",
                                      context: context,
                                    );
                                  }
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Login to Frappe',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class VerificationBottomSheetView extends StatefulWidget {
  final String message;
  final String tmpId;
  final LoginRequest loginRequest;

  VerificationBottomSheetView({
    required this.message,
    required this.tmpId,
    required this.loginRequest,
  });

  @override
  _VerificationBottomSheetViewState createState() =>
      _VerificationBottomSheetViewState();
}

class _VerificationBottomSheetViewState
    extends State<VerificationBottomSheetView> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      builder: (context, model, child) => AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        child: FractionallySizedBox(
          heightFactor: 0.4,
          child: FrappeBottomSheet(
            title: 'Verification',
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Text(widget.message),
                  SizedBox(
                    height: 10,
                  ),
                  FormBuilder(
                    key: _fbKey,
                    child: buildDecoratedControl(
                      control: FormBuilderTextField(
                        name: 'otp',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        decoration: Palette.formFieldDecoration(
                          label: "Verification",
                        ),
                      ),
                      field: DoctypeField(
                        fieldname: 'otp',
                        label: "Verification",
                      ),
                    ),
                  ),
                  FrappeFlatButton(
                    title: model.loginButtonLabel,
                    fullWidth: true,
                    height: 46,
                    buttonType: ButtonType.primary,
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(
                        FocusNode(),
                      );

                      if (_fbKey.currentState != null) {
                        if (_fbKey.currentState!.saveAndValidate()) {
                          var formValue = _fbKey.currentState?.value;
                          widget.loginRequest.tmpId = widget.tmpId;
                          widget.loginRequest.otp = formValue!["otp"];
                          widget.loginRequest.cmd = "login";

                          try {
                            await model.login(widget.loginRequest);

                            NavigationHelper.pushReplacement(
                              context: context,
                              page: HomeView(),
                            );
                          } catch (e) {
                            var _e = e as ErrorResponse;

                            if (_e.statusCode == HttpStatus.unauthorized) {
                              FrappeAlert.errorAlert(
                                title: "Not Authorized",
                                subtitle: _e.statusMessage,
                                context: context,
                              );
                            } else {
                              FrappeAlert.errorAlert(
                                title: "Error",
                                subtitle: _e.statusMessage,
                                context: context,
                              );
                            }
                          }
                        }
                      }
                    },
                  ),
                  Container(
                    height: 100,
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
