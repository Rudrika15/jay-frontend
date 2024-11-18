import 'package:flipcodeattendence/helper/method_helper.dart';
import 'package:flipcodeattendence/helper/string_helper.dart';
import 'package:flipcodeattendence/models/employee_tasks_model.dart';
import 'package:flipcodeattendence/provider/task_provider.dart';
import 'package:flipcodeattendence/theme/app_colors.dart';
import 'package:flipcodeattendence/widget/dialog_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../helper/height_width_helper.dart';
import '../widget/text_form_field_custom.dart';
import 'home/admin_home.dart';

class EmployeeTaskScreen extends StatefulWidget {
  const EmployeeTaskScreen({super.key});

  @override
  State<EmployeeTaskScreen> createState() => _EmployeeTaskScreenState();
}

class _EmployeeTaskScreenState extends State<EmployeeTaskScreen> {
  final formKey = GlobalKey<FormState>();
  final taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false)
        .getTasks(context: context);
  }

  @override
  void dispose() {
    super.dispose();
    taskController.dispose();
  }

  Future<void> refreshPage() async {
    Provider.of<TaskProvider>(context, listen: false)
        .getTasks(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringHelper.taskPageTitle),
        actions: [
          NotificationButton(
            isAdmin: false,
          ),
        ],
      ),
      body: Consumer<TaskProvider>(builder: (context, taskProvider, _) {
        return RefreshIndicator(
          onRefresh: () async => refreshPage(),
          child: Column(
            children: [
              (taskProvider.isLoading)
                  ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : (taskProvider.employeeTasksModel == null ||
                          taskProvider.employeeTasksModel?.data?.isEmpty ==
                              true)
                      ? Expanded(
                          child: Center(child: Text(StringHelper.noTask)))
                      : Expanded(
                          child: Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              itemBuilder: (context, index) {
                                final task = taskProvider
                                    .employeeTasksModel?.data?[index];
                                return TaskWidget(
                                  task: task,
                                  onPressedEdit: () {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) {
                                          return ReadWriteTaskBottomSheetWidget(
                                            taskText: task?.task,
                                            taskId: task?.id?.toString(),
                                            wantToUpdateTask: true,
                                          );
                                        });
                                  },
                                  onPressedDelete: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return DialogWidget(
                                              icon: CupertinoIcons.trash,
                                              text: StringHelper
                                                  .taskDeleteWarning,
                                              buttonText: StringHelper.yes,
                                              onPressed: () async {
                                                await taskProvider
                                                    .deleteTask(
                                                        context: context,
                                                        id: task?.id
                                                                ?.toString() ??
                                                            '')
                                                    .then((value) {
                                                  if (value) {
                                                    Navigator.of(context).pop();
                                                    refreshPage();
                                                  } else {
                                                    Navigator.of(context).pop();
                                                  }
                                                });
                                              },
                                              context: context);
                                        });
                                  },
                                );
                              },
                              itemCount: taskProvider
                                      .employeeTasksModel?.data?.length ??
                                  0,
                            ),
                          ),
                        )
            ],
          ),
        );
      }),
      floatingActionButton:
          Consumer<TaskProvider>(builder: (context, taskProvider, _) {
        return Offstage(
          offstage: !taskProvider.canAddTask,
          child: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return ReadWriteTaskBottomSheetWidget();
                  });
            },
            child: const Icon(Icons.add, color: AppColors.onPrimaryLight),
            backgroundColor: AppColors.aPrimary,
          ),
        );
      }),
    );
  }
}

class ReadWriteTaskBottomSheetWidget extends StatefulWidget {
  final String? taskId;
  final String? taskText;
  final bool wantToUpdateTask;

  const ReadWriteTaskBottomSheetWidget(
      {super.key, this.taskText, this.wantToUpdateTask = false, this.taskId});

  @override
  State<ReadWriteTaskBottomSheetWidget> createState() =>
      _ReadWriteTaskBottomSheetWidgetState();
}

