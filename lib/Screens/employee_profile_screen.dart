import 'package:flipcodeattendence/Screens/admin_report_screen.dart';
import 'package:flipcodeattendence/Screens/home/admin_home.dart';
import 'package:flipcodeattendence/helper/string_helper.dart';
import 'package:flutter/cupertino.dart';

import '/mixins/navigator_mixin.dart';
import '/provider/login_provider.dart';
import '/widget/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/height_width_helper.dart';
import '../service/shared_preferences_service.dart';
import '../theme/app_colors.dart';
import '../widget/text_form_field_custom.dart';
import 'login_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with NavigatorMixin {
  bool showPassword = false;
  bool isAdmin = false;
  String? mobileNumber, name, userRole;
  final _formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    mobileNumber = await SharedPreferencesService.getUserMobileNo();
    name = await SharedPreferencesService.getUserName();
    userRole = await SharedPreferencesService.getUserRole();
    isAdminUser(userRole);
  }

  void isAdminUser(String? userRole) {
    final userType = userRole;
    if(userType != null) {
     (userType.trim().toLowerCase() == 'admin') ?
       isAdmin = true : isAdmin = false;
    } else {
      isAdmin = false;
    }
    setState(() {});
  }

  Future<void> _showLogoutDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogWidget(
            icon: CupertinoIcons.square_arrow_left,
            text: StringHelper.logoutWarning,
            buttonText: StringHelper.yes,
            onPressed: () async {
              await SharedPreferencesService.clearUserData();
              Navigator.pushAndRemoveUntil<void>(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => Login()),
                ModalRoute.withName('/'),
              );
            },
            context: context);
      },
    );
  }

  void clearControllers() {
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  changePasswordPopup() {
    clearControllers();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: StatefulBuilder(builder: (context, refresh) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    StringHelper.changePassword,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Divider(),
                  SizedBox(height: 10),
                  TextFormFieldWidget(
                    obscureText: !showPassword,
                    controller: oldPasswordController,
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return StringHelper.emptyOldPasswordWarning;
                      } else if (value!.isNotEmpty && value.length < 6) {
                        return StringHelper.invalidPasswordDigitsWarning;
                      }
                      return null;
                    },
                    isFilled: true,
                    fillColor: AppColors.backgroundLight,
                    hintText: StringHelper.enterOldPassword,
                    prefixWidget: Icon(
                      Icons.lock,
                      color: AppColors.onPrimaryBlack,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 15),
                  TextFormFieldWidget(
                    obscureText: !showPassword,
                    controller: newPasswordController,
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return StringHelper.emptyNewPasswordWarning;
                      } else if (value!.isNotEmpty && value.length < 6) {
                        return StringHelper.invalidPasswordDigitsWarning;
                      }
                      return null;
                    },
                    isFilled: true,
                    fillColor: AppColors.backgroundLight,
                    hintText: StringHelper.enterNewPassword,
                    prefixWidget: Icon(
                      Icons.lock,
                      color: AppColors.onPrimaryBlack,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 15),
                  TextFormFieldWidget(
                    obscureText: !showPassword,
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return StringHelper.emptyConfirmPasswordWarning;
                      } else if (value!.isNotEmpty &&
                          value != newPasswordController.text) {
                        return StringHelper.confirmPasswordNoMatchWarning;
                      }
                      ;
                      return null;
                    },
                    isFilled: true,
                    fillColor: AppColors.backgroundLight,
                    hintText: StringHelper.enterConfirmPassword,
                    prefixWidget: Icon(
                      Icons.lock,
                      color: AppColors.onPrimaryBlack,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: showPassword,
                        visualDensity: VisualDensity(horizontal: -4),
                        onChanged: (value) {
                          if (value != null) {
                            showPassword = !showPassword;
                            refresh(() {});
                          }
                        },
                      ),
                      Text(StringHelper.showPassword),
                    ],
                  ),
                  SizedBox(height: 15),
                  Consumer<LoginProvider>(
                      builder: (context, loginProvider, child) {
                    return Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize:
                                    Size(screenWidth(context: context), 56),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await loginProvider
                                    .changePassword(
                                        context: context,
                                        oldPassword: oldPasswordController.text,
                                        newPassword: newPasswordController.text)
                                    .then(
                                  (value) {
                                    Navigator.of(context).pop();
                                    clearControllers();
                                  },
                                );
                              }
                            },
                            child: (loginProvider.isLoading)
                                ? CircularProgressIndicator(
                                    color: AppColors.onPrimaryLight)
                                : Text(StringHelper.submit),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringHelper.profile,
        ),
        actions: [
          Consumer<LoginProvider>(
            builder: (context, loginValue, child) => NotificationButton(
              isAdmin: loginValue.userRole?.toLowerCase() == 'admin',
            ),
          ),
        ],
      ),
      body: Consumer<LoginProvider>(builder: (context, loginProvider, _) {
        return Column(
          children: [
            Container(
              height: 100,
              width: 100,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.aPrimary,
              ),
              child: Center(
                child: Text(
                  name?[0] ?? '',
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w500,
                      color: AppColors.backgroundLight),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              name ?? 'User',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              '+91 $mobileNumber',
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
            SizedBox(height: 24),
            Divider(
              height: 1,
            ),
            SizedBox(height: 12),
            ListTile(
              onTap: () {
                changePasswordPopup();
              },
              leading: Icon(Icons.edit),
              title: Text(StringHelper.changePassword),
            ),
            if(isAdmin) ...[
              ListTile(
                onTap: () {
                  push(context, AdminReportScreen());
                },
                leading: Icon(CupertinoIcons.doc_text),
                title: Text(StringHelper.report),
              ),
            ],
            ListTile(
              leading: Icon(CupertinoIcons.square_arrow_left),
              title: Text(StringHelper.logOut),
              onTap: () {
                _showLogoutDialog();
              },
            ),
            SizedBox(
              height: 12,
            ),
          ],
        );
      }),
    );
  }
}
