import 'dart:io';

import 'package:flipcodeattendence/helper/string_helper.dart';
import 'package:flipcodeattendence/helper/validation_helper.dart';
import 'package:flipcodeattendence/widget/actions_widget.dart';
import 'package:flipcodeattendence/widget/custom_elevated_button.dart';
import 'package:flipcodeattendence/widget/text_form_field_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helper/file_picker_helper.dart';
import '../theme/app_colors.dart';
import '../widget/common_widgets.dart';

class CreateCallPage extends StatefulWidget {
  const CreateCallPage({super.key});

  @override
  State<CreateCallPage> createState() => _CreateCallPageState();
}

class _CreateCallPageState extends State<CreateCallPage> {
  File? file;
  final _formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringHelper.createCall),
        titleSpacing: 0.0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (file != null) ...[
                CircleAvatar(radius: 70, backgroundImage: FileImage(file!))
              ] else ...[
                CircleAvatar(
                  radius: 70,
                  child: Icon(CupertinoIcons.photo),
                  backgroundColor: AppColors.secondary.withOpacity(0.3),
                )
              ],
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ActionWidget(
                    onTap: () async {
                      final pickedFile = await takePhoto();
                      if (pickedFile != null) {
                        if (pickedFile.lengthSync() > 2000000) {
                          CommonWidgets.customSnackBar(
                              context: context,
                              title: 'File cannot be larger than 2 MB');
                        } else {
                          setState(() {
                            file = pickedFile;
                          });
                        }
                      } else {
                        CommonWidgets.customSnackBar(
                            context: context, title: 'Photo not captured');
                      }
                    },
                    icon: CupertinoIcons.camera,
                  ),
                  const SizedBox(width: 16.0),
                  ActionWidget(
                    onTap: () async {
                      final pickedFile = await internalFilePicker();
                      if (pickedFile != null) {
                        if (pickedFile.lengthSync() > 2000000) {
                          CommonWidgets.customSnackBar(
                              context: context,
                              title: 'File cannot be larger than 2 MB');
                        } else {
                          setState(() {
                            file = pickedFile;
                          });
                        }
                      } else {
                        CommonWidgets.customSnackBar(
                            context: context, title: 'No file picked');
                      }
                    },
                    icon: CupertinoIcons.folder,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormFieldWidget(
                labelText: 'Select date',
                controller: dateController,
                readOnly: true,
                suffixIcon: const Icon(Icons.calendar_month),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please select date';
                  } else {
                    return null;
                  }
                },
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2025),
                    initialDate: DateTime.now(),
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                  );
                  if (pickedDate != null) {
                    dateController.text =
                        DateFormat('dd-MM-yyyy').format(pickedDate);
                  }
                },
              ),
              const SizedBox(height: 16.0),
              TextFormFieldWidget(
                controller: textController,
                maxLines: 10,
                labelText: 'Description',
                validator: (value) => value?.isEmptyString,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
        child: Row(
          children: [
            Expanded(
                child: CustomElevatedButton(
                    buttonText: 'Submit', onPressed: () {
                      if(_formKey.currentState!.validate()) {

                      }
                })),
          ],
        ),
      ),
    );
  }
}
