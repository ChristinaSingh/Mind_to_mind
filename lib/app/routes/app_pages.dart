import 'package:get/get.dart';
import 'package:mindtomind/app/modules/book_appointment/bindings/book_appointment_binding.dart';
import 'package:mindtomind/app/modules/book_appointment/views/book_appointment_view.dart';
import 'package:mindtomind/app/modules/booking_success/bindings/booking_success_binding.dart';
import 'package:mindtomind/app/modules/booking_success/views/booking_success_view.dart';
import 'package:mindtomind/app/modules/mentee_appointment_details/bindings/mentee_appointment_details_binding.dart';
import 'package:mindtomind/app/modules/mentee_appointment_details/views/mentee_appointment_details_view.dart';
import 'package:mindtomind/app/modules/mentor_appointment_details/bindings/mentor_appointment_details_binding.dart';
import 'package:mindtomind/app/modules/mentor_appointment_details/views/mentor_appointment_details_view.dart';
import 'package:mindtomind/app/modules/provider_appointment/bindings/provider_appointment_binding.dart';
import 'package:mindtomind/app/modules/provider_appointment/views/provider_appointment_view.dart';
import 'package:mindtomind/app/modules/select_package/bindings/select_package_binding.dart';
import 'package:mindtomind/app/modules/select_package/views/select_package_view.dart';
import 'package:mindtomind/app/modules/update_days/bindings/update_days_binding.dart';
import 'package:mindtomind/app/modules/update_days/views/update_days_view.dart';

