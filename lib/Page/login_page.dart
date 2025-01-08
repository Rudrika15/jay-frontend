import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../featuers/Admin/page/admin_nav_bar.dart';
import '../featuers/Client/page/client_nav_bar.dart';
import '../featuers/User/page/user_nav_bar.dart';
import '../helper/enum_helper.dart';
import '../provider/login_provider.dart';
import '/helper/height_width_helper.dart';
import '/helper/string_helper.dart';
import '/mixins/navigator_mixin.dart';
import '/widget/text_form_field_custom.dart';
import '../theme/app_colors.dart';

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
  var selectedUserType = UserRole.admin;

  @override
  void initState() {
    super.initState();
    // _numberController.text = "9909941341";
    // _passwordController.text = "123456";
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
                    Image.asset(StringHelper.appLogo),
                    const SizedBox(height: 24.0),
                    TextFormFieldWidget(
                        prefixWidget: Icon(
                          Icons.phone,
                          color: AppColors.onPrimaryBlack,
                        ),
                        hintText: StringHelper.mobileTextFieldHint,
                        validator: (value) {
                          if (value == null ||
                              value.length != 10 ||
                              value.trim().isEmpty) {
                            return StringHelper.incorrectMobileNoWarning;
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onChanged: (p0) => _handleInputChange(),
                        keyboardType: TextInputType.phone,
                        controller: _numberController),
                    SizedBox(height: 16),
                    TextFormFieldWidget(
                      obscureText: !showPassword,
                      controller: _passwordController,
                      // obscureText: _obscureText,
                      onChanged: (p0) => _handleInputChange(),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return StringHelper.incorrectPasswordWarning;
                        }
                        return null;
                      },
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
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: SegmentedButton(
                    //         segments: <ButtonSegment<UserRole>>[
                    //           ButtonSegment(
                    //               value: UserRole.admin,
                    //               label: Text(
                    //                   UserRole.admin.name.capitalizeFirst!)),
                    //           ButtonSegment(
                    //               value: UserRole.user,
                    //               label: Text(
                    //                   UserRole.user.name.capitalizeFirst!)),
                    //           ButtonSegment(
                    //               value: UserRole.client,
                    //               label: Text(
                    //                   UserRole.client.name.capitalizeFirst!)),
                    //         ],
                    //         selected: <UserRole>{selectedUserType},
                    //         onSelectionChanged: (Set<UserRole> value) {
                    //           setState(() {
                    //             if (value.first == UserRole.admin) {
                    //               _numberController.text = "9909941341";
                    //               _passwordController.text = "123456";
                    //             } else if (value.first == UserRole.user) {
                    //               _numberController.text = "9409991814";
                    //               _passwordController.text = "123456";
                    //             } else {
                    //               _numberController.text = "9426975796";
                    //               _passwordController.text = "123456";
                    //             }
                    //             selectedUserType = value.first;
                    //           });
                    //         },
                    //         showSelectedIcon: false,
                    //         style: SegmentedButton.styleFrom(
                    //             shape: StadiumBorder(),
                    //             side: BorderSide(color: AppColors.aPrimary),
                    //             selectedBackgroundColor: AppColors.aPrimary,
                    //             selectedForegroundColor:
                    //                 AppColors.onPrimaryLight),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ValueListenableBuilder<bool>(
                              valueListenable: buttonEnabled,
                              builder: (context, enabled, _) {
                                final enabled = true;
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: StadiumBorder(),
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
                                                            .text)
                                                .then(
                                              (value) async {
                                                if (value) {
                                                  final isAdmin = context
                                                      .read<LoginProvider>()
                                                      .isAdmin;
                                                  final isUser = context
                                                      .read<LoginProvider>()
                                                      .isUser;
                                                  (isAdmin)
                                                      ? pushReplacement(context,
                                                          AdminNavbar())
                                                      : (isUser)
                                                          ? pushReplacement(
                                                              context,
                                                              UserNavbar())
                                                          : pushReplacement(
                                                              context,
                                                              ClientNavbar());
                                                }
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
