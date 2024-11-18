class DailyAttendenceModel {
  bool? status;
  String? message;
  List<DailyAttendenceData>? dailyAttendenceData;

  DailyAttendenceModel({this.status, this.message, this.dailyAttendenceData});

  DailyAttendenceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      dailyAttendenceData = <DailyAttendenceData>[];
      json['data'].forEach((v) {
        dailyAttendenceData!.add(new DailyAttendenceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.dailyAttendenceData != null) {
      data['data'] = this.dailyAttendenceData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DailyAttendenceData {
  User? user;
  List<AttendanceData>? attendanceData;
  String? totalBreakTime;
  String? totalWorkingHours;

  DailyAttendenceData(
      {this.user,
      this.attendanceData,
      this.totalBreakTime,
      this.totalWorkingHours});

  DailyAttendenceData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['attendanceData'] != null) {
      attendanceData = <AttendanceData>[];
      json['attendanceData'].forEach((v) {
        attendanceData!.add(new AttendanceData.fromJson(v));
      });
    }
    totalBreakTime = json['totalBreakTime'];
    totalWorkingHours = json['totalWorkingHours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.attendanceData != null) {
      data['attendanceData'] =
          this.attendanceData!.map((v) => v.toJson()).toList();
    }
    data['totalBreakTime'] = this.totalBreakTime;
    data['totalWorkingHours'] = this.totalWorkingHours;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? token;
  String? birthdate;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.name,
      this.phone,
      this.email,
      this.token,
      this.birthdate,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    token = json['token'];
    birthdate = json['birthdate'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['token'] = this.token;
    data['birthdate'] = this.birthdate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class AttendanceData {
  int? id;
  String? date;
  String? checkin;
  dynamic checkout;
  String? onBreak;
  String? offBreak;
  dynamic totalHours;

  AttendanceData(
      {this.id,
      this.date,
      this.checkin,
      this.checkout,
      this.onBreak,
      this.offBreak,
      this.totalHours});

  AttendanceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    checkin = json['checkin'];
    checkout = json['checkout'];
    onBreak = json['on_break'];
    offBreak = json['off_break'];
    totalHours = json['total_hours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['checkin'] = this.checkin;
    data['checkout'] = this.checkout;
    data['on_break'] = this.onBreak;
    data['off_break'] = this.offBreak;
    data['total_hours'] = this.totalHours;
    return data;
  }
}
