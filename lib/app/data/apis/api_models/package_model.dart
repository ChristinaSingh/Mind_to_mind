class PackageModel {
  PackageResult? result;
  String? message;
  String? status;

  PackageModel({this.result, this.message, this.status});

  PackageModel.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? new PackageResult.fromJson(json['result']) : null;
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

class PackageResult {
  String? id;
  String? type;
  String? name;
  String? mobile;
  String? password;
  String? email;
  String? image;
  String? registerId;
  String? socialId;
  String? gender;
  String? dob;
  String? otp;
  String? address;
  String? lat;
  String? lon;
  String? step;
  String? status;
  String? dateTime;
  String? country;
  String? about;
  String? currentPosition;
  String? lang;
  String? profession;
  String? professionLocation;
  String? messageRate;
  String? audioRate;
  String? videoRate;

  PackageResult(
      {this.id,
        this.type,
        this.name,
        this.mobile,
        this.password,
        this.email,
        this.image,
        this.registerId,
        this.socialId,
        this.gender,
        this.dob,
        this.otp,
        this.address,
        this.lat,
        this.lon,
        this.step,
        this.status,
        this.dateTime,
        this.country,
        this.about,
        this.currentPosition,
        this.lang,
        this.profession,
        this.professionLocation,
        this.messageRate,
        this.audioRate,
        this.videoRate});

  PackageResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    mobile = json['mobile'];
    password = json['password'];
    email = json['email'];
    image = json['image'];
    registerId = json['register_id'];
    socialId = json['social_id'];
    gender = json['gender'];
    dob = json['dob'];
    otp = json['otp'];
    address = json['address'];
    lat = json['lat'];
    lon = json['lon'];
    step = json['step'];
    status = json['status'];
    dateTime = json['date_time'];
    country = json['country'];
    about = json['about'];
    currentPosition = json['current_position'];
    lang = json['lang'];
    profession = json['profession'];
    professionLocation = json['profession_location'];
    messageRate = json['message_rate'];
    audioRate = json['audio_rate'];
    videoRate = json['video_rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['password'] = this.password;
    data['email'] = this.email;
    data['image'] = this.image;
    data['register_id'] = this.registerId;
    data['social_id'] = this.socialId;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['otp'] = this.otp;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['step'] = this.step;
    data['status'] = this.status;
    data['date_time'] = this.dateTime;
    data['country'] = this.country;
    data['about'] = this.about;
    data['current_position'] = this.currentPosition;
    data['lang'] = this.lang;
    data['profession'] = this.profession;
    data['profession_location'] = this.professionLocation;
    data['message_rate'] = this.messageRate;
    data['audio_rate'] = this.audioRate;
    data['video_rate'] = this.videoRate;
    return data;
  }
}
