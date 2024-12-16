class ClientCallLogModel {
  bool? status;
  String? message;
  List<Call>? data;

  ClientCallLogModel({this.status, this.message, this.data});

  ClientCallLogModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Call>[];
      json['data'].forEach((v) {
        data!.add(new Call.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Call {
  int? id;
  String? date;
  int? userId;
  String? photo;
  String? description;
  String? address;
  String? status;
  String? createdAt;
  String? updatedAt;

  Call(
      {this.id,
        this.date,
        this.userId,
        this.photo,
        this.description,
        this.address,
        this.status,
        this.createdAt,
        this.updatedAt});

  Call.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    userId = json['userId'];
    photo = json['photo'];
    description = json['description'];
    address = json['address'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['userId'] = this.userId;
    data['photo'] = this.photo;
    data['description'] = this.description;
    data['address'] = this.address;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
