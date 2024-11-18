import 'dart:convert';
/// message : "Get Attendance recorded successfully"
/// User : [{"id":14,"user_id":18,"date":"2024-06-29","checkin":"14:41:00","checkout":null,"on_break":null,"off_break":null,"total_hours":null,"created_at":"2024-06-29T11:16:37.000000Z","updated_at":"2024-06-29T11:16:37.000000Z"}]

AttendanceRecord attendanceRecordFromJson(String str) => AttendanceRecord.fromJson(json.decode(str));
String attendanceRecordToJson(AttendanceRecord data) => json.encode(data.toJson());
class AttendanceRecord {
  AttendanceRecord({
      String? message, 
      List<User>? user,}){
    _message = message;
    _user = user;
}

  AttendanceRecord.fromJson(dynamic json) {
    _message = json['message'];
    if (json['User'] != null) {
      _user = [];
      json['User'].forEach((v) {
        _user?.add(User.fromJson(v));
      });
    }
  }
  String? _message;
  List<User>? _user;
AttendanceRecord copyWith({  String? message,
  List<User>? user,
}) => AttendanceRecord(  message: message ?? _message,
  user: user ?? _user,
);
  String? get message => _message;
  List<User>? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    if (_user != null) {
      map['User'] = _user?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 14
/// user_id : 18
/// date : "2024-06-29"
/// checkin : "14:41:00"
/// checkout : null
/// on_break : null
/// off_break : null
/// total_hours : null
/// created_at : "2024-06-29T11:16:37.000000Z"
/// updated_at : "2024-06-29T11:16:37.000000Z"

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());
class User {
  User({
      num? id, 
      num? userId, 
      String? date, 
      String? checkin, 
      dynamic checkout, 
      dynamic onBreak, 
      dynamic offBreak, 
      dynamic totalHours, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _userId = userId;
    _date = date;
    _checkin = checkin;
    _checkout = checkout;
    _onBreak = onBreak;
    _offBreak = offBreak;
    _totalHours = totalHours;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  User.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _date = json['date'];
    _checkin = json['checkin'];
    _checkout = json['checkout'];
    _onBreak = json['on_break'];
    _offBreak = json['off_break'];
    _totalHours = json['total_hours'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _userId;
  String? _date;
  String? _checkin;
  dynamic _checkout;
  dynamic _onBreak;
  dynamic _offBreak;
  dynamic _totalHours;
  String? _createdAt;
  String? _updatedAt;
User copyWith({  num? id,
  num? userId,
  String? date,
  String? checkin,
  dynamic checkout,
  dynamic onBreak,
  dynamic offBreak,
  dynamic totalHours,
  String? createdAt,
  String? updatedAt,
}) => User(  id: id ?? _id,
  userId: userId ?? _userId,
  date: date ?? _date,
  checkin: checkin ?? _checkin,
  checkout: checkout ?? _checkout,
  onBreak: onBreak ?? _onBreak,
  offBreak: offBreak ?? _offBreak,
  totalHours: totalHours ?? _totalHours,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  num? get userId => _userId;
  String? get date => _date;
  String? get checkin => _checkin;
  dynamic get checkout => _checkout;
  dynamic get onBreak => _onBreak;
  dynamic get offBreak => _offBreak;
  dynamic get totalHours => _totalHours;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['date'] = _date;
    map['checkin'] = _checkin;
    map['checkout'] = _checkout;
    map['on_break'] = _onBreak;
    map['off_break'] = _offBreak;
    map['total_hours'] = _totalHours;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}