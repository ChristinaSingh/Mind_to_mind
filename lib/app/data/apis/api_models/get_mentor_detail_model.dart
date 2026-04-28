class MentorDetailModel {
  MentorDetailResult? result;
  String? message;
  String? status;

  MentorDetailModel({this.result, this.message, this.status});

  MentorDetailModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null
        ? MentorDetailResult.fromJson(json['result'])
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

class MentorDetailResult {
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
  String? exp;
  String? socialMediaUrl;
  String? favoriteStatus;
  String? categoryName;
  MentorTime? mentorTime;

  MentorDetailResult(
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
      this.videoRate,
      this.exp,
      this.socialMediaUrl,
      this.favoriteStatus,
      this.categoryName,
      this.mentorTime});

  MentorDetailResult.fromJson(Map<String, dynamic> json) {
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
    exp = json['exp'];
    socialMediaUrl = json['social_media_url'];
    favoriteStatus = json['favorite_status'];
    categoryName = json['category_name'];
    mentorTime = json['mentor_time'] != null
        ? MentorTime.fromJson(json['mentor_time'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
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
    data['status'] = status;
    data['date_time'] = dateTime;
    data['country'] = country;
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
    data['favorite_status'] = favoriteStatus;
    data['category_name'] = categoryName;
    if (mentorTime != null) {
      data['mentor_time'] = mentorTime!.toJson();
    }
    return data;
  }
}

class MentorTime {
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

  MentorTime(
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
      this.sundayCloseTime});

  MentorTime.fromJson(Map<String, dynamic> json) {
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['monday_start_time'] = mondayStartTime;
    data['monday_close_time'] = mondayCloseTime;
    data['tuesday_start_time'] = tuesdayStartTime;
    data['tuesday_close_time'] = tuesdayCloseTime;
    data['wednesday_start_time'] = wednesdayStartTime;
    data['wednesday_close_time'] = wednesdayCloseTime;
    data['thursday_start_time'] = thursdayStartTime;
    data['thursday_close_time'] = thursdayCloseTime;
    data['friday_start_time'] = fridayStartTime;
    data['friday_close_time'] = fridayCloseTime;
    data['saturday_start_time'] = saturdayStartTime;
    data['saturday_close_time'] = saturdayCloseTime;
    data['sunday_start_time'] = sundayStartTime;
    data['sunday_close_time'] = sundayCloseTime;
    return data;
  }
}
