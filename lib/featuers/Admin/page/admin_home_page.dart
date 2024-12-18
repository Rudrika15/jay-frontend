import 'package:flipcodeattendence/Page/notification_page.dart';
import 'package:flipcodeattendence/helper/string_helper.dart';
import 'package:flipcodeattendence/mixins/navigator_mixin.dart';
import 'package:flipcodeattendence/featuers/Admin/model/daily_attendence_model.dart';
import 'package:flipcodeattendence/provider/attendance_provider.dart';
import 'package:flipcodeattendence/provider/task_provider.dart';
import 'package:flipcodeattendence/theme/app_colors.dart';
import 'package:flipcodeattendence/widget/call_widget.dart';
import 'package:flipcodeattendence/widget/text_form_field_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> with NavigatorMixin {
  DateTime? selectedDate;
  final TextEditingController_searchController = TextEditingController();

  @override
  void initState() {
    Provider.of<AttendanceProvider>(context, listen: false)
        .getDailyAttendence();
    Provider.of<TaskProvider>(context, listen: false).getAllEmployeeTask(
        context: context,
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    super.initState();
  }

  Stream<DateTime> currentTime() async* {
    while (true) {
      await Future.delayed(Duration.zero);
      yield DateTime.now();
    }
  }

  bool hasSubmittedTask({required String userId}) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    if (taskProvider.allEmployeeTaskModel == null ||
        (taskProvider.allEmployeeTaskModel?.data?.isEmpty ?? true)) {
      return false;
    } else {
      return (taskProvider.allEmployeeTaskModel?.data?.any((element) =>
              element.task?.userId.toString().trim() == userId.trim()) ??
          false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Image.asset(StringHelper.appLogo, width: 150),
        //       StreamBuilder(
        //         stream: currentTime(),
        //         builder: (context, snapShot) {
        //           return Column(
        //             children: [
        //               Text(
        //                 snapShot.data != null
        //                     ? DateFormat.yMMMEd().format(snapShot.data!)
        //                     : '',
        //                 style: Theme.of(context)
        //                     .textTheme
        //                     .bodyMedium!
        //                     .copyWith(fontWeight: FontWeight.w500),
        //               ),
        //             ],
        //           );
        //         },
        //       ),
        //     ],
        //   ),
        //   actions: [
        //     NotificationButton(
        //       isAdmin: true,
        //     )
        //   ],
        // ),
        body: SafeArea(
      child: Consumer2<AttendanceProvider, TaskProvider>(
        builder: (context, attendancValue, taskProvider, child) =>
            RefreshIndicator(
          onRefresh: () async {
            attendancValue.getDailyAttendence();
            taskProvider.getAllEmployeeTask(
                context: context,
                date: DateFormat('yyyy-MM-dd').format(DateTime.now()));
            selectedDate = null;
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: attendancValue.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 12.0),
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
                          attendancValue.searchEmployee(value);
                        },
                        controller: TextEditingController_searchController,
                        suffixIcon: IconButton(
                          onPressed: () async {
                            selectedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime(1947, 1, 1),
                              lastDate: DateTime.now(),
                            );
                            if (selectedDate != null) {
                              attendancValue.getDailyAttendence(
                                  date: DateFormat('yyyy-MM-dd')
                                      .format(selectedDate!));
                              taskProvider.getAllEmployeeTask(
                                  context: context,
                                  date: DateFormat('yyyy-MM-dd')
                                      .format(selectedDate!));
                            }
                          },
                          icon: Icon(Icons.date_range),
                        ),
                      ),
                      attendancValue.dailyAttendanceList?.isNotEmpty ?? false
                          ? Expanded(
                              child: ListView.builder(
                                  itemCount: attendancValue
                                          .dailyAttendanceList?.length ??
                                      0,
                                  itemBuilder: (context, index) {
                                    final DailyAttendenceData?
                                        dailyAttendenceData = attendancValue
                                            .dailyAttendanceList?[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: AttendanceCard(
                                        attendenceData: dailyAttendenceData,
                                        hasSubmittedTask: hasSubmittedTask(
                                            userId: dailyAttendenceData
                                                    ?.user?.id
                                                    ?.toString()
                                                    .trim() ??
                                                '0'),
                                      ),
                                    );
                                  }),
                            )
                          : Expanded(
                              child: Center(
                                child: Text(StringHelper.noAttendanceFound),
                              ),
                            ),
                    ],
                  ),
          ),
        ),
      ),
    ));
  }
}

class NotificationButton extends StatelessWidget {
  final bool isAdmin;
  const NotificationButton({
    super.key,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NotificationPage(
              isAdmin: isAdmin,
            ),
          ),
        );
      },
      icon: Icon(
        Icons.notifications,
      ),
    );
  }
}

class AttendanceCard extends StatelessWidget {
  final DailyAttendenceData? attendenceData;
  final bool hasSubmittedTask;

  const AttendanceCard({
    super.key,
    required this.hasSubmittedTask,
    this.attendenceData,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasData = attendenceData?.attendanceData?.isNotEmpty ?? false;
    final name = attendenceData?.user?.name ?? '';
    final phoneNumber = attendenceData?.user?.phone ?? '';
    final checkInTime =
        hasData ? attendenceData?.attendanceData?.first.checkin : '00:00';
    final checkOutTime =
        hasData ? attendenceData?.attendanceData?.first.checkout : '00:00';
    final onBreakTime =
        hasData ? attendenceData?.attendanceData?.first.onBreak : '00:00';
    final offBreakTime =
        hasData ? attendenceData?.attendanceData?.first.offBreak : '00:00';
    final breakTime = attendenceData?.attendanceData?.first.offBreak != null
        ? (attendenceData?.totalBreakTime?.isNotEmpty ?? false)
            ? attendenceData?.totalBreakTime
            : '00:00'
        : null;

    final workingHour = attendenceData?.attendanceData?.first.checkout != null
        ? (attendenceData?.totalWorkingHours?.isNotEmpty ?? false)
            ? attendenceData?.totalWorkingHours
            : '00:00'
        : null;

    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // color: AppColors.grey,
        border: Border.all(
          color: AppColors.grey.withOpacity(0.5),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              color: AppColors.onPrimaryBlack,
            ),
          ),
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomAttendanceChip(
                    value: checkInTime,
                    icon: CupertinoIcons.arrow_down_left,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CustomAttendanceChip(
                    value: checkOutTime,
                    icon: CupertinoIcons.arrow_up_right,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            if (breakTime != null)
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: AppColors.aPrimary.withOpacity(0.4),
                        child: Icon(
                          Icons.food_bank_outlined,
                          size: 18,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        breakTime,
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomAttendanceChip(
                    value: onBreakTime,
                    icon: Icons.pause,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CustomAttendanceChip(
                    value: offBreakTime,
                    icon: Icons.play_arrow,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            if (workingHour != null)
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: AppColors.aPrimary.withOpacity(0.4),
                        child: Icon(
                          Icons.watch_later_outlined,
                          size: 18,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        workingHour,
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: CallWidgetSecond(phoneNumber: phoneNumber),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomAttendanceChip extends StatelessWidget {
  const CustomAttendanceChip({
    super.key,
    required this.value,
    required this.icon,
  });

  final String? value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          10,
        ),
        // border: Border.all(color: AppColors.grey)
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.aPrimary.withOpacity(0.4),
              child: Icon(
                icon,
                size: 18,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              (value == null) ? '00:00' : value?.substring(0, 5) ?? '00:00',
            ),
          ],
        ),
      ),
    );
  }
}
