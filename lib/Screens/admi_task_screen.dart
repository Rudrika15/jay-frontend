import 'dart:async';
import 'package:flipcodeattendence/helper/string_helper.dart';
import 'package:flipcodeattendence/provider/task_provider.dart';
import 'package:flipcodeattendence/theme/app_colors.dart';
import 'package:flipcodeattendence/widget/call_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../widget/text_form_field_custom.dart';

class AdminTaskScreen extends StatefulWidget {
  const AdminTaskScreen({super.key});

  @override
  State<AdminTaskScreen> createState() => _AdminTaskScreenState();
}

class _AdminTaskScreenState extends State<AdminTaskScreen> {
  final formKey = GlobalKey<FormState>();
  final taskController = TextEditingController();
  final searchController = TextEditingController();
  DateTime? selectedDate;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false).getAllEmployeeTask(
        context: context,
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }

  @override
  void dispose() {
    super.dispose();
    taskController.dispose();
    _debounce?.cancel();
  }

  Future<void> refreshPage() async {
    Provider.of<TaskProvider>(context, listen: false)
        .getAllEmployeeTask(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringHelper.taskPageTitle),
      ),
      body: Consumer<TaskProvider>(builder: (context, taskProvider, _) {
        return RefreshIndicator(
          onRefresh: () async => refreshPage(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: (taskProvider.isLoading)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      TextFormFieldWidget(
                        isFilled: true,
                        prefixWidget: Icon(
                          CupertinoIcons.search,
                          color: AppColors.onPrimaryBlack,
                        ),
                        hintText: StringHelper.search,
                        borderColor: AppColors.grey,
                        fillColor: AppColors.onPrimaryLight,
                        onChanged: (value) {
                          if (_debounce?.isActive ?? false) _debounce?.cancel();
                          _debounce =
                              Timer(const Duration(milliseconds: 800), () {
                            if (value.trim().isEmpty) {
                              taskProvider.getAllEmployeeTask(context: context);
                            } else {
                              searchController.text = value.trim();
                              if (selectedDate == null) {
                                taskProvider.getAllEmployeeTask(
                                    context: context,
                                    name: searchController.text);
                              } else {
                                taskProvider.getAllEmployeeTask(
                                    context: context,
                                    date: DateFormat('yyyy-MM-dd')
                                        .format(selectedDate!),
                                    name: searchController.text);
                              }
                            }
                          });
                        },
                        controller: searchController,
                        suffixIcon: IconButton(
                          onPressed: () async {
                            selectedDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1947, 1, 1),
                                lastDate: DateTime.now());
                            if (selectedDate != null) {
                              taskProvider.getAllEmployeeTask(
                                  context: context,
                                  date: DateFormat('yyyy-MM-dd')
                                      .format(selectedDate!),
                                  name: searchController.text);
                            }
                          },
                          icon: Icon(Icons.date_range),
                        ),
                      ),
                      SizedBox(height: 16),
                      (taskProvider.allEmployeeTaskModel == null ||
                              taskProvider
                                      .allEmployeeTaskModel?.data?.isEmpty ==
                                  true)
                          ? Expanded(
                              child: Center(child: Text(StringHelper.noTask)))
                          : Expanded(
                              child: Container(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final task = taskProvider
                                        .allEmployeeTaskModel?.data?[index];
                                    return UserTaskWidget(
                                      task: task?.task?.task,
                                      id: task?.id.toString(),
                                      name: task?.name,
                                      phone: task?.phone,
                                      onPressedEdit: () {},
                                      onPressedDelete: () async {},
                                    );
                                  },
                                  itemCount: taskProvider
                                          .allEmployeeTaskModel?.data?.length ??
                                      0,
                                ),
                              ),
                            )
                    ],
                  ),
          ),
        );
      }),
    );
  }
}

class UserTaskWidget extends StatelessWidget {
  final void Function()? onPressedEdit, onPressedDelete;
  final String? name, task, id, phone;

  const UserTaskWidget({
    super.key,
    required this.task,
    this.onPressedEdit,
    this.onPressedDelete,
    this.name,
    this.id,
    this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.grey.withOpacity(0.5))),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            childrenPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
            title: Row(
              children: [
                CircleAvatar(
                    backgroundColor: (task?.isEmpty ?? true)
                        ? AppColors.red
                        : AppColors.green,
                    radius: 4),
                SizedBox(width: 8),
                Expanded(
                    child: Text(name ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: AppColors.aPrimary,
                              shape: BoxShape.circle),
                          child: IconButton(
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: task ?? ''));
                            },
                            icon: const Icon(
                              Icons.copy,
                              color: AppColors.onPrimaryLight,
                            ),
                            style: IconButton.styleFrom(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: AppColors.green, shape: BoxShape.circle),
                            child: CallWidget(
                                phoneNumber: phone,
                                iconColor: AppColors.onPrimaryLight)),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Text(task ?? ''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
