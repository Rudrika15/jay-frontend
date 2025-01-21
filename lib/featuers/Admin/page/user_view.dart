import 'package:flipcodeattendence/mixins/navigator_mixin.dart';
import 'package:flipcodeattendence/widget/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../helper/string_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../widget/text_form_field_custom.dart';

enum _UserType { Client, Staff }

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserView();
}

class _UserView extends State<UserView> with NavigatorMixin {
  final _numberController = TextEditingController();
  final _nameController = TextEditingController();
  final buttonEnabled = ValueNotifier<bool>(false);
  var selectedUserType = _UserType.Client;

  @override
  void initState() {
    super.initState();
    _numberController.addListener(_handleInputChange);
    _nameController.addListener(_handleInputChange);
  }

  @override
  void dispose() {
    _numberController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _handleInputChange() {
    buttonEnabled.value = (_numberController.text.trim().isNotEmpty &&
            _numberController.text.trim().length == 10) &&
        (_nameController.text.trim().isNotEmpty);
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: SegmentedButton(
                    segments: [
                      ButtonSegment(
                        value: _UserType.Client,
                        label: Text(_UserType.Client.name.capitalizeFirst!),
                      ),
                      ButtonSegment(
                        value: _UserType.Staff,
                        label: Text(_UserType.Staff.name.capitalizeFirst!),
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
                        selectedForegroundColor:
                        AppColors.onPrimaryLight),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextFormFieldWidget(
                prefixWidget: Icon(
                  Icons.person,
                  color: AppColors.onPrimaryBlack,
                ),
                hintText: 'Name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
                onChanged: (p0) => _handleInputChange(),
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
                onChanged: (p0) => _handleInputChange(),
                keyboardType: TextInputType.phone,
                controller: _numberController),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ValueListenableBuilder<bool>(
                valueListenable: buttonEnabled,
                builder: (context, enabled, _) {
                  return Expanded(
                      child: CustomElevatedButton(
                          buttonText: 'Save',
                          onPressed: enabled ? () {} : null));
                })
          ],
        ),
      ),
    );
  }
}
