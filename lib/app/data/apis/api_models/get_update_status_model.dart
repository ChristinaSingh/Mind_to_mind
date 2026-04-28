class UpdateStatusModel {
  UpdateStatusResult? result;
  String? message;
  String? status;

  UpdateStatusModel({this.result, this.message, this.status});

  UpdateStatusModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null
        ? UpdateStatusResult.fromJson(json['result'])
        : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.toJson();
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class UpdateStatusResult {
  String? id;
  String? userId;
  String? mentorId;
  String? time;
  String? dateTime;
  String? appointmentDate;
  String? packageId;
  String? amount;
  String? status;

  UpdateStatusResult(
      {this.id,
      this.userId,
      this.mentorId,
      this.time,
      this.dateTime,
      this.appointmentDate,
      this.packageId,
      this.amount,
      this.status});

  UpdateStatusResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    mentorId = json['mentor_id'];
    time = json['time'];
    dateTime = json['date_time'];
    appointmentDate = json['appointment_date'];
    packageId = json['package_id'];
    amount = json['amount'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['mentor_id'] = mentorId;
    data['time'] = time;
    data['date_time'] = dateTime;
    data['appointment_date'] = appointmentDate;
    data['package_id'] = packageId;
    data['amount'] = amount;
    data['status'] = status;
    return data;
  }
}
