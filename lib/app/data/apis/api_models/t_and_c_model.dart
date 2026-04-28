class TandConditionModel {
  TandConditionResult? result;
  String? message;
  String? status;

  TandConditionModel({this.result, this.message, this.status});

  TandConditionModel.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? new TandConditionResult.fromJson(json['result']) : null;
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

class TandConditionResult {
  String? id;
  String? name;
  String? description;
  String? status;
  String? dateTime;

  TandConditionResult({this.id, this.name, this.description, this.status, this.dateTime});

  TandConditionResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    status = json['status'];
    dateTime = json['date_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['status'] = this.status;
    data['date_time'] = this.dateTime;
    return data;
  }
}
