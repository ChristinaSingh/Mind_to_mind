import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mindtomind/app/data/apis/api_models/add_video_connection_model.dart';
import 'package:mindtomind/app/data/apis/api_models/appointment_details_model.dart';
import 'package:mindtomind/app/data/apis/api_models/book_appointment_model.dart';
import 'package:mindtomind/app/data/apis/api_models/general_model.dart';
import 'package:mindtomind/app/data/apis/api_models/get_appointmentlist_model.dart';
import 'package:mindtomind/app/data/apis/api_models/get_banner_mode.dart';
import 'package:mindtomind/app/data/apis/api_models/get_category_model.dart';
import 'package:mindtomind/app/data/apis/api_models/get_favorite_list_model.dart';
import 'package:mindtomind/app/data/apis/api_models/get_mentor_detail_model.dart';
import 'package:mindtomind/app/data/apis/api_models/get_slots_mentor_model.dart';
import 'package:mindtomind/app/data/apis/api_models/get_slots_model.dart';
import 'package:mindtomind/app/data/apis/api_models/get_user_model.dart';
import 'package:mindtomind/app/data/apis/api_models/package_model.dart';
import 'package:mindtomind/app/data/apis/api_models/t_and_c_model.dart';

import '../../../../common/http_methods.dart';
import '../../../modules/book_appointment/controllers/book_appointment_controller.dart';
import '../api_constants/api_url_constants.dart';
import '../api_models/chat_token_model.dart';
import '../api_models/check_appointment_slot_model.dart';
import '../api_models/get_history_data.dart';
import '../api_models/get_mentor_list_model.dart';
import '../api_models/get_update_status_model.dart';