class _ReadWriteTaskBottomSheetWidgetState
    extends State<ReadWriteTaskBottomSheetWidget> {
  final formKey = GlobalKey<FormState>();
  final taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setTaskText();
  }

  @override
  void dispose() {
    super.dispose();
    taskController.dispose();
  }

  void setTaskText() {
    if (widget.taskText?.trim() != null ||
        widget.taskText?.trim().isNotEmpty == true) {
      taskController.text = widget.taskText?.trim() ?? '';
    } else {
      taskController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: StatefulBuilder(builder: (context, setState) {
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.onPrimaryLight,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
            padding: EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringHelper.todayTaskTitle,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  TextFormFieldWidget(
                    isFilled: true,
                    maxLines: 12,
                    hintText: StringHelper.enterTask,
                    fillColor: AppColors.backgroundLight,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value?.trim().isEmpty ?? false) {
                        return StringHelper.emptyTaskWarning;
                      }
                      return null;
                    },
                    controller: taskController,
                  ),
                  SizedBox(height: 20),
                  Consumer<TaskProvider>(builder: (context, taskProvider, _) {
                    return Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.grey,
                                fixedSize:
                                    Size(screenWidth(context: context), 56),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              taskController.clear();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              StringHelper.close,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
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
                              if (formKey.currentState!.validate()) {
                                if (widget.wantToUpdateTask) {
                                  bool isSuccess =
                                      await taskProvider.updateTask(
                                          context: context,
                                          id: widget.taskId ?? '',
                                          updatedTaskText:
                                              taskController.text.trim());
                                  if (isSuccess) {
                                    taskController.clear();
                                    Navigator.of(context).pop();
                                    taskProvider.getTasks(context: context);
                                  } else {
                                    taskController.clear();
                                    Navigator.of(context).pop();
                                  }
                                } else {
                                  bool isSuccess =
                                      await taskProvider.submitTask(
                                          context: context,
                                          taskText: taskController.text.trim());
                                  if (isSuccess) {
                                    taskController.clear();
                                    Navigator.of(context).pop();
                                    taskProvider.getTasks(context: context);
                                    MethodHelper.showSnackBar(
                                        message: StringHelper.taskAddSuccess);
                                  } else {
                                    taskController.clear();
                                    Navigator.of(context).pop();
                                    MethodHelper.showSnackBar(
                                        message: StringHelper.taskAddFailure,
                                        isSuccess: false);
                                  }
                                }
                              }
                            },
                            child: Text(
                              StringHelper.submit,
                            ),
                          ),
                        ),
                      ],
                    );
                  })
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class TaskWidget extends StatelessWidget {
  final void Function()? onPressedEdit, onPressedDelete;

  const TaskWidget({
    super.key,
    required this.task,
    this.onPressedEdit,
    this.onPressedDelete,
  });

  final Data? task;

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
            childrenPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            // title: Text(task?.createdAt?.substring(0, 10) ?? ''),
            title: Text(
                MethodHelper.customDateFormateForDateRange(task?.createdAt)),
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
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: task?.task ?? ''));
                          },
                          icon: const Icon(
                            Icons.copy,
                            color: AppColors.aPrimary,
                          ),
                          style: IconButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                    Text(task?.task ?? ''),
                    SizedBox(height: 12),
                    Offstage(
                      offstage: !MethodHelper.isCurrentDate(task?.createdAt),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                                onPressed: onPressedEdit,
                                label: const Text(StringHelper.edit,
                                    style: TextStyle(color: AppColors.green)),
                                icon: const Icon(
                                  Icons.edit,
                                  color: AppColors.green,
                                )),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                                onPressed: onPressedDelete,
                                label: const Text(StringHelper.delete,
                                    style: TextStyle(color: AppColors.red)),
                                icon: const Icon(
                                  CupertinoIcons.trash,
                                  color: AppColors.red,
                                )),
                          )
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
}