import 'dart:async';

import 'package:flipcodeattendence/featuers/Admin/model/daily_attendence_model.dart';
import 'package:flipcodeattendence/featuers/Admin/page/user_view.dart';
import 'package:flipcodeattendence/mixins/navigator_mixin.dart';
import 'package:flipcodeattendence/provider/client_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../provider/attendance_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../widget/text_form_field_custom.dart';

enum _UserType { Staff, Client }

Future<void> getStaffData(BuildContext context) async {
  Future.delayed(
      Duration.zero,
      () => Provider.of<AttendanceProvider>(context, listen: false)
          .getStaffList(context));
}

Future<void> getClientData(BuildContext context) async {
  Future.delayed(
      Duration.zero,
      () => Provider.of<ClientProvider>(context, listen: false)
          .getClients(context: context));
}

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
    getStaffData(context);
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
        toolbarHeight: 140,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormFieldWidget(
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
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                                ? getStaffData(context)
                                : getClientData(context);
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
            return _buildFilteredStaffWidget();
          } else {
            return _StaffListWidget();
          }
        } else {
          return _ClientListWidget();
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => push(context, const UserView()),
        child: const Icon(Icons.add),
        shape: CircleBorder(),
      ),
    );
  }

  Widget _buildFilteredStaffWidget() {
    return (_filteredStaff.isEmpty)
        ? Center(child: Text('No Staff Found'))
        : ListView.builder(
            shrinkWrap: true,
            itemCount: _filteredStaff.length,
            itemBuilder: (context, index) {
              final staff = _filteredStaff[index];
              return ListTile(
                onTap: () {},
                leading: CircleAvatar(
                    backgroundColor: AppColors.aPrimary,
                    foregroundColor: AppColors.onPrimaryLight,
                    child: Text(staff.name?[0].toUpperCase() ?? '')),
                title: Text(staff.name?.capitalizeFirst ?? ''),
              );
            });
  }
}

class _StaffListWidget extends StatelessWidget {
  const _StaffListWidget();

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceProvider>(builder: (context, provider, _) {
      return provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : (provider.staffList?.isEmpty ?? true)
              ? Center(
                  child: Text('No Staff Found'),
                )
              : RefreshIndicator(
                  onRefresh: () => getStaffData(context),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.staffList?.length ?? 0,
                      itemBuilder: (context, index) {
                        final staff = provider.staffList?[index];
                        return ListTile(
                          onTap: () {},
                          leading: CircleAvatar(
                              backgroundColor: AppColors.aPrimary,
                              foregroundColor: AppColors.onPrimaryLight,
                              child: Text(staff?.name?[0].toUpperCase() ?? '')),
                          title: Text(staff?.name?.capitalizeFirst ?? ''),
                        );
                      }),
                );
    });
  }
}

class _ClientListWidget extends StatelessWidget {
  const _ClientListWidget();

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientProvider>(builder: (context, provider, _) {
      return provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : (provider.clientModel?.data?.isEmpty ?? true)
              ? Text('No clients found')
              : RefreshIndicator(
                  onRefresh: () => getClientData(context),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.clientModel?.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final client = provider.clientModel?.data?[index];
                        return ListTile(
                            leading: CircleAvatar(
                                backgroundColor: AppColors.aPrimary,
                                foregroundColor: AppColors.onPrimaryLight,
                                child:
                                    Text(client?.name?[0].toUpperCase() ?? '')),
                            title: Text(client?.name ?? ''));
                      }),
                );
    });
  }
}