class ApiMethods {
  /// Loging api...
  static Future<UserModel?> loginApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    UserModel? userModel;
    http.Response? response = await MyHttp.postMethod(
        url: ApiUrlConstants.endPointOfLogin,
        checkResponse: checkResponse,
        bodyParams: bodyParams,
        wantSnackBar: false);
    if (response != null) {
      userModel = UserModel.fromJson(jsonDecode(response.body));
      return userModel;
    }
    return null;
  }

  ///SigUp Api Calling.....
  static Future<UserModel?> signUpApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
    Map<String, File>? imageMap,
  }) async {
    UserModel? logInModel;
    http.Response? response = await MyHttp.multipart(
      bodyParams: bodyParams,
      url: ApiUrlConstants.endPointOfSignup,
      imageMap: imageMap,
      checkResponse: checkResponse,
    );

    if (response != null) {
      logInModel = UserModel.fromJson(jsonDecode(response.body));
      return logInModel;
    }
    return null;
  }

  static Future<UserModel?> forgetPasswordApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    UserModel? userModel;
    http.Response? response = await MyHttp.postMethod(
        url: ApiUrlConstants.endPointOfForgotPassword,
        checkResponse: checkResponse,
        bodyParams: bodyParams,
        wantSnackBar: false);
    if (response != null) {
      userModel = UserModel.fromJson(jsonDecode(response.body));
      return userModel;
    }
    return null;
  }

  static Future<UserModel?> checkOtpApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    UserModel? userModel;
    http.Response? response = await MyHttp.postMethod(
        url: ApiUrlConstants.endPointOfCheckOtp,
        checkResponse: checkResponse,
        bodyParams: bodyParams,
        wantSnackBar: false);
    if (response != null) {
      userModel = UserModel.fromJson(jsonDecode(response.body));
      return userModel;
    }
    return null;
  }

  static Future<GeneralModel?> resetPasswordApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    GeneralModel? generalModel;
    http.Response? response = await MyHttp.postMethod(
        url: ApiUrlConstants.endPointOfResetPassword,
        checkResponse: checkResponse,
        bodyParams: bodyParams,
        wantSnackBar: false);
    if (response != null) {
      generalModel = GeneralModel.fromJson(jsonDecode(response.body));
      return generalModel;
    }
    return null;
  }

  static Future<AppointmentDetailsModel?> getAppointmentDetailsApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    AppointmentDetailsModel? appointmentDetailsModel;
    http.Response? response = await MyHttp.postMethod(
        url: ApiUrlConstants.endPointOfGetAppointmentDetails,
        checkResponse: checkResponse,
        bodyParams: bodyParams,
        wantSnackBar: false);
    if (response != null) {
      appointmentDetailsModel =
          AppointmentDetailsModel.fromJson(jsonDecode(response.body));
      return appointmentDetailsModel;
    }
    return null;
  }

  ///Update Profile Api Calling.....
  static Future<UserModel?> updateProfileApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
    Map<String, File>? imageMap,
  }) async {
    UserModel? logInModel;
    http.Response? response = await MyHttp.multipart(
      bodyParams: bodyParams,
      url: ApiUrlConstants.endPointOfUpdateProfileMentor,
      imageMap: imageMap,
      checkResponse: checkResponse,
    );
    print("params are:::$bodyParams");
    if (response != null) {
      logInModel = UserModel.fromJson(jsonDecode(response.body));
      return logInModel;
    }
    return null;
  }

  static Future<UserModel?> updateMenteeProfileApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
    Map<String, File>? imageMap,
  }) async {
    UserModel? logInModel;
    http.Response? response = await MyHttp.multipart(
      bodyParams: bodyParams,
      url: ApiUrlConstants.endPointOfUpdateProfileMentee,
      imageMap: imageMap,
      checkResponse: checkResponse,
    );
    print("params are:::$bodyParams");
    if (response != null) {
      logInModel = UserModel.fromJson(jsonDecode(response.body));
      return logInModel;
    }
    return null;
  }

  /// Add Details api...
  static Future<UserModel?> addDetailsApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    UserModel? userModel;
    http.Response? response = await MyHttp.postMethod(
        url: ApiUrlConstants.endPointOfAddMentorDetails,
        checkResponse: checkResponse,
        bodyParams: bodyParams,
        wantSnackBar: false);
    if (response != null) {
      userModel = UserModel.fromJson(jsonDecode(response.body));
      return userModel;
    }
    return null;
  }

  /// Add Select Days api...
  static Future<UserModel?> addDaysApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    UserModel? userModel;
    http.Response? response = await MyHttp.postMethod(
        url: ApiUrlConstants.endPointOfAddSlote,
        checkResponse: checkResponse,
        bodyParams: bodyParams,
        wantSnackBar: false);
    if (response != null) {
      userModel = UserModel.fromJson(jsonDecode(response.body));
      return userModel;
    }
    return null;
  }

  /// Get Profile api...
  static Future<UserModel?> getProfile(
      {void Function(int)? checkResponse,
      Map<String, dynamic>? bodyParams,
      required String userId}) async {
    UserModel? userModel;
    http.Response? response = await MyHttp.getMethod(
      url: '${ApiUrlConstants.endPointOfGetProfile}?user_id=$userId',
      checkResponse: checkResponse,
    );
    if (response != null) {
      userModel = UserModel.fromJson(jsonDecode(response.body));
      return userModel;
    }
    return null;
  }

  /// Get Banner ...
  static Future<BannerModel?> bannerApi({
    void Function(int)? checkResponse,
  }) async {
    BannerModel? bannerModel;
    http.Response? response = await MyHttp.getMethod(
      url: ApiUrlConstants.endPointOfGetBanner,
      checkResponse: checkResponse,
    );
    if (response != null) {
      bannerModel = BannerModel.fromJson(jsonDecode(response.body));
      return bannerModel;
    }
    return null;
  }

  /// Get Category api ...
  static Future<GetCategoryModel?> categoryApi({
    void Function(int)? checkResponse,
  }) async {
    GetCategoryModel? bannerModel;
    http.Response? response = await MyHttp.getMethod(
      url: ApiUrlConstants.endPointOfGetCategory,
      checkResponse: checkResponse,
    );
    if (response != null) {
      bannerModel = GetCategoryModel.fromJson(jsonDecode(response.body));
      return bannerModel;
    }
    return null;
  }

  /// Get Mental List Api ...
  static Future<MentorListModel?> getMentorListApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    MentorListModel? mentorListModel;
    http.Response? response = await MyHttp.postMethod(
        bodyParams: bodyParams,
        url: ApiUrlConstants.endPointOfGetMentor,
        checkResponse: checkResponse,
        wantSnackBar: false);
    if (response != null) {
      mentorListModel = MentorListModel.fromJson(jsonDecode(response.body));
      return mentorListModel;
    }
    return null;
  }

  /// Get Mental Details Api ...
  static Future<MentorDetailModel?> getMentorDetailsApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    MentorDetailModel? mentorDetailModel;
    http.Response? response = await MyHttp.postMethod(
        bodyParams: bodyParams,
        url: ApiUrlConstants.endPointOfGetMentorDetails,
        checkResponse: checkResponse,
        wantSnackBar: false);
    if (response != null) {
      mentorDetailModel = MentorDetailModel.fromJson(jsonDecode(response.body));
      return mentorDetailModel;
    }
    return null;
  }

  /// Add to cart Api ...
  static Future<GeneralModel?> addToCartApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    GeneralModel? generalModel;
    http.Response? response = await MyHttp.postMethod(
        bodyParams: bodyParams,
        url: ApiUrlConstants.endPointOfGetFavoriteMentor,
        checkResponse: checkResponse,
        wantSnackBar: false);
    if (response != null) {
      generalModel = GeneralModel.fromJson(jsonDecode(response.body));
      return generalModel;
    }
    return null;
  }

  /// Get Mental List By Category Api ...
  static Future<MentorListModel?> getMentorListByCategoryApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    MentorListModel? mentorListModel;
    http.Response? response = await MyHttp.postMethod(
      bodyParams: bodyParams,
      wantSnackBar: false,
      url: ApiUrlConstants.endPointOfGetMentorByCategory,
      checkResponse: checkResponse,
    );
    if (response != null) {
      mentorListModel = MentorListModel.fromJson(jsonDecode(response.body));
      return mentorListModel;
    }
    return null;
  }

  /// Current Position Search Api ...
  static Future<MentorListModel?> currentPositionSearchApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    MentorListModel? mentorListModel;
    http.Response? response = await MyHttp.postMethod(
      bodyParams: bodyParams,
      wantSnackBar: false,
      url: ApiUrlConstants.endPointOfCurrentPositionSearch,
      checkResponse: checkResponse,
    );
    if (response != null) {
      mentorListModel = MentorListModel.fromJson(jsonDecode(response.body));
      return mentorListModel;
    }
    return null;
  }

  ///  Get Appointment list api ...
  static Future<GetAppointmentListModel?> getMyAppointmentApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    GetAppointmentListModel? getAppointmentListModel;
    http.Response? response = await MyHttp.postMethod(
        bodyParams: bodyParams,
        url: ApiUrlConstants.endPointOfGetAppointment,
        checkResponse: checkResponse,
        wantSnackBar: false);
    if (response != null) {
      print("Response:-${response.body}");
      getAppointmentListModel =
          GetAppointmentListModel.fromJson(jsonDecode(response.body));
      return getAppointmentListModel;
    }
    return null;
  }

  static Future<GetNotificationModel?> getAllHistory({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    GetNotificationModel? getNotificationModel;
    http.Response? response = await MyHttp.postMethod(
        bodyParams: bodyParams,
        url: ApiUrlConstants.endPointOfGetHistory,
        checkResponse: checkResponse,
        wantSnackBar: false);
    if (response != null) {
      print("Response:-${response.body}");
      getNotificationModel =
          GetNotificationModel.fromJson(jsonDecode(response.body));
      return getNotificationModel;
    }
    return null;
  }

  ///  Get Appointment Mentor list api ...
  static Future<GetAppointmentListModel?> getAppointmentMentorApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    GetAppointmentListModel? getAppointmentListModel;
    http.Response? response = await MyHttp.postMethod(
        bodyParams: bodyParams,
        url: ApiUrlConstants.endPointOfGetAppointmentMentor,
        checkResponse: checkResponse,
        wantSnackBar: false);
    if (response != null) {
      print("Response:-${response.body}");
      getAppointmentListModel =
          GetAppointmentListModel.fromJson(jsonDecode(response.body));
      return getAppointmentListModel;
    }
    return null;
  }

  ///  Mentor Update Appointment Status  api ...
  static Future<UpdateStatusModel?> mentorUpdateAppointmentStatusApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    UpdateStatusModel? updateStatusModel;
    http.Response? response = await MyHttp.postMethod(
      bodyParams: bodyParams,
      wantSnackBar: false,
      url: ApiUrlConstants.endPointOfAcceptCancelAppointment,
      checkResponse: checkResponse,
    );
    if (response != null) {
      print("Response:-${response.body}");
      updateStatusModel = UpdateStatusModel.fromJson(jsonDecode(response.body));
      return updateStatusModel;
    }
    return null;
  }

  ///  Get History  api ...
  static Future<GetAppointmentListModel?> getHistoryListApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    GetAppointmentListModel? getAppointmentListModel;
    http.Response? response = await MyHttp.postMethod(
      bodyParams: bodyParams,
      wantSnackBar: false,
      url: ApiUrlConstants.endPointOfGetCompleteAppointmentMentor,
      checkResponse: checkResponse,
    );
    if (response != null) {
      print("Response:-${response.body}");
      getAppointmentListModel =
          GetAppointmentListModel.fromJson(jsonDecode(response.body));
      return getAppointmentListModel;
    }
    return null;
  }

  ///  Get Favorites api ...
  static Future<FavoriteListModel?> getFavoritesApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    FavoriteListModel? favoriteListModel;
    http.Response? response = await MyHttp.postMethod(
        bodyParams: bodyParams,
        url: ApiUrlConstants.endPointOfGetFavorite,
        checkResponse: checkResponse,
        wantSnackBar: false);
    if (response != null) {
      print("Response:-${response.body}");
      favoriteListModel = FavoriteListModel.fromJson(jsonDecode(response.body));
      return favoriteListModel;
    }
    return null;
  }

  ///  Get Favorites api ...
  static Future<GeneralModel?> changePasswordApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    GeneralModel? generalModel;
    http.Response? response = await MyHttp.postMethod(
      bodyParams: bodyParams,
      wantSnackBar: false,
      url: ApiUrlConstants.endPointOfChangePassword,
      checkResponse: checkResponse,
    );
    if (response != null) {
      print("Response:-${response.body}");
      generalModel = GeneralModel.fromJson(jsonDecode(response.body));
      return generalModel;
    }
    return null;
  }

  ///  Contact Us api ...
  static Future<GeneralModel?> contactUsApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    GeneralModel? generalModel;
    http.Response? response = await MyHttp.postMethod(
      bodyParams: bodyParams,
      wantSnackBar: false,
      url: ApiUrlConstants.endPointOfContactUs,
      checkResponse: checkResponse,
    );
    if (response != null) {
      print("Response:-${response.body}");
      generalModel = GeneralModel.fromJson(jsonDecode(response.body));
      return generalModel;
    }
    return null;
  }

  static Future<GetSlotsModel?> getSlotsApi({
    void Function(int)? checkResponse,
    required Map<String, dynamic> bodyParams,
  }) async {
    GetSlotsModel? getSlotsModel;
    http.Response? response = await MyHttp.getMethodParams(
      queryParameters: bodyParams,
      baseUri: ApiUrlConstants.baseUrlForGetMethodParams,
      endPointUri: ApiUrlConstants.endPointOfSlote,
      checkResponse: checkResponse,
    );
    if (response != null) {
      getSlotsModel = GetSlotsModel.fromJson(jsonDecode(response.body));
      return getSlotsModel;
    }
    return null;
  }

  static Future<GetAvailableSlotsModel?> getAvailableSlotsApi({
    void Function(int)? checkResponse,
    required Map<String, dynamic> bodyParams,
  }) async {
    GetAvailableSlotsModel? getAvailableSlotsModel;
    http.Response? response = await MyHttp.getMethodParams(
      queryParameters: bodyParams,
      baseUri: ApiUrlConstants.baseUrlForGetMethodParams,
      endPointUri: ApiUrlConstants.endPointOfAvailableSlots,
      checkResponse: checkResponse,
    );
    if (response != null) {
      getAvailableSlotsModel =
          GetAvailableSlotsModel.fromJson(jsonDecode(response.body));
      return getAvailableSlotsModel;
    }
    return null;
  }

  static Future<PackageModel?> getPackageApi({
    void Function(int)? checkResponse,
    required Map<String, dynamic> bodyParams,
  }) async {
    PackageModel? packageModel;
    http.Response? response = await MyHttp.getMethodParams(
      queryParameters: bodyParams,
      baseUri: ApiUrlConstants.baseUrlForGetMethodParams,
      endPointUri: ApiUrlConstants.endPointOfPackage,
      checkResponse: checkResponse,
    );
    if (response != null) {
      packageModel = PackageModel.fromJson(jsonDecode(response.body));
      return packageModel;
    }
    return null;
  }

  static Future<BookAppointmentModel?> bookAppointmentApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    BookAppointmentModel? bookAppointmentModel;
    http.Response? response = await MyHttp.postMethod(
        bodyParams: bodyParams,
        url: ApiUrlConstants.endPointOfBookAppointment,
        checkResponse: checkResponse,
        wantSnackBar: false);
    if (response != null) {
      bookAppointmentModel =
          BookAppointmentModel.fromJson(jsonDecode(response.body));
      return bookAppointmentModel;
    }
    return null;
  }

  static Future<TandConditionModel?> tAndCApi({
    void Function(int)? checkResponse,
  }) async {
    TandConditionModel? tandConditionModel;
    http.Response? response = await MyHttp.getMethod(
      url: ApiUrlConstants.endPointOfTandC,
      checkResponse: checkResponse,
    );
    if (response != null) {
      tandConditionModel =
          TandConditionModel.fromJson(jsonDecode(response.body));
      return tandConditionModel;
    }
    return null;
  }

  static Future<TandConditionModel?> privacyPolicyApi({
    void Function(int)? checkResponse,
  }) async {
    TandConditionModel? tandConditionModel;
    http.Response? response = await MyHttp.getMethod(
      url: ApiUrlConstants.endPointOfPrivacyPolicy,
      checkResponse: checkResponse,
    );
    if (response != null) {
      tandConditionModel =
          TandConditionModel.fromJson(jsonDecode(response.body));
      return tandConditionModel;
    }
    return null;
  }

  static Future<AddVideoConnectionModel?> addVideoConnectionApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    AddVideoConnectionModel? addVideoConnectionModel;
    http.Response? response = await MyHttp.postMethod(
      bodyParams: bodyParams,
      wantSnackBar: false,
      url: ApiUrlConstants.endPointOfAddVideoConnection,
      checkResponse: checkResponse,
    );
    if (response != null) {
      print("Response:-${response.body}");
      addVideoConnectionModel =
          AddVideoConnectionModel.fromJson(jsonDecode(response.body));
      return addVideoConnectionModel;
    }
    return null;
  }

  static Future<ChatTokenModel?> chatApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    ChatTokenModel? chatTokenModel;
    http.Response? response = await MyHttp.postMethod(
        bodyParams: bodyParams,
        url: ApiUrlConstants.endPointOfChatToken,
        checkResponse: checkResponse,
        wantSnackBar: false);
    if (response != null) {
      print("Response:-${response.body}");
      chatTokenModel = ChatTokenModel.fromJson(jsonDecode(response.body));
      return chatTokenModel;
    }
    return null;
  }

  static Future<GetSlotsMentorModel?> getMentorSlotsApi({
    void Function(int)? checkResponse,
    required Map<String, dynamic> bodyParams,
  }) async {
    GetSlotsMentorModel? getSlotsMentorModel;
    http.Response? response = await MyHttp.getMethodParams(
      queryParameters: bodyParams,
      baseUri: ApiUrlConstants.baseUrlForGetMethodParams,
      endPointUri: ApiUrlConstants.endPointOfMentorSlote,
      checkResponse: checkResponse,
    );
    if (response != null) {
      getSlotsMentorModel =
          GetSlotsMentorModel.fromJson(jsonDecode(response.body));
      return getSlotsMentorModel;
    }
    return null;
  }

  static Future<GetSlotsMentorModel?> updateSlotsApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    GetSlotsMentorModel? updateSlotModel;
    http.Response? response = await MyHttp.postMethod(
        url: ApiUrlConstants.endPointOfUpdateSlote,
        checkResponse: checkResponse,
        bodyParams: bodyParams,
        wantSnackBar: false);
    if (response != null) {
      updateSlotModel = GetSlotsMentorModel.fromJson(jsonDecode(response.body));
      return updateSlotModel;
    }
    return null;
  }

  static Future<CheckAppointmentSlotModel?> checkAppointmentSloteApi({
    void Function(int)? checkResponse,
    required Map<String, dynamic> bodyParams,
  }) async {
    CheckAppointmentSlotModel? checkAppointmentSlotModel;
    http.Response? response = await MyHttp.getMethodParams(
      queryParameters: bodyParams,
      baseUri: ApiUrlConstants.baseUrlForGetMethodParams,
      endPointUri: ApiUrlConstants.endPointOfCheckAppointmentSlote,
      checkResponse: checkResponse,
    );
    if (response != null) {
      checkAppointmentSlotModel =
          CheckAppointmentSlotModel.fromJson(jsonDecode(response.body));
      return checkAppointmentSlotModel;
    }
    return null;
  }

  static Future<UserModel?> addMultipleSlotsApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    UserModel? userModel;
    http.Response? response = await MyHttp.postMethod(
        url: ApiUrlConstants.endPointOfAddMultipleSlote,
        checkResponse: checkResponse,
        bodyParams: bodyParams,
        wantSnackBar: false);
    if (response != null) {
      print("data isssss:::::${response.body}");
      userModel = UserModel.fromJson(jsonDecode(response.body));
      return userModel;
    }
    return null;
  }

