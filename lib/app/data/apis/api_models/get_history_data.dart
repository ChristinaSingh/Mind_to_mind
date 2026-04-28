class GetNotificationModel {
  List<NotificationResult>? result;
  String? message;
  String? status;

  GetNotificationModel({this.result, this.message, this.status});

  GetNotificationModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <NotificationResult>[];
      json['result'].forEach((v) {
        result!.add(new NotificationResult.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class NotificationResult {
  String? id;
  String? userId;
  String? mentorId;
  String? time;
  String? dateTime;
  String? appointmentDate;
  String? packageId;
  String? amount;
  String? status;
  String? paymentId;
  String? paymentStatus;
  String? startTime;
  String? endTime;
  String? channelName;
  String? token;
  String? chatStatus;
  String? chatId;
  UserDetails? userDetails;
  UserDetails? mentorDetails;

  NotificationResult(
      {this.id,
        this.userId,
        this.mentorId,
        this.time,
        this.dateTime,
        this.appointmentDate,
        this.packageId,
        this.amount,
        this.status,
        this.paymentId,
        this.paymentStatus,
        this.startTime,
        this.endTime,
        this.channelName,
        this.token,
        this.chatStatus,
        this.chatId,
        this.userDetails,
        this.mentorDetails});

  NotificationResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    mentorId = json['mentor_id'];
    time = json['time'];
    dateTime = json['date_time'];
    appointmentDate = json['appointment_date'];
    packageId = json['package_id'];
    amount = json['amount'];
    status = json['status'];
    paymentId = json['payment_id'];
    paymentStatus = json['payment_status'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    channelName = json['channel_name'];
    token = json['token'];
    chatStatus = json['chat_status'];
    chatId = json['chat_id'];
    userDetails = json['user_details'] != null
        ? new UserDetails.fromJson(json['user_details'])
        : null;
    mentorDetails = json['mentor_details'] != null
        ? new UserDetails.fromJson(json['mentor_details'])
        : null;
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
    data['payment_id'] = this.paymentId;
    data['payment_status'] = this.paymentStatus;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['channel_name'] = this.channelName;
    data['token'] = this.token;
    data['chat_status'] = this.chatStatus;
    data['chat_id'] = this.chatId;
    if (this.userDetails != null) {
      data['user_details'] = this.userDetails!.toJson();
    }
    if (this.mentorDetails != null) {
      data['mentor_details'] = this.mentorDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
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
  String? countryCode;

  UserDetails(
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
        this.countryCode});

  UserDetails.fromJson(Map<String, dynamic> json) {
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
    countryCode = json['country_code'];
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
    data['exp'] = this.exp;
    data['social_media_url'] = this.socialMediaUrl;
    data['country_code'] = this.countryCode;
    return data;
  }
}
