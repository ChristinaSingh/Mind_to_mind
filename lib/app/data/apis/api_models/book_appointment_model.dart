class BookAppointmentModel {
  BookAppointmentResult? result;
  String? message;
  String? status;

  BookAppointmentModel({this.result, this.message, this.status});

  BookAppointmentModel.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? new BookAppointmentResult.fromJson(json['result']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class BookAppointmentResult {
  String? id;
  String? userId;
  String? mentorId;
  String? time;
  String? dateTime;
  String? appointmentDate;
  String? packageId;
  String? amount;
  String? status;

  BookAppointmentResult(
      {this.id,
        this.userId,
        this.mentorId,
        this.time,
        this.dateTime,
        this.appointmentDate,
        this.packageId,
        this.amount,
        this.status});

  BookAppointmentResult.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['mentor_id'] = this.mentorId;
    data['time'] = this.time;
    data['date_time'] = this.dateTime;
    data['appointment_date'] = this.appointmentDate;
    data['package_id'] = this.packageId;
    data['amount'] = this.amount;
    data['status'] = this.status;
    return data;
  }
}
