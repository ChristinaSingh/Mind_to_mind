class ChatTokenModel {
  ChatTokenResult? result;
  String? message;
  String? status;

  ChatTokenModel({this.result, this.message, this.status});

  ChatTokenModel.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? new ChatTokenResult.fromJson(json['result']) : null;
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

class ChatTokenResult {
  String? id;
  String? senderId;
  String? receiverId;
  String? appointmentId;
  String? token;
  String? dateTime;

  ChatTokenResult(
      {this.id,
        this.senderId,
        this.receiverId,
        this.appointmentId,
        this.token,
        this.dateTime});

  ChatTokenResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    appointmentId = json['appointment_id'];
    token = json['token'];
    dateTime = json['date_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['appointment_id'] = this.appointmentId;
    data['token'] = this.token;
    data['date_time'] = this.dateTime;
    return data;
  }
}
