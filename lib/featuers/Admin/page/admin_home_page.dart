import 'package:flipcodeattendence/Page/notification_page.dart';
import 'package:flipcodeattendence/featuers/Admin/page/app_users_view.dart';
import 'package:flipcodeattendence/helper/string_helper.dart';
import 'package:flipcodeattendence/mixins/navigator_mixin.dart';
import 'package:flipcodeattendence/provider/attendance_provider.dart';
import 'package:flipcodeattendence/theme/app_colors.dart';
import 'package:flipcodeattendence/widget/call_widget.dart';
import 'package:flipcodeattendence/widget/text_form_field_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/daily_attendence_model.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> with NavigatorMixin {
  DateTime? selectedDate;
  final _searchController = TextEditingController();

  @override
  void initState() {
    selectedDate = DateTime.now();
    getData();
    super.initState();
  }

  Stream<DateTime> currentTime() async* {
    while (true) {
      await Future.delayed(Duration.zero);
      yield DateTime.now();
    }
  }

  Future<void> getData() async {
    Provider.of<AttendanceProvider>(context, listen: false).getDailyAttendance(
        date: DateFormat('yyyy-MM-dd').format(selectedDate ?? DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(StringHelper.appLogo, width: 150),
            StreamBuilder(
              stream: currentTime(),
              builder: (context, snapShot) {
                return Column(
                  children: [
                    Text(
                      snapShot.data != null
                          ? DateFormat.yMMMEd().format(snapShot.data!)
                          : '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        actions: [
          NotificationButton(
            isAdmin: true,
          )
        ],
      ),
      body: SafeArea(
        child: Consumer<AttendanceProvider>(
          builder: (context, attendanceValue, child) => RefreshIndicator(
            onRefresh: () async {
              attendanceValue.getDailyAttendance();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: attendanceValue.isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        const SizedBox(height: 12.0),
                        TextFormFieldWidget(
                          isFilled: true,
                          borderColor: AppColors.grey,
                          fillColor: AppColors.onPrimaryLight,
                          controller: _searchController,
                          readOnly: true,
                          hintText: (selectedDate != null)
                              ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                              : DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          suffixIcon: IconButton(
                            onPressed: () async {
                              selectedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedDate ?? DateTime.now(),
                                firstDate: DateTime(1947, 1, 1),
                                lastDate: DateTime.now(),
                              );
                              if (selectedDate != null) {
                                attendanceValue.getDailyAttendance(
                                    date: DateFormat('yyyy-MM-dd')
                                        .format(selectedDate!));
                              }
                            },
                            icon: Icon(Icons.date_range),
                          ),
                        ),
                        attendanceValue.dailyAttendanceList?.isNotEmpty ?? false
                            ? Expanded(
                                child: ListView.builder(
                                    itemCount: attendanceValue
                                            .dailyAttendanceList?.length ??
                                        0,
                                    itemBuilder: (context, index) {
                                      final dailyAttendanceData =
                                          attendanceValue
                                              .dailyAttendanceList?[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: AttendanceCard(
                                          onTapEditTime: (type) async {
                                            TimeOfDay? time;
                                            await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now())
                                                .then((value) async {
                                              if (value != null) {
                                                time = value;
                                                await attendanceValue
                                                    .updateAttendanceData(
                                                        context,
                                                        userId:
                                                            dailyAttendanceData
                                                                    ?.id
                                                                    .toString() ??
                                                                '',
                                                        type: type,
                                                        time: time,
                                                        date: selectedDate)
                                                    .then((value) => getData());
                                              }
                                            });
                                          },
                                          attendanceData: dailyAttendanceData,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => push(context,const AppUsersView()),
        child: Icon(Icons.add),
        shape: CircleBorder(),
      ),
    );
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
  final DailyAttendanceData? attendanceData;
  final void Function(String type) onTapEditTime;

  const AttendanceCard(
      {super.key, this.attendanceData, required this.onTapEditTime});

  @override
  Widget build(BuildContext context) {
    final hasAttendance = attendanceData?.attendances?.isNotEmpty ?? false;
    final name = attendanceData?.name ?? '';
    final phoneNumber = attendanceData?.phone ?? '';
    final checkInTime =
        hasAttendance ? attendanceData?.attendances?.first.checkin : '00:00';
    final checkOutTime =
        hasAttendance ? attendanceData?.attendances?.first.checkout : '00:00';
    final onBreakTime =
        hasAttendance ? attendanceData?.attendances?.first.onBreak : '00:00';
    final offBreakTime =
        hasAttendance ? attendanceData?.attendances?.first.offBreak : '00:00';
    final breakTime = attendanceData?.totalBreakTime ?? '00:00';
    final workingHour = attendanceData?.totalWorkingHours ?? '00:00';

    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.grey.withOpacity(0.5),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controlAffinity: ListTileControlAffinity.leading,
          trailing: CallWidget(phoneNumber: phoneNumber),
          title: Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              color: AppColors.onPrimaryBlack,
            ),
          ),
          children: [
            // Check in
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTapEditTime('checkin'),
                    child: CustomAttendanceChip(
                      value: checkInTime,
                      icon: CupertinoIcons.arrow_down_left,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            // Break duration
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 10),
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
                      backgroundColor: AppColors.aPrimary,
                      child: Icon(
                        Icons.food_bank_outlined,
                        size: 18,
                        color: AppColors.onPrimaryLight,
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
            // On break and off Break
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTapEditTime('on_break'),
                    child: CustomAttendanceChip(
                      value: onBreakTime,
                      icon: Icons.pause,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTapEditTime('off_break'),
                    child: CustomAttendanceChip(
                      value: offBreakTime,
                      icon: Icons.play_arrow,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            // Working hour
            Container(
              margin: EdgeInsets.only(bottom: 10),
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
                      backgroundColor: AppColors.aPrimary,
                      child: Icon(
                        Icons.watch_later_outlined,
                        size: 18,
                        color: AppColors.onPrimaryLight,
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
            // Checkout
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTapEditTime('checkout'),
                    child: CustomAttendanceChip(
                      value: checkOutTime,
                      icon: CupertinoIcons.arrow_up_right,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getButtonText(
      {required String? checkIn,
      required String? checkOut,
      required String? onBreak,
      required String? offBreak}) {
    if (checkIn == null || checkIn == '00:00') {
      return 'Check in';
    } else if (onBreak == null || onBreak == '00:00') {
      return 'On break';
    } else if (offBreak == null || offBreak == '00:00') {
      return 'Off break';
    } else {
      return 'Check out';
    }
  }

  String getType(
      {required String? checkIn,
      required String? checkOut,
      required String? onBreak,
      required String? offBreak}) {
    if (checkIn == null || checkIn == '00:00') {
      return 'checkin';
    } else if (onBreak == null || onBreak == '00:00') {
      return 'on_break';
    } else if (offBreak == null || offBreak == '00:00') {
      return 'off_break';
    } else {
      return 'checkout';
    }
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: AppColors.aPrimary,
                  child: Icon(
                    icon,
                    size: 18,
                    color: AppColors.onPrimaryLight,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  (value == null) ? '00:00' : value?.substring(0, 5) ?? '00:00',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
