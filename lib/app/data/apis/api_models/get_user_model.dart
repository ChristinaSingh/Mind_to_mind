class UserModel {
  UserResult? result;
  String? message;
  String? status;

  UserModel({this.result, this.message, this.status});

  UserModel.fromJson(Map<String, dynamic> json) {
    result =
        json['result'] != null ? UserResult.fromJson(json['result']) : null;
    message = json['message'];
    status = json['status'].toString();
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

class UserResult {
  String? id;
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
  String? type;
  String? status;
  String? dateTime;
  String? country;
  String? categoryId;
  String? about;
  String? currentPosition;
  String? lang;
  String? profession;
  String? professionLocation;
  String? messageRate;
  String? audioRate;
  String? videoRate;
  String? exp;
  String? socialMediaUrl;

  UserResult({
    this.id,
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
    this.type,
    this.status,
    this.dateTime,
    this.country,
    this.categoryId,
    this.about,
    this.currentPosition,
    this.lang,
    this.profession,
    this.professionLocation,
    this.messageRate,
    this.audioRate,
    this.videoRate,
    this.exp,
    this.socialMediaUrl,
  });

  UserResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    type = json['type'];
    status = json['status'];
    dateTime = json['date_time'];
    country = json['country'];
    categoryId = json['category_id'];
    about = json['about'];
    currentPosition = json['current_position'];
    lang = json['lang'];
    profession = json['profession'];
    professionLocation = json['profession_location'];
    messageRate = json['message_rate'];
    audioRate = json['audio_rate'];
    videoRate = json['video_rate'];
    exp = json['exp'];
    socialMediaUrl = json['social_media_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['mobile'] = mobile;
    data['password'] = password;
    data['email'] = email;
    data['image'] = image;
    data['register_id'] = registerId;
    data['social_id'] = socialId;
    data['gender'] = gender;
    data['dob'] = dob;
    data['otp'] = otp;
    data['address'] = address;
    data['lat'] = lat;
    data['lon'] = lon;
    data['step'] = step;
    data['type'] = type;
    data['status'] = status;
    data['date_time'] = dateTime;
    data['country'] = country;
    data['category_id'] = categoryId;
    data['about'] = about;
    data['current_position'] = currentPosition;
    data['lang'] = lang;
    data['profession'] = profession;
    data['profession_location'] = professionLocation;
    data['message_rate'] = messageRate;
    data['audio_rate'] = audioRate;
    data['video_rate'] = videoRate;
    data['exp'] = exp;
    data['social_media_url'] = socialMediaUrl;

    return data;
  }
}
