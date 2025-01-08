import 'package:flipcodeattendence/helper/string_helper.dart';
import 'package:flipcodeattendence/widget/call_widget.dart';
import 'package:flipcodeattendence/widget/custom_elevated_button.dart';
import '../../../helper/method_helper.dart';
import '/provider/leave_provider.dart';
import '/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../helper/height_width_helper.dart';
import '../../../widget/text_form_field_custom.dart';

class UserLeavePage extends StatefulWidget {
  const UserLeavePage({super.key});

  @override
  State<UserLeavePage> createState() => _UserLeavePageState();
}

class _UserLeavePageState extends State<UserLeavePage> {
  String? leaveType;
  DateTime selectedDate = DateTime.now();
  String selectedHalf = StringHelper.firstHalf;
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final reasonController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final leaveTypeList = <String>[
    StringHelper.planLeave,
    StringHelper.emergencyLeave,
    StringHelper.halfLeave,
  ];

  Future<DateTime?> selectDate(
      {required BuildContext context, DateTime? firstDate}) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: firstDate ?? selectedDate,
        firstDate: firstDate ?? DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      return picked;
    }
    return null;
  }

  final borderDecoration = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  );

  void addLeavePopup() {
    fromController.clear();
    toController.clear();
    leaveType = null;
    reasonController.clear();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: StatefulBuilder(builder: (context, refresh) {
          return Container(
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
                    StringHelper.requestLeave,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    hint: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        StringHelper.leaveSelectionText,
                      ),
                    ),
                    decoration: InputDecoration(
                      enabledBorder: borderDecoration,
                      focusedBorder: borderDecoration,
                      errorBorder: borderDecoration,
                      focusedErrorBorder: borderDecoration,
                      disabledBorder: borderDecoration,
                    ),
                    value: leaveType,
                    validator: (value) {
                      return (value == null)
                          ? StringHelper.noLeaveSelectionWarning
                          : null;
                    },
                    items: leaveTypeList
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      leaveType = value;
                      toController.clear();
                      fromController.clear();
                      refresh(() {});
                    },
                  ),
                  if (leaveType == StringHelper.halfLeave) ...[
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: CustomOutlineContainer(
                            onTap: () {
                              selectedHalf = StringHelper.firstHalf;
                              refresh(() {});
                            },
                            title: StringHelper.firstHalf,
                            isSelected: selectedHalf == StringHelper.firstHalf,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomOutlineContainer(
                            onTap: () {
                              selectedHalf = StringHelper.secondtHalf;
                              refresh(() {});
                            },
                            title: StringHelper.secondtHalf,
                            isSelected:
                                selectedHalf == StringHelper.secondtHalf,
                          ),
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: 20),
                  if (leaveType != null) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormFieldWidget(
                            isFilled: true,
                            readOnly: true,
                            suffixIcon: IconButton(
                              onPressed: () {
                                selectDate(
                                        context: context,
                                        firstDate:
                                            leaveType == StringHelper.planLeave
                                                ? DateTime.now().add(
                                                    Duration(
                                                      days: 3,
                                                    ),
                                                  )
                                                : null)
                                    .then(
                                  (value) {
                                    if (value != null) {
                                      fromController.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(value);
                                      if (leaveType == StringHelper.halfLeave) {
                                        toController.text =
                                            DateFormat('yyyy-MM-dd')
                                                .format(value);
                                      }
                                      refresh(() {});
                                    }
                                  },
                                );
                              },
                              icon: Icon(Icons.date_range),
                            ),
                            hintText: StringHelper.fromDateHint,
                            fillColor: AppColors.backgroundLight,
                            validator: (value) {
                              return (value?.isEmpty ?? false)
                                  ? StringHelper.fromDateHint
                                  : null;
                            },
                            controller: fromController,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormFieldWidget(
                            isFilled: true,
                            readOnly: true,
                            suffixIcon: IconButton(
                              onPressed: () {
                                if (leaveType != StringHelper.halfLeave) {
                                  selectDate(
                                          context: context,
                                          firstDate: leaveType ==
                                                  StringHelper.planLeave
                                              ? DateTime.now().add(
                                                  Duration(
                                                    days: 3,
                                                  ),
                                                )
                                              : null)
                                      .then(
                                    (value) {
                                      if (value != null) {
                                        toController.text =
                                            DateFormat('yyyy-MM-dd')
                                                .format(value);
                                        refresh(() {});
                                      }
                                    },
                                  );
                                }
                              },
                              icon: Icon(Icons.date_range),
                            ),
                            hintText: StringHelper.toDateHint,
                            fillColor: AppColors.backgroundLight,
                            validator: (value) {
                              return (value?.isEmpty ?? false)
                                  ? StringHelper.toDateHint
                                  : null;
                            },
                            controller: toController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                  TextFormFieldWidget(
                    isFilled: true,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    hintText: StringHelper.enterLeaveReasonHint,
                    fillColor: AppColors.backgroundLight,
                    validator: (value) {
                      return (value?.isEmpty ?? false)
                          ? StringHelper.emptyLeaveReasonWarning
                          : null;
                    },
                    controller: reasonController,
                  ),
                  SizedBox(height: 20),
                  Consumer<LeaveProvider>(
                    builder: (context, leave, child) => leave.isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: AppColors.aPrimary,
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.grey,
                                      shape: StadiumBorder(),
                                      fixedSize: Size(
                                          screenWidth(context: context), 56),
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold)),
                                  onPressed: () async {
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
                                      shape: StadiumBorder(),
                                      fixedSize: Size(
                                          screenWidth(context: context), 56),
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold)),
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      String? finalLeaveType =
                                          leaveType == StringHelper.halfLeave
                                              ? ((leaveType ?? '') +
                                                  " " +
                                                  ('($selectedHalf)'))
                                              : leaveType;
                                      print(finalLeaveType);
                                      leave.applyLeave(context, {
                                        "startDate": fromController.text,
                                        "endDate": toController.text,
                                        "leaveType": finalLeaveType,
                                        "reason": reasonController.text,
                                      }).then((value) {
                                        leave.getLeaveList();
                                        Navigator.of(context).pop();
                                      });
                                    }
                                  },
                                  child: Text(
                                    StringHelper.apply,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  void initState() {
    Provider.of<LeaveProvider>(context, listen: false).getLeaveList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Consumer<LeaveProvider>(
            builder: (context, leave, child) => RefreshIndicator(
              onRefresh: () async => await leave.getLeaveList(),
              child: Column(
                children: [
                  const SizedBox(height: 12.0),
                  leave.isLoading
                      ? Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : leave.leaveList?.data?.isNotEmpty ?? false
                          ? Expanded(
                              child: Container(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: leave.leaveList?.data?.length ?? 0,
                                  itemBuilder: (context, index) =>
                                      CustomLeaveCard(
                                    leaveCreatedAt:
                                        leave.leaveList?.data?[index].createdAt,
                                    isAdmin: false,
                                    isLoading: false,
                                    leaveStartDate:
                                        leave.leaveList?.data?[index].startDate,
                                    leaveEndDate:
                                        leave.leaveList?.data?[index].endDate,
                                    leaveType:
                                        leave.leaveList?.data?[index].leaveType ??
                                            '',
                                    leaveReason:
                                        leave.leaveList?.data?[index].reason ??
                                            '',
                                    leaveStatus:
                                        leave.leaveList?.data?[index].status ??
                                            '',
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              child: Center(
                                child: Text(
                                  StringHelper.noLeaveRequestFound,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300, fontSize: 20),
                                ),
                              ),
                            ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => addLeavePopup(),
          shape: CircleBorder(),
          child: Icon(
            Icons.add,
            color: AppColors.onPrimaryLight,
          ),
          backgroundColor: AppColors.aPrimary,
        ));
  }
}

class CustomOutlineContainer extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  final bool isSelected;

  const CustomOutlineContainer({
    super.key,
    required this.title,
    this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.aPrimary.withOpacity(0.5) : null,
          border: Border.all(color: isSelected ? Colors.transparent : AppColors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}

TextStyle ts16(
    {Color color = AppColors.onPrimaryBlack,
    FontWeight fontWeight = FontWeight.w500}) {
  return TextStyle(fontSize: 16, color: color, fontWeight: fontWeight);
}

class CustomLeaveCard extends StatelessWidget {
  final bool isAdmin;
  final bool isLoading;
  final String? leaveCreatedAt;
  final String? name;
  final String? leaveStartDate;
  final String? leaveEndDate;
  final String? leaveType;
  final String? leaveReason;
  final String? leaveStatus;
  final String? phoneNumber;
  final void Function()? onApprovePressed;
  final void Function()? onCancelPressed;
  final void Function()? onRejectPressed;

  const CustomLeaveCard({
    super.key,
    this.leaveCreatedAt,
    this.leaveStartDate,
    this.leaveEndDate,
    this.leaveType,
    this.leaveReason,
    this.leaveStatus,
    required this.isAdmin,
    required this.isLoading,
    this.onApprovePressed,
    this.onCancelPressed,
    this.onRejectPressed,
    this.name,
    this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Expanded(
          //   flex: 1,
          //   child: Padding(
          //     padding: const EdgeInsets.only(top: 15),
          //     child: Text(
          //       customDateFormateForCreateAt(leaveCreatedAt),
          //       style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   width: 5,
          // ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          MethodHelper.customDateFormateForDateRange(
                              leaveStartDate),
                          style: ts16(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        "TO",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                            color: AppColors.grey),
                      ),
                      Expanded(
                        child: Text(
                          MethodHelper.customDateFormateForDateRange(
                              leaveEndDate),
                          style: ts16(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Application Date :",
                      style: ts16(
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      MethodHelper.customDateFormateForDateRange(
                          leaveCreatedAt),
                      style: ts16(fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(height: 15),
                  if (isAdmin) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Name :",
                        style: ts16(
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        name ?? '',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Leave Type :",
                      style: ts16(
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      leaveType ?? '-',
                      style: ts16(),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Reason :",
                      style: ts16(
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      leaveReason ?? '',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "Status :",
                              style: ts16(
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              leaveStatus ?? '',
                              style: ts16(
                                fontWeight: FontWeight.bold,
                                color: statusColor(leaveStatus),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isAdmin) ...[
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: CallWidget(phoneNumber: phoneNumber),
                        ),
                      ],
                    ],
                  ),
                  if (isAdmin) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                              ],
                            )
                          : (leaveStatus?.toLowerCase() == 'approved'
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: CustomElevatedButton(
                                        backgroundColor: AppColors.grey,
                                        size: Size(
                                            screenWidth(context: context), 56),
                                        textStyle: ts16(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.onPrimaryLight),
                                        onPressed: onCancelPressed,
                                        buttonText: StringHelper.cancelLeave,
                                      ),
                                    ),
                                  ],
                                )
                              : (leaveStatus?.toLowerCase() == 'pending'
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: CustomElevatedButton(
                                            backgroundColor: AppColors.aPrimary,
                                            size: Size(
                                                screenWidth(context: context),
                                                56),
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color:
                                                    AppColors.onPrimaryLight),
                                            onPressed: onApprovePressed,
                                            buttonText: StringHelper.approve,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: CustomElevatedButton(
                                            backgroundColor: AppColors.grey,
                                            size: Size(
                                                screenWidth(context: context),
                                                56),
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color:
                                                    AppColors.onPrimaryLight),
                                            onPressed: onRejectPressed,
                                            buttonText: StringHelper.reject,
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox.shrink())),
                    ),
                  ] else ...[
                    SizedBox(height: 20),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

customDateFormateForCreateAt(String? stringDate) {
  if (stringDate != null) {
    DateTime parseDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(stringDate);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd MMM yy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate.toString();
  } else {
    return '';
  }
}

statusColor(String? status) {
  if (status == 'Pending') {
    return AppColors.aPrimary;
  } else if (status == 'Approved') {
    return AppColors.green;
  } else if (status == 'Rejected') {
    return AppColors.red;
  } else {
    return AppColors.onPrimaryBlack;
  }
}