/* ///Update Profile Api Calling.....
  static Future<UserModel?> updateProfileApi({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
    Map<String, File>? imageMap,
  }) async {
    UserModel? logInModel;
    http.Response? response = await MyHttp.multipart(
      bodyParams: bodyParams,
      url: ApiUrlConstants.endPointOfUpdateProfile,
      imageMap: imageMap,
      checkResponse: checkResponse,
    );

    if (response != null) {
      logInModel = UserModel.fromJson(jsonDecode(response.body));
      return logInModel;
    }
    return null;
  }

  /// Get Service Provider Model...
  static Future<ServiceProviderModel?> getServiceProviderList({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    ServiceProviderModel? serviceProviderModel;
    http.Response? response = await MyHttp.postMethod(
      bodyParams: bodyParams,
      url: ApiUrlConstants.endPointOfGetServiceProviderList,
      checkResponse: checkResponse,
    );
    if (response != null) {
      serviceProviderModel =
          ServiceProviderModel.fromJson(jsonDecode(response.body));
      return serviceProviderModel;
    }
    return null;
  }

  /// Get Service Provider Details Model...
  static Future<ServiceProviderDetailModel?> getServiceProviderDetails({
    void Function(int)? checkResponse,
    Map<String, dynamic>? bodyParams,
  }) async {
    ServiceProviderDetailModel? serviceProviderDetailModel;
    http.Response? response = await MyHttp.postMethod(
      bodyParams: bodyParams,
      url: ApiUrlConstants.endPointOfGetServiceProviderDetails,
      checkResponse: checkResponse,
    );
    if (response != null) {
      serviceProviderDetailModel =
          ServiceProviderDetailModel.fromJson(jsonDecode(response.body));
      return serviceProviderDetailModel;
    }
    return null;
  }

  ///Add booking Api ....
  static Future<SimpleModel?> addBookingApi(
      {void Function(int)? checkResponse,
      Map<String, dynamic>? bodyParams,
      List<File>? imageList}) async {
    SimpleModel simpleModel;
    http.Response? response = await MyHttp.multipart(
      bodyParams: bodyParams,
      url: ApiUrlConstants.endPointOfAddBooking,
      images: imageList,
      imageKey: 'booking_images[]',
      checkResponse: checkResponse,
    );
    if (response != null) {
      simpleModel = SimpleModel.fromJson(jsonDecode(response.body));
      return simpleModel;
    }
    return null;
  }  */
}
