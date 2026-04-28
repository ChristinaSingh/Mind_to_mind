class AddVideoConnectionModel {
  AddVideoConnectionResult? result;
  String? message;
  String? status;

  AddVideoConnectionModel({this.result, this.message, this.status});

  AddVideoConnectionModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null
        ? new AddVideoConnectionResult.fromJson(json['result'])
        : null;
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

class AddVideoConnectionResult {
  String? id;
  String? userId;
  String? otherUserId;
  String? channelName;
  String? dateTime;
  String? appointmentId;
  String? token;

  AddVideoConnectionResult({
    this.id,
    this.userId,
    this.otherUserId,
    this.channelName,
    this.dateTime,
    this.appointmentId,
    this.token,
  });

  AddVideoConnectionResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    otherUserId = json['other_user_id'];
    channelName = json['channel_name'];
    dateTime = json['date_time'];
    appointmentId = json['appointment_id'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['other_user_id'] = this.otherUserId;
    data['channel_name'] = this.channelName;
    data['date_time'] = this.dateTime;
    data['appointment_id'] = this.appointmentId;
    data['token'] = this.token;
    return data;
  }
}
