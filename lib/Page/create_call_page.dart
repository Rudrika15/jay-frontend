import 'dart:io';
import 'package:flipcodeattendence/helper/string_helper.dart';
import 'package:flipcodeattendence/helper/validation_helper.dart';
import 'package:flipcodeattendence/mixins/navigator_mixin.dart';
import 'package:flipcodeattendence/provider/client_provider.dart';
import 'package:flipcodeattendence/provider/login_provider.dart';
import 'package:flipcodeattendence/widget/actions_widget.dart';
import 'package:flipcodeattendence/widget/custom_elevated_button.dart';
import 'package:flipcodeattendence/widget/text_form_field_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../featuers/Admin/page/client_list_page.dart';
import '../helper/file_picker_helper.dart';
import '../theme/app_colors.dart';
import '../widget/common_widgets.dart';

class CreateCallPage extends StatefulWidget {
  const CreateCallPage({super.key});

  @override
  State<CreateCallPage> createState() => _CreateCallPageState();
}

class _CreateCallPageState extends State<CreateCallPage> with NavigatorMixin {
  File? file;
  String? clientId;
  late final bool isAdmin;
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _textController = TextEditingController();
  final _clientController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isAdmin = context.read<LoginProvider>().isAdmin;
    _dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    _dateController.dispose();
    _textController.dispose();
    _clientController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(CupertinoIcons.clear)),
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
                          setState(() => file = pickedFile);
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
                          setState(() => file = pickedFile);
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
                controller: _dateController,
                readOnly: true,
                suffixIcon: const Icon(Icons.calendar_month),
                validator: (value) {
                  return (value == null || value.trim().isEmpty)
                      ? 'Please select date'
                      : null;
                },
                onTap: () async {
                  final initialDate = _dateController.text.isEmpty
                      ? DateTime.now()
                      : DateFormat('dd-MM-yyyy').parse(_dateController.text);
                  final pickedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                    initialDate: initialDate,
                    currentDate: DateTime.now(),
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                  );
                  if (pickedDate != null)
                    _dateController.text =
                        DateFormat('dd-MM-yyyy').format(pickedDate);
                },
              ),
              const SizedBox(height: 16.0),
              if (isAdmin) ...[
                TextFormFieldWidget(
                  labelText: 'Select client',
                  controller: _clientController,
                  readOnly: true,
                  suffixIcon: _clientController.text.trim().isEmpty
                      ? const Icon(Icons.arrow_drop_down_circle_outlined)
                      : IconButton(
                          onPressed: () =>
                              setState(() => _clientController.clear()),
                          icon: Icon(Icons.close)),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please select client';
                    } else {
                      return null;
                    }
                  },
                  onTap: () async {
                    final ({String? id, String? name})? clientRecord =
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ClientListPage()));
                    if (clientRecord != null) {
                      _clientController.text = clientRecord.name ?? '';
                      clientId = clientRecord.id;
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(height: 16.0),
              ],
              TextFormFieldWidget(
                controller: _textController,
                maxLines: 3,
                labelText: 'Description',
                validator: (value) => value?.isEmptyString,
              ),
              const SizedBox(height: 16.0),
              TextFormFieldWidget(
                controller: _addressController,
                maxLines: 3,
                labelText: 'Address',
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
                    buttonText: 'Submit',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final date = DateFormat('dd-MM-yyyy')
                            .parse(_dateController.text);
                        final formattedDate =
                            DateFormat('yyyy-MM-dd').format(date);
                        final result = await Provider.of<ClientProvider>(
                                context,
                                listen: false)
                            .createCall(
                                context: context,
                                description: _textController.text,
                                date: formattedDate,
                                client_id: clientId,
                                address: _addressController.text,
                                photo: file);
                        if (result) {
                          clearData();
                          Navigator.pop(context, true);
                        }
                      }
                    })),
          ],
        ),
      ),
    );
  }

  void clearData() {
    setState(() {
      file = null;
      clientId = null;
      _dateController.clear();
      _clientController.clear();
      _textController.clear();
    });
  }
}
