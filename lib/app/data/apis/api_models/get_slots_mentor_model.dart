class GetSlotsMentorModel {
  GetSlotsMentorResult? result;
  String? message;
  String? status;

  GetSlotsMentorModel({this.result, this.message, this.status});

  GetSlotsMentorModel.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? new GetSlotsMentorResult.fromJson(json['result']) : null;
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

class GetSlotsMentorResult {
  String? id;
  String? userId;
  String? mondayStartTime;
  String? mondayCloseTime;
  String? tuesdayStartTime;
  String? tuesdayCloseTime;
  String? wednesdayStartTime;
  String? wednesdayCloseTime;
  String? thursdayStartTime;
  String? thursdayCloseTime;
  String? fridayStartTime;
  String? fridayCloseTime;
  String? saturdayStartTime;
  String? saturdayCloseTime;
  String? sundayStartTime;
  String? sundayCloseTime;
  String? mondayStartBreakTime;
  String? mondayCloseBreakTime;
  String? tuesdayStartBreakTime;
  String? tuesdayCloseBreakTime;
  String? wednesdayStartBreakTime;
  String? wednesdayCloseBreakTime;
  String? thursdayStartBreakTime;
  String? thursdayCloseBreakTime;
  String? fridayStartBreakTime;
  String? fridayCloseBreakTime;
  String? saturdayStartBreakTime;
  String? saturdayCloseBreakTime;
  String? sundayStartBreakTime;
  String? sundayCloseBreakTime;

  GetSlotsMentorResult(
      {this.id,
        this.userId,
        this.mondayStartTime,
        this.mondayCloseTime,
        this.tuesdayStartTime,
        this.tuesdayCloseTime,
        this.wednesdayStartTime,
        this.wednesdayCloseTime,
        this.thursdayStartTime,
        this.thursdayCloseTime,
        this.fridayStartTime,
        this.fridayCloseTime,
        this.saturdayStartTime,
        this.saturdayCloseTime,
        this.sundayStartTime,
        this.sundayCloseTime,
        this.mondayStartBreakTime,
        this.mondayCloseBreakTime,
        this.tuesdayStartBreakTime,
        this.tuesdayCloseBreakTime,
        this.wednesdayStartBreakTime,
        this.wednesdayCloseBreakTime,
        this.thursdayStartBreakTime,
        this.thursdayCloseBreakTime,
        this.fridayStartBreakTime,
        this.fridayCloseBreakTime,
        this.saturdayStartBreakTime,
        this.saturdayCloseBreakTime,
        this.sundayStartBreakTime,
        this.sundayCloseBreakTime});

  GetSlotsMentorResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    mondayStartTime = json['monday_start_time'];
    mondayCloseTime = json['monday_close_time'];
    tuesdayStartTime = json['tuesday_start_time'];
    tuesdayCloseTime = json['tuesday_close_time'];
    wednesdayStartTime = json['wednesday_start_time'];
    wednesdayCloseTime = json['wednesday_close_time'];
    thursdayStartTime = json['thursday_start_time'];
    thursdayCloseTime = json['thursday_close_time'];
    fridayStartTime = json['friday_start_time'];
    fridayCloseTime = json['friday_close_time'];
    saturdayStartTime = json['saturday_start_time'];
    saturdayCloseTime = json['saturday_close_time'];
    sundayStartTime = json['sunday_start_time'];
    sundayCloseTime = json['sunday_close_time'];
    mondayStartBreakTime = json['monday_start_break_time'];
    mondayCloseBreakTime = json['monday_close_break_time'];
    tuesdayStartBreakTime = json['tuesday_start_break_time'];
    tuesdayCloseBreakTime = json['tuesday_close_break_time'];
    wednesdayStartBreakTime = json['wednesday_start_break_time'];
    wednesdayCloseBreakTime = json['wednesday_close_break_time'];
    thursdayStartBreakTime = json['thursday_start_break_time'];
    thursdayCloseBreakTime = json['thursday_close_break_time'];
    fridayStartBreakTime = json['friday_start_break_time'];
    fridayCloseBreakTime = json['friday_close_break_time'];
    saturdayStartBreakTime = json['saturday_start_break_time'];
    saturdayCloseBreakTime = json['saturday_close_break_time'];
    sundayStartBreakTime = json['sunday_start_break_time'];
    sundayCloseBreakTime = json['sunday_close_break_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['monday_start_time'] = this.mondayStartTime;
    data['monday_close_time'] = this.mondayCloseTime;
    data['tuesday_start_time'] = this.tuesdayStartTime;
    data['tuesday_close_time'] = this.tuesdayCloseTime;
    data['wednesday_start_time'] = this.wednesdayStartTime;
    data['wednesday_close_time'] = this.wednesdayCloseTime;
    data['thursday_start_time'] = this.thursdayStartTime;
    data['thursday_close_time'] = this.thursdayCloseTime;
    data['friday_start_time'] = this.fridayStartTime;
    data['friday_close_time'] = this.fridayCloseTime;
    data['saturday_start_time'] = this.saturdayStartTime;
    data['saturday_close_time'] = this.saturdayCloseTime;
    data['sunday_start_time'] = this.sundayStartTime;
    data['sunday_close_time'] = this.sundayCloseTime;
    data['monday_start_break_time'] = this.mondayStartBreakTime;
    data['monday_close_break_time'] = this.mondayCloseBreakTime;
    data['tuesday_start_break_time'] = this.tuesdayStartBreakTime;
    data['tuesday_close_break_time'] = this.tuesdayCloseBreakTime;
    data['wednesday_start_break_time'] = this.wednesdayStartBreakTime;
    data['wednesday_close_break_time'] = this.wednesdayCloseBreakTime;
    data['thursday_start_break_time'] = this.thursdayStartBreakTime;
    data['thursday_close_break_time'] = this.thursdayCloseBreakTime;
    data['friday_start_break_time'] = this.fridayStartBreakTime;
    data['friday_close_break_time'] = this.fridayCloseBreakTime;
    data['saturday_start_break_time'] = this.saturdayStartBreakTime;
    data['saturday_close_break_time'] = this.saturdayCloseBreakTime;
    data['sunday_start_break_time'] = this.sundayStartBreakTime;
    data['sunday_close_break_time'] = this.sundayCloseBreakTime;
    return data;
  }
}
