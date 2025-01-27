import 'dart:async';

import 'package:flipcodeattendence/featuers/Admin/model/daily_attendence_model.dart';
import 'package:flipcodeattendence/featuers/Admin/page/user_view.dart';
import 'package:flipcodeattendence/helper/enum_helper.dart';
import 'package:flipcodeattendence/mixins/navigator_mixin.dart';
import 'package:flipcodeattendence/provider/client_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../provider/attendance_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../widget/text_form_field_custom.dart';

enum _UserType { Staff, Client }

class AppUsersView extends StatefulWidget {
  const AppUsersView({super.key});

  @override
  State<AppUsersView> createState() => _AppUsersState();
}

class _AppUsersState extends State<AppUsersView> with NavigatorMixin {
  Timer? _debounce;
  bool isSearching = false;
  var selectedUserType = _UserType.Staff;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getStaffData();
  }

  Future<void> getStaffData() async {
    Future.delayed(
        Duration.zero,
        () => Provider.of<AttendanceProvider>(context, listen: false)
            .getStaffList(context));
  }

  Future<void> getClientData() async {
    Future.delayed(
        Duration.zero,
        () => Provider.of<ClientProvider>(context, listen: false)
            .getClients(context: context));
  }

  var _filteredStaff = <DailyAttendanceData>[];

  void _onSearchChangedForStaff(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        isSearching = false;
        _filteredStaff.clear();
      } else {
        isSearching = true;
        _filteredStaff = context
                .read<AttendanceProvider>()
                .staffList
                ?.where((element) =>
                    element.name
                        ?.trim()
                        .toLowerCase()
                        .contains(query.trim().toLowerCase()) ??
                    false)
                .toList() ??
            [];
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 130,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormFieldWidget(
                  contentPadding: EdgeInsets.zero,
                  controller: searchController,
                  prefixWidget: Icon(CupertinoIcons.search),
                  hintText: 'Search',
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    if (_debounce?.isActive ?? false) _debounce?.cancel();
                    _debounce = Timer(const Duration(milliseconds: 800), () {
                      if (selectedUserType == _UserType.Client) {
                        if (value.trim().isNotEmpty) {
                          searchController.text = value;
                          Provider.of<ClientProvider>(context, listen: false)
                              .getClients(context: context, name: value);
                        } else {
                          Provider.of<ClientProvider>(context, listen: false)
                              .getClients(context: context);
                        }
                      } else {
                        _onSearchChangedForStaff(value);
                      }
                    });
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SegmentedButton(
                          segments: [
                            ButtonSegment(
                                value: _UserType.Staff,
                                label: Text(
                                    _UserType.Staff.name.capitalizeFirst!)),
                            ButtonSegment(
                                value: _UserType.Client,
                                label: Text(
                                    _UserType.Client.name.capitalizeFirst!)),
                          ],
                          selected: {selectedUserType},
                          onSelectionChanged: (value) => setState(() {
                            selectedUserType = value.first;
                            searchController.clear();
                            _filteredStaff.clear();
                            isSearching = false;
                            (value.first == _UserType.Staff)
                                ? getStaffData()
                                : getClientData();
                          }),
                          style: SegmentedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              side: BorderSide(color: AppColors.aPrimary),
                              selectedBackgroundColor: AppColors.aPrimary,
                              selectedForegroundColor:
                                  AppColors.onPrimaryLight),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<AttendanceProvider>(builder: (context, provider, _) {
        if (selectedUserType == _UserType.Staff) {
          if (isSearching) {
            return (_filteredStaff.isEmpty)
                ? Center(child: Text('No Staff Found'))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredStaff.length,
                    itemBuilder: (context, index) {
                      final staff = _filteredStaff[index];
                      return ListTile(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return UserView(
                              isUpdate: true,
                              id: staff.id?.toString(),
                              name: staff.name,
                              mobileNo: staff.phone?.toString(),
                              email: staff.email,
                              birthDate: staff.birthdate,
                              role: UserRole.user,
                            );
                          })).then((value) {
                            if (value == true) getStaffData();
                          });
                        },
                        leading: CircleAvatar(
                            backgroundColor: AppColors.aPrimary,
                            foregroundColor: AppColors.onPrimaryLight,
                            child: Text(staff.name?[0].toUpperCase() ?? '')),
                        title: Text(staff.name?.capitalizeFirst ?? ''),
                      );
                    });
          } else {
            return provider.isLoading
                ? Center(child: CircularProgressIndicator())
                : (provider.staffList?.isEmpty ?? true)
                    ? Center(
                        child: Text('No Staff Found'),
                      )
                    : RefreshIndicator(
                        onRefresh: getStaffData,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: provider.staffList?.length ?? 0,
                            itemBuilder: (context, index) {
                              final staff = provider.staffList?[index];
                              return ListTile(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return UserView(
                                      isUpdate: true,
                                      id: staff?.id?.toString(),
                                      name: staff?.name,
                                      mobileNo: staff?.phone?.toString(),
                                      email: staff?.email,
                                      birthDate: staff?.birthdate,
                                      role: UserRole.user,
                                    );
                                  })).then((value) {
                                    if (value == true) getStaffData();
                                  });
                                },
                                leading: CircleAvatar(
                                    backgroundColor: AppColors.aPrimary,
                                    foregroundColor: AppColors.onPrimaryLight,
                                    child: Text(
                                        staff?.name?[0].toUpperCase() ?? '')),
                                title: Text(staff?.name?.capitalizeFirst ?? ''),
                              );
                            }),
                      );
            ;
          }
        } else {
          return Consumer<ClientProvider>(builder: (context, provider, _) {
            return provider.isLoading
                ? Center(child: CircularProgressIndicator())
                : (provider.clientModel?.data?.isEmpty ?? true)
                    ? Text('No clients found')
                    : RefreshIndicator(
                        onRefresh: getClientData,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: provider.clientModel?.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              final client = provider.clientModel?.data?[index];
                              return ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return UserView(
                                        isUpdate: true,
                                        id: client?.id?.toString(),
                                        name: client?.name,
                                        mobileNo: client?.phone?.toString(),
                                        email: client?.email,
                                        birthDate: client?.birthdate,
                                        role: UserRole.client,
                                      );
                                    })).then((value) {
                                      if (value == true) getClientData();
                                    });
                                  },
                                  leading: CircleAvatar(
                                      backgroundColor: AppColors.aPrimary,
                                      foregroundColor: AppColors.onPrimaryLight,
                                      child: Text(
                                          client?.name?[0].toUpperCase() ??
                                              '')),
                                  title: Text(client?.name ?? ''));
                            }),
                      );
          });
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => push(context, const UserView()),
        child: const Icon(Icons.add),
        shape: CircleBorder(),
      ),
    );
  }
}
