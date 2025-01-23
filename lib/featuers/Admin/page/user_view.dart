import 'package:flipcodeattendence/mixins/navigator_mixin.dart';
import 'package:flipcodeattendence/provider/attendance_provider.dart';
import 'package:flipcodeattendence/widget/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../helper/string_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../widget/text_form_field_custom.dart';

enum _UserType { Admin, User, Client }

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserView();
}

class _UserView extends State<UserView> with NavigatorMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _birthDateController = TextEditingController();
  var selectedUserType = _UserType.Admin;

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  void clearForm() {
    setState(() {
      _nameController.clear();
      _numberController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _birthDateController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create user'),
        leading: GestureDetector(
            onTap: () => pop(context), child: Icon(Icons.close)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SegmentedButton(
                        segments: [
                          ButtonSegment(
                            value: _UserType.Admin,
                            label: Text(_UserType.Admin.name.capitalizeFirst!),
                          ),
                          ButtonSegment(
                            value: _UserType.User,
                            label: Text(_UserType.User.name.capitalizeFirst!),
                          ),
                          ButtonSegment(
                            value: _UserType.Client,
                            label: Text(_UserType.Client.name.capitalizeFirst!),
                          )
                        ],
                        selected: {selectedUserType},
                        onSelectionChanged: (value) {
                          setState(() {
                            selectedUserType = value.first;
                          });
                        },
                        style: SegmentedButton.styleFrom(
                            side: BorderSide(color: AppColors.aPrimary),
                            selectedBackgroundColor: AppColors.aPrimary,
                            selectedForegroundColor: AppColors.onPrimaryLight),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextFormFieldWidget(
                    prefixWidget:
                        Icon(Icons.person, color: AppColors.onPrimaryBlack),
                    hintText: 'Name',
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Please enter name'
                            : null,
                    keyboardType: TextInputType.text,
                    controller: _nameController),
                SizedBox(height: 16),
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
                    keyboardType: TextInputType.phone,
                    controller: _numberController),
                SizedBox(height: 16),
                TextFormFieldWidget(
                    prefixWidget: Icon(
                      Icons.alternate_email_sharp,
                      color: AppColors.onPrimaryBlack,
                    ),
                    hintText: 'Email',
                    validator: (value) {
                      return (value?.trim().isEmpty ?? false)
                          ? 'Email is required'
                          : !value!.contains(RegExp(StringHelper.emailRegex))
                              ? 'Enter valid email'
                              : null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController),
                SizedBox(height: 16),
                TextFormFieldWidget(
                    prefixWidget: Icon(
                      Icons.password,
                      color: AppColors.onPrimaryBlack,
                    ),
                    hintText: 'Password',
                    validator: (value) {
                      return (value?.trim().isEmpty ?? false)
                          ? 'Password is required'
                          : (value!.length < 6)
                              ? 'Password should be 6 characters long'
                              : null;
                    },
                    keyboardType: TextInputType.number,
                    controller: _passwordController),
                SizedBox(height: 16),
                TextFormFieldWidget(
                    prefixWidget: Icon(
                      Icons.password,
                      color: AppColors.onPrimaryBlack,
                    ),
                    hintText: 'Confirm Password',
                    validator: (value) {
                      return (value?.trim().isEmpty ?? false)
                          ? 'Password is required'
                          : (value!.length < 6)
                              ? 'Password should be 6 characters long'
                              : (value.trim() !=
                                      _passwordController.text.trim())
                                  ? 'Password does not match'
                                  : null;
                    },
                    keyboardType: TextInputType.number,
                    controller: _confirmPasswordController),
                SizedBox(height: 16),
                TextFormFieldWidget(
                  readOnly: true,
                  prefixWidget: Icon(
                    Icons.date_range_outlined,
                    color: AppColors.onPrimaryBlack,
                  ),
                  hintText: 'Birth Date',
                  validator: (value) {
                    return (value?.trim().isEmpty ?? false)
                        ? 'Birth is required'
                        : null;
                  },
                  controller: _birthDateController,
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      firstDate:
                          DateTime.now().subtract(Duration(days: 365 * 100)),
                      lastDate: DateTime.now(),
                      initialDate: DateTime.now(),
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                    );
                    if (pickedDate != null) {
                      _birthDateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Consumer<AttendanceProvider>(builder: (context, value, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              value.isLoading
                  ? SizedBox(child: CircularProgressIndicator())
                  : Expanded(
                      child: CustomElevatedButton(
                          buttonText: 'Save',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final userDetails = {
                                "name": _nameController.text.trim(),
                                "email": _emailController.text.trim(),
                                "phone": _numberController.text.trim(),
                                "password": _passwordController.text.trim(),
                                "confirm_password":
                                    _confirmPasswordController.text.trim(),
                                "roles": selectedUserType.name.trim(),
                                "birthdate": _birthDateController.text,
                              };
                              createUser(userDetails);
                            }
                          }))
            ],
          );
        }),
      ),
    );
  }

  Future<void> createUser(Map<String, String> userDetails) async {
    await Provider.of<AttendanceProvider>(context, listen: false)
        .createUser(context, userDetails: userDetails)
        .then((value) {
      clearForm();
      pop(context);
    });
  }
}
