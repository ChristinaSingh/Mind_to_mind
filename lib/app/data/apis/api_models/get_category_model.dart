class GetCategoryModel {
  List<GetCategoryResult>? result;
  String? message;
  String? status;

  GetCategoryModel({this.result, this.message, this.status});

  GetCategoryModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <GetCategoryResult>[];
      json['result'].forEach((v) {
        result!.add(GetCategoryResult.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class GetCategoryResult {
  String? id;
  String? categoryName;
  String? image;
  String? dateTime;

  GetCategoryResult({this.id, this.categoryName, this.image, this.dateTime});

  GetCategoryResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    image = json['image'];
    dateTime = json['date_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_name'] = categoryName;
    data['image'] = image;
    data['date_time'] = dateTime;
    return data;
  }
}
