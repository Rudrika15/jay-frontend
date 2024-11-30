import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../provider/login_provider.dart';
import '/helper/height_width_helper.dart';
import '/helper/string_helper.dart';
import '/mixins/navigator_mixin.dart';
import '/widget/text_form_field_custom.dart';
import '../theme/app_colors.dart';
import 'navbar.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with NavigatorMixin {
  bool showPassword = false;
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _passwordController = TextEditingController();
  final buttonEnabled = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _numberController.addListener(_handleInputChange);
    _passwordController.addListener(_handleInputChange);
  }

  @override
  void dispose() {
    _numberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _handleInputChange() {
    buttonEnabled.value = _numberController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LoginProvider>(builder: (context, loginProvider, _) {
        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Login',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    TextFormFieldWidget(
                        isFilled: true,
                        prefixWidget: Icon(
                          Icons.phone,
                          color: AppColors.onPrimaryBlack,
                        ),
                        hintText: StringHelper.mobileTextFieldHint,
                        fillColor: AppColors.backgroundLight,
                        validator: (value) {
                          if (value == null ||
                              value.length != 10 ||
                              value == '' ||
                              value.isEmpty) {
                            return StringHelper.incorrectMobileNoWarning;
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onChanged: (p0) {
                          _handleInputChange();
                        },
                        keyboardType: TextInputType.phone,
                        controller: _numberController),
                    SizedBox(height: 16),
                    TextFormFieldWidget(
                      obscureText: !showPassword,
                      controller: _passwordController,
                      // obscureText: _obscureText,
                      onChanged: (p0) {
                        _handleInputChange();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty || value == '') {
                          return StringHelper.incorrectPasswordWarning;
                        }
                        return null;
                      },
                      isFilled: true,
                      fillColor: AppColors.backgroundLight,
                      hintText: StringHelper.passWordTextFieldHint,
                      prefixWidget: Icon(
                        Icons.password,
                        color: AppColors.onPrimaryBlack,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(showPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          showPassword = !showPassword;
                          setState(() {});
                        },
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ValueListenableBuilder<bool>(
                              valueListenable: buttonEnabled,
                              builder: (context, enabled, _) {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: Size(
                                          screenWidth(context: context), 56),
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold)),
                                  onPressed: enabled
                                      ? () async {
                                          setState(() {});
                                          if (_formKey.currentState!
                                              .validate()) {
                                            await loginProvider
                                                .getUserToken(
                                                    phone:
                                                        _numberController.text,
                                                    password:
                                                        _passwordController
                                                            .text).then((value) {
                                                if (value)
                                                  pushReplacement(
                                                      context, Navbar());

                                              },
                                            );
                                          }
                                        }
                                      : null,
                                  child: (loginProvider.isLoading)
                                      ? CircularProgressIndicator(
                                          color: AppColors.onPrimaryLight,
                                        )
                                      : Text(
                                          StringHelper.login,
                                        ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