import '../modules/add_details/bindings/add_details_binding.dart';
import '../modules/add_details/views/add_details_view.dart';
import '../modules/all_mentor_list/bindings/all_mentor_list_binding.dart';
import '../modules/all_mentor_list/views/all_mentor_list_view.dart';
import '../modules/appointment/bindings/appointment_binding.dart';
import '../modules/appointment/views/appointment_view.dart';
import '../modules/change_password/bindings/change_password_binding.dart';
import '../modules/change_password/views/change_password_view.dart';
import '../modules/choose_role/bindings/choose_role_binding.dart';
import '../modules/choose_role/views/choose_role_view.dart';
import '../modules/contact_us/bindings/contact_us_binding.dart';
import '../modules/contact_us/views/contact_us_view.dart';
import '../modules/create_new_password/bindings/create_new_password_binding.dart';
import '../modules/create_new_password/views/create_new_password_view.dart';
import '../modules/favorite/bindings/favorite_binding.dart';
import '../modules/favorite/views/favorite_view.dart';
import '../modules/forget_otp/bindings/forget_otp_binding.dart';
import '../modules/forget_otp/views/forget_otp_view.dart';
import '../modules/forget_password/bindings/forget_password_binding.dart';
import '../modules/forget_password/views/forget_password_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/let_get_start/bindings/let_get_start_binding.dart';
import '../modules/let_get_start/views/let_get_start_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/mentor_details/bindings/mentor_details_binding.dart';
import '../modules/mentor_details/views/mentor_details_view.dart';
import '../modules/my_profile/bindings/my_profile_binding.dart';
import '../modules/my_profile/views/my_profile_view.dart';
import '../modules/nav_bar/bindings/nav_bar_binding.dart';
import '../modules/nav_bar/views/nav_bar_view.dart';
import '../modules/privacy_policy/bindings/privacy_policy_binding.dart';
import '../modules/privacy_policy/views/privacy_policy_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/provider_chats/bindings/provider_chats_binding.dart';
import '../modules/provider_chats/views/provider_chats_view.dart';
import '../modules/provider_client_detail/bindings/provider_client_detail_binding.dart';
import '../modules/provider_client_detail/views/provider_client_detail_view.dart';
import '../modules/provider_history/bindings/provider_history_binding.dart';
import '../modules/provider_history/views/provider_history_view.dart';
import '../modules/provider_home/bindings/provider_home_binding.dart';
import '../modules/provider_home/views/provider_home_view.dart';
import '../modules/provider_my_profile/bindings/provider_my_profile_binding.dart';
import '../modules/provider_my_profile/views/provider_my_profile_view.dart';
import '../modules/provider_nav_bar/bindings/provider_nav_bar_binding.dart';
import '../modules/provider_nav_bar/views/provider_nav_bar_view.dart';
import '../modules/select_days/bindings/select_days_binding.dart';
import '../modules/select_days/views/select_days_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/signup_otp/bindings/signup_otp_binding.dart';
import '../modules/signup_otp/views/signup_otp_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/terms_condition/bindings/terms_condition_binding.dart';
import '../modules/terms_condition/views/terms_condition_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LET_GET_START,
      page: () => const LetGetStartView(),
      binding: LetGetStartBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.CHOOSE_ROLE,
      page: () => const ChooseRoleView(),
      binding: ChooseRoleBinding(),
    ),
    GetPage(
      name: _Paths.FORGET_PASSWORD,
      page: () => const ForgetPasswordView(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.FORGET_OTP,
      page: () => const ForgetOtpView(),
      binding: ForgetOtpBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP_OTP,
      page: () => const SignupOtpView(),
      binding: SignupOtpBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_NEW_PASSWORD,
      page: () => const CreateNewPasswordView(),
      binding: CreateNewPasswordBinding(),
    ),
    GetPage(
      name: _Paths.ADD_DETAILS,
      page: () => const AddDetailsView(),
      binding: AddDetailsBinding(),
    ),
    GetPage(
      name: _Paths.SELECT_DAYS,
      page: () => const SelectDaysView(),
      binding: SelectDaysBinding(),
    ),
    GetPage(
      name: _Paths.NAV_BAR,
      page: () => const NavBarView(),
      binding: NavBarBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.FAVORITE,
      page: () => const FavoriteView(),
      binding: FavoriteBinding(),
    ),
    GetPage(
      name: _Paths.APPOINTMENT,
      page: () => const AppointmentView(),
      binding: AppointmentBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.MY_PROFILE,
      page: () => const MyProfileView(),
      binding: MyProfileBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACY_POLICY,
      page: () => const PrivacyPolicyView(),
      binding: PrivacyPolicyBinding(),
    ),
    GetPage(
      name: _Paths.TERMS_CONDITION,
      page: () => const TermsConditionView(),
      binding: TermsConditionBinding(),
    ),
    GetPage(
      name: _Paths.CONTACT_US,
      page: () => const ContactUsView(),
      binding: ContactUsBinding(),
    ),
    GetPage(
      name: _Paths.PROVIDER_NAV_BAR,
      page: () => const ProviderNavBarView(),
      binding: ProviderNavBarBinding(),
    ),
    GetPage(
      name: _Paths.PROVIDER_HOME,
      page: () => const ProviderHomeView(),
      binding: ProviderHomeBinding(),
    ),
    GetPage(
      name: _Paths.PROVIDER_CHATS,
      page: () => const ProviderChatsView(),
      binding: ProviderChatsBinding(),
    ),
    GetPage(
      name: _Paths.PROVIDER_CLIENT_DETAIL,
      page: () => const ProviderClientDetailView(),
      binding: ProviderClientDetailBinding(),
    ),
    GetPage(
      name: _Paths.PROVIDER_HISTORY,
      page: () => const ProviderHistoryView(),
      binding: ProviderHistoryBinding(),
    ),
    GetPage(
      name: _Paths.PROVIDER_MY_PROFILE,
      page: () => const ProviderMyProfileView(),
      binding: ProviderMyProfileBinding(),
    ),
    GetPage(
      name: _Paths.ALL_MENTOR_LIST,
      page: () => const AllMentorListView(),
      binding: AllMentorListBinding(),
    ),
    GetPage(
      name: _Paths.MENTOR_DETAILS,
      page: () => const MentorDetailsView(),
      binding: MentorDetailsBinding(),
    ),
    GetPage(
      name: _Paths.BOOK_APPOINTMENT,
      page: () => const BookAppointmentView(),
      binding: BookAppointmentBinding(),
    ),
    GetPage(
      name: _Paths.SELECT_PACKAGE,
      page: () => const SelectPackageView(),
      binding: SelectPackageBinding(),
    ),
    GetPage(
      name: _Paths.PROVIDER_APPOINTMENT,
      page: () => const ProviderAppointmentView(),
      binding: ProviderAppointmentBinding(),
    ),
    GetPage(
      name: _Paths.BOOKING_SUCCESS,
      page: () => const BookingSuccessView(),
      binding: BookingSuccessBinding(),
    ),
    GetPage(
      name: _Paths.MENTOR_APPOINTMENT_DETAILS,
      page: () => const MentorAppointmentDetailsView(),
      binding: MentorAppointmentDetailsBinding(),
    ),
    GetPage(
      name: _Paths.MENTEE_APPOINTMENT_DETAILS,
      page: () => const MenteeAppointmentDetailsView(),
      binding: MenteeAppointmentDetailsBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_DAYS,
      page: () => const UpdateDaysView(),
      binding: UpdateDaysBinding(),
    ),
  ];
}
