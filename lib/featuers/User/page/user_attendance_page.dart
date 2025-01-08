import 'dart:async';
import 'dart:core';

import 'package:flipcodeattendence/mixins/navigator_mixin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../helper/time_helper.dart';
import '../../../provider/today_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../widget/custom_container_widget.dart';
import '/provider/attendance_provider.dart';
import '/helper/string_helper.dart';

class UserAttendancePage extends StatefulWidget {
  const UserAttendancePage({Key? key}) : super(key: key);

  @override
  _UserAttendancePageState createState() => _UserAttendancePageState();
}

class _UserAttendancePageState extends State<UserAttendancePage>
    with NavigatorMixin {
  Timer? timer, longPressTimer;
  bool isLongPressing = false;
  bool loading = false;
  double progressValue = 0.0;
  final attendanceProvider = AttendanceProvider();
  late StreamController<String> elapsedStreamController;
  String? checkInTime,
      checkOutTime,
      onBreakTime,
      offBreakTime,
      workedDuration,
      breakDuration,
      currentState,
      elapsedTime;

  @override
  void initState() {
    elapsedStreamController = StreamController<String>();
    super.initState();
    _setCurrentState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _setCurrentState() async {
    await Provider.of<TodayProvider>(context, listen: false)
        .getTodayService()
        .then(
      (value) async {
        if (value?.attendance?.isEmpty ?? true) {
          currentState = StringHelper.checkIn;
        } else {
          checkInTime = value?.attendance?.first.checkin;
          onBreakTime = value?.attendance?.first.onBreak;
          offBreakTime = value?.attendance?.first.offBreak;
          checkOutTime = value?.attendance?.first.checkout;
          _updateElapsedTime();
          if (checkInTime == null) {
            currentState = StringHelper.checkIn;
          } else if (onBreakTime == null) {
            currentState = StringHelper.onBreak;
          } else if (offBreakTime == null) {
            currentState = StringHelper.offBreak;
          } else if (checkOutTime == null) {
            currentState = StringHelper.checkOut;
            _countBreakDuration(
                onBreakTime: onBreakTime, offBreakTime: offBreakTime);
          } else {
            _countWorkDuration(
                checkInTime: checkInTime,
                checkOutTime: checkOutTime,
                onBreakTime: onBreakTime,
                offBreakTime: offBreakTime);
            _countBreakDuration(
                onBreakTime: onBreakTime, offBreakTime: offBreakTime);
            currentState = '';
          }
        }
      },
    );
    Future.delayed(Duration.zero, () => setState(() {}));
  }

  void _countWorkDuration(
      {required String? checkInTime,
      required String? checkOutTime,
      required String? onBreakTime,
      required String? offBreakTime}) {
    int totalWorkingTimeInSeconds = TimeHelper.countWorkSeconds(
        checkInTime: checkInTime ?? '00:00:00',
        checkOutTime: checkOutTime ?? '00:00:00',
        onBreakTime: onBreakTime ?? '00:00:00',
        offBreakTime: offBreakTime ?? '00:00:00');
    workedDuration = TimeHelper.formatTime(
        totalSeconds: totalWorkingTimeInSeconds, hourMinuteFormat: true);
  }

  void _countBreakDuration(
      {required String? onBreakTime, required String? offBreakTime}) {
    int totalBreakTimeInSeconds = TimeHelper.countBreakSeconds(
        onBreakTime: onBreakTime ?? '00:00:00',
        offBreakTime: offBreakTime ?? '00:00:00');
    breakDuration = TimeHelper.formatTime(
        totalSeconds: totalBreakTimeInSeconds, hourMinuteFormat: true);
  }

  void _updateElapsedTime() async {
    String elapsedTime;
    if (checkInTime == null) {
      return;
    } else if (onBreakTime == null) {
      elapsedTime = TimeHelper.getElapsedTime(checkInTime: checkInTime!);
      elapsedStreamController.sink.add(elapsedTime);
      Future.delayed(Duration(seconds: 1), _updateElapsedTime);
    } else if (offBreakTime == null) {
      elapsedTime = TimeHelper.getElapsedTime(
          checkInTime: checkInTime!, onBreakTime: onBreakTime);
      elapsedStreamController.sink.add(elapsedTime);
      return;
    } else if (checkOutTime == null) {
      elapsedTime = TimeHelper.getElapsedTime(
        checkInTime: checkInTime!,
        onBreakTime: onBreakTime,
        offBreakTime: offBreakTime,
      );
      elapsedStreamController.sink.add(elapsedTime);
      Future.delayed(Duration(seconds: 1), _updateElapsedTime);
    } else {
      elapsedTime = TimeHelper.getElapsedTime(
        checkInTime: checkInTime!,
        onBreakTime: onBreakTime,
        offBreakTime: offBreakTime,
        checkOutTime: checkOutTime,
      );
      elapsedStreamController.sink.add(elapsedTime);
      return;
    }
  }

  Stream<DateTime> currentTime() async* {
    while (true) {
      await Future.delayed(Duration.zero);
      yield DateTime.now();
    }
  }

  Future<void> _toggleCheckInOut() async {
    try {
      if (currentState == StringHelper.checkIn) {
        await attendanceProvider.addData(context, 'checkin');
        _setCurrentState();
      } else if (currentState == StringHelper.onBreak) {
        await attendanceProvider.addData(context, 'on_break');
        _setCurrentState();
      } else if (currentState == StringHelper.offBreak) {
        await attendanceProvider.addData(context, 'off_break');
        _setCurrentState();
      } else if (currentState == StringHelper.checkOut) {
        await attendanceProvider.addData(context, 'checkout');
        _setCurrentState();
      }
    } catch (e) {
      print('Error during attendance update: $e');
    }
  }

  Future<void> _startLongPressTimer() async {
    isLongPressing = true;
    progressValue = 0.0;
    longPressTimer =
        Timer.periodic(Duration(milliseconds: 20), (Timer timer) async {
      setState(() => progressValue += 0.01);
      if (progressValue >= 1.0) {
        timer.cancel();
        setState(() => isLongPressing = false);
        setState(() => loading = true);

        await _toggleCheckInOut();
        setState(() => loading = false);
      }
    });
  }

  void _stopLongPressTimer() async {
    if (longPressTimer != null && longPressTimer!.isActive) {
      longPressTimer!.cancel();
    }
    setState(() {
      isLongPressing = false;
      progressValue = 0.0;
    });
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
          // actions: [
          //   IconButton(
          //     onPressed: () {
          //       push(
          //           context,
          //           NotificationPage(
          //             isAdmin: false,
          //           ));
          //     },
          //     icon: Icon(
          //       Icons.notifications,
          //     ),
          //   )
          // ],
        ),
        body: Consumer<TodayProvider>(
            builder: (context, todayAttendanceProvider, _) {
          final attendance =
              todayAttendanceProvider.todayData?.attendance ?? [];
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StreamBuilder<String>(
                    stream: elapsedStreamController.stream,
                    initialData: '00:00:00',
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data!,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(fontWeight: FontWeight.w500),
                        );
                      } else {
                        return Text(
                          '00:00:00',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(fontWeight: FontWeight.w500),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomContainer(
                          icon: CupertinoIcons.arrow_down_left,
                          label: 'Check in',
                          time: (attendance.isEmpty)
                              ? '00:00'
                              : attendance.first.checkin?.substring(0, 5) ??
                                  '00:00',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: CustomContainer(
                          icon: CupertinoIcons.arrow_up_right,
                          label: 'Check out',
                          time: (attendance.isEmpty)
                              ? '00:00'
                              : attendance.first.checkout?.substring(0, 5) ??
                                  '00:00',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomContainer(
                          icon: CupertinoIcons.pause,
                          label: 'On Break',
                          time: (attendance.isEmpty)
                              ? '00:00'
                              : attendance.first.onBreak?.substring(0, 5) ??
                                  '00:00',
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: CustomContainer(
                          icon: CupertinoIcons.play,
                          label: 'Off Break',
                          time: (attendance.isEmpty)
                              ? '00:00'
                              : attendance.first.offBreak?.substring(0, 5) ??
                                  '00:00',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomContainer(
                          icon: CupertinoIcons.timer,
                          label: 'Work Hours',
                          time: workedDuration ?? '00:00',
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: CustomContainer(
                          icon: CupertinoIcons.timer,
                          label: 'Break Time',
                          time: breakDuration ?? '00:00',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 48),
                  if (todayAttendanceProvider.isLoading || loading) ...[
                    Container(
                      height: 140,
                      width: 140,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    )
                  ] else ...[
                    GestureDetector(
                      onLongPressStart: (_) => (attendance.isEmpty)
                          ? _startLongPressTimer()
                          : (attendance.first.checkout == null)
                              ? _startLongPressTimer()
                              : () {},
                      onLongPressEnd: (_) => (attendance.isEmpty)
                          ? _stopLongPressTimer()
                          : (attendance.first.checkout == null)
                              ? _stopLongPressTimer()
                              : () {},
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: getColor(),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: Icon(
                              getIcon(),
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                          if (isLongPressing)
                            SizedBox(
                              width: 140,
                              height: 140,
                              child: CircularProgressIndicator(
                                value: progressValue,
                                strokeWidth: 6,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.onPrimaryLight),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      getState(),
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.onPrimaryBlack,
                      ),
                    ),
                  ]
                ],
              ),
            ),
          );
        }));
  }

  String getState() {
    if (currentState == StringHelper.checkIn) {
      return StringHelper.checkIn;
    } else if (currentState == StringHelper.onBreak) {
      return StringHelper.onBreak;
    } else if (currentState == StringHelper.offBreak) {
      return StringHelper.offBreak;
    } else if (currentState == StringHelper.checkOut) {
      return StringHelper.checkOut;
    } else {
      return StringHelper.comeTmrw;
    }
  }

  IconData getIcon() {
    if (currentState == StringHelper.checkIn) {
      return Icons.touch_app_outlined;
    } else if (currentState == StringHelper.onBreak) {
      return CupertinoIcons.pause_solid;
    } else if (currentState == StringHelper.offBreak) {
      return Icons.play_arrow_rounded;
    } else if (currentState == StringHelper.checkOut) {
      return Icons.exit_to_app_rounded;
    } else {
      return Icons.touch_app_outlined;
    }
  }

  Color getColor() {
    if (currentState == StringHelper.checkIn) {
      return Colors.green;
    } else if (currentState == StringHelper.onBreak ||
        currentState == StringHelper.offBreak) {
      return Colors.orange;
    } else if (currentState == StringHelper.checkOut) {
      return Colors.red;
    } else {
      return AppColors.grey;
    }
  }
}
