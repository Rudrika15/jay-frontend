class ShowAttendanceModel {
  String? message;
  List<User>? user;

  ShowAttendanceModel({this.message, this.user});

  ShowAttendanceModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['User'] != null) {
      user = <User>[];
      json['User'].forEach((v) {
        user!.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.user != null) {
      data['User'] = this.user!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? id;
  int? userId;
  String? date;
  String? checkin;
  String? checkout;
  String? onBreak;
  String? offBreak;
  String? totalHours;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
        this.userId,
        this.date,
        this.checkin,
        this.checkout,
        this.onBreak,
        this.offBreak,
        this.totalHours,
        this.createdAt,
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    date = json['date'];
    checkin = json['checkin'];
    checkout = json['checkout'];
    onBreak = json['on_break'];
    offBreak = json['off_break'];
    totalHours = json['total_hours'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['date'] = this.date;
    data['checkin'] = this.checkin;
    data['checkout'] = this.checkout;
    data['on_break'] = this.onBreak;
    data['off_break'] = this.offBreak;
    data['total_hours'] = this.totalHours;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}