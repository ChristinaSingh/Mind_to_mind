class CheckAppointmentSlotModel {
  List<CheckAppointmentSlotResult>? result;
  String? message;
  String? status;
  String? openTime;
  String? closeTime;

  CheckAppointmentSlotModel({this.result, this.message, this.status});

  CheckAppointmentSlotModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <CheckAppointmentSlotResult>[];
      json['result'].forEach((v) {
        result!.add(new CheckAppointmentSlotResult.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
    openTime = json['open_time'];
    closeTime = json['close_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    data['open_time'] = this.openTime;
    data['close_time'] = this.closeTime;
    return data;
  }
}

class CheckAppointmentSlotResult {
  String? id;
  String? time;
  String? timeMatched;
  String? availableSlot;
  bool? available;

  CheckAppointmentSlotResult({this.id, this.time, this.timeMatched, this.availableSlot, this.available});

  CheckAppointmentSlotResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    timeMatched = json['time_matched'];
    availableSlot = json['available_slot'];
    available = json['available']??false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['time'] = this.time;
    data['time_matched'] = this.timeMatched;
    data['available_slot'] = this.availableSlot;
    data['available'] = this.available;
    return data;
  }
}
