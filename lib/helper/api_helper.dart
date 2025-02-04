class ApiHelper {
  // development
  static String baseUrl = 'https://dev.jayinfotech.org/';

  static String imageBaseUrl = '${baseUrl}images/';
  static String loginUrl = '${baseUrl}api/auth/login';
  static String changePasswordUrl = '${baseUrl}api/auth/change-password';
  static String attendance = '${baseUrl}api/attendance';
  static String today = '${baseUrl}api/today-attendance';
  static String showAttendance = '${baseUrl}api/show-attendance';
  static String showLeave = '${baseUrl}api/leaves';
  static String applyLeave = '${baseUrl}api/leave/request';
  static String updateToken = '${baseUrl}api/save-token';
  static String staffList = '${baseUrl}api/staff-list';
  // common
  static String changeStatus = '${baseUrl}api/chage-status';

  // Admin
  static String getClients = '${baseUrl}api/client-list';
  static String callLogList = '${baseUrl}api/list-call';
  static String teamList = '${baseUrl}api/team-list';
  static String assignTask = '${baseUrl}api/assign-task';
  static String getCallDetail = '${baseUrl}api/get-call-detail';
  static String updateAttendance = '${baseUrl}api/update-attendance';
  static String deleteNotification = '${baseUrl}api/notification/delete';

  // Admin & Client
  static String createCall = '${baseUrl}api/create-call';
  static String clientCallLogList = '${baseUrl}api/client-call-list';

  // client
  static String updateCallLog = '${baseUrl}api/update-call';

  // Staff
  static String staffCallLogList = '${baseUrl}api/call-list';
  static String getParts = '${baseUrl}api/parts-list';
  static String qrList = '${baseUrl}api/qr-list';

  static String dailyAttendence = '${baseUrl}api/daily';
  static String leaveApplications = '${baseUrl}api/leave-applications';
  static String todayLeave = '${baseUrl}api/todaysLeave';
  static String leaveApproval = '${baseUrl}api/leave-approval/';
  static String leaveCancel = '${baseUrl}api/leave/cancel/';

  // notification
  static String notification = '${baseUrl}api/notifications';

  // task
  static String submitTask = '${baseUrl}api/task';
  static String getTask = '${baseUrl}api/mytask';
  static String deleteTask = '${baseUrl}api/deleteTask';
  static String updateTask = '${baseUrl}api/updateTask';

  // Report
  static String report = '${baseUrl}api/report';

  // Admin task
  static String adminAllTask = '${baseUrl}api/allTask';
  static String getAppVersion = '${baseUrl}api/getVersion';

  // Create, Update, Delete user
  static String createUser = '${baseUrl}api/create-user';
  static String updateUser = '${baseUrl}api/update-user';
  static String deleteUser = '${baseUrl}api/delete-user';

  final String _appVersion = '1.0.2';
  String get appVersion => _appVersion;
  final String _appPlayStoreUrl = 'https://play.google.com/store/apps/details?id=com.flipcode.jayinfotech&pcampaignid=web_share';
  String get appPlayStoreUrl => _appPlayStoreUrl;
}
