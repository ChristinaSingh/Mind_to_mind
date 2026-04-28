class GetAppointmentListModel {
  List<GetAppointmentListResult>? result;
  String? message;
  String? status;

  GetAppointmentListModel({this.result, this.message, this.status});

  GetAppointmentListModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <GetAppointmentListResult>[];
      json['result'].forEach((v) {
        result!.add(GetAppointmentListResult.fromJson(v));
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

class GetAppointmentListResult {
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
  UserDetails? userDetails;
  UserDetails? mentorDetails;

  GetAppointmentListResult({
    this.id,
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
    this.userDetails,
    this.mentorDetails,
  });

  GetAppointmentListResult.fromJson(Map<String, dynamic> json) {
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
    userDetails = json['user_details'] != null
        ? UserDetails.fromJson(json['user_details'])
        : null;
    mentorDetails = json['mentor_details'] != null
        ? UserDetails.fromJson(json['mentor_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['mentor_id'] = mentorId;
    data['time'] = time;
    data['date_time'] = dateTime;
    data['appointment_date'] = appointmentDate;
    data['package_id'] = packageId;
    data['amount'] = amount;
    data['status'] = status;
    data['payment_id'] = paymentId;
    data['payment_status'] = paymentStatus;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['channel_name'] = channelName;
    data['token'] = token;
    if (userDetails != null) {
      data['user_details'] = userDetails!.toJson();
    }
    if (mentorDetails != null) {
      data['mentor_details'] = mentorDetails!.toJson();
    }
    return data;
  }

  // ✅ MOVED HERE: extract "09:00" from "2026-03-22 09:00:00"
  String? get startTimeOnly {
    if (startTime == null || startTime!.isEmpty) return null;
    return startTime!.length >= 16 ? startTime!.substring(11, 16) : startTime;
  }

  String? get endTimeOnly {
    if (endTime == null || endTime!.isEmpty) return null;
    return endTime!.length >= 16 ? endTime!.substring(11, 16) : endTime;
  }

  // ✅ "09:00 → 09:30" or falls back to time field
  String get timeRange {
    if (startTimeOnly != null && endTimeOnly != null) {
      return '$startTimeOnly → $endTimeOnly';
    }
    return time ?? 'N/A';
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

  UserDetails({
    this.id,
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
    this.countryCode,
  });

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
    data['country_code'] = countryCode;
    return data;
  }
}