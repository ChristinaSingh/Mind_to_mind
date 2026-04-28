import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../common/common_widgets.dart';
import '../../../../common/local_data.dart';
import '../../../data/apis/api_constants/api_key_constants.dart';
import '../../../data/apis/api_methods/api_methods.dart';
import '../../../data/apis/api_models/book_appointment_model.dart';
import '../../../data/apis/api_models/package_model.dart';
import '../../../routes/app_pages.dart';

class SelectPackageController extends GetxController {
  String? selectedPackage = 'Messaging';
  PackageResult? packageResult;
  BookAppointmentResult? bookAppointmentResult;

  final count = 0.obs;
  final isPageLoading = true.obs;
  final isApiLoading = false.obs;

  Map<String, dynamic>? paymentIntent;
  Map<String, String?> parameter = Get.parameters;

  @override
  void onInit() {
    super.onInit();
    getPackageRate();
  }

  @override
  void onReady() => super.onReady();

  @override
  void onClose() => super.onClose();

  void increment() => count.value++;

  // ✅ Get start_time and end_time from parameters
  String get startTime => parameter['start_time'] ?? '';
  String get endTime => parameter['end_time'] ?? '';
  int get durationMinutes => int.tryParse(parameter['duration'] ?? '30') ?? 30;

  // ✅ Duration in hours (decimal) e.g. 90 min = 1.5
  double get durationHours => durationMinutes / 60.0;

  // ✅ Formatted duration string e.g. "1h 30m" or "30m"
  String get formattedDuration {
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;
    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }

  String getOnlyNumbers(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  // ✅ Base rate per 30 min slot (from API)
  double _baseRateFor(String? package) {
    if (packageResult == null) return 0;
    String raw;
    switch (package) {
      case 'Messaging':
        raw = packageResult!.messageRate ?? '0';
        break;
      case 'Voice call':
        raw = packageResult!.audioRate ?? '0';
        break;
      case 'Video call':
        raw = packageResult!.videoRate ?? '0';
        break;
      default:
        raw = '0';
    }
    return double.tryParse(getOnlyNumbers(raw)) ?? 0;
  }

  // ✅ Total price = base rate × (duration / 30 min slots)
  // API rate is per 30-min slot
  double _calculatePrice(String? package) {
    final baseRate = _baseRateFor(package);
    final slots = durationMinutes / 30.0; // e.g. 90 min = 3 slots
    return baseRate * slots;
  }

  // ✅ Formatted price for display e.g. "$15.00"
  String formattedPrice(String? package) {
    final price = _calculatePrice(package);
    return price == price.roundToDouble()
        ? '\$${price.toInt()}'
        : '\$${price.toStringAsFixed(2)}';
  }

  // ✅ Selected package total amount as string (for payment)
  String get selectedAmount {
    return _calculatePrice(selectedPackage).toInt().toString();
  }

  getPackageRate() async {
    isPageLoading.value = true;
    Map<String, dynamic> bodyParameter = {
      'user_id': parameter[ApiKeyConstants.mentorId] ?? '',
    };
    PackageModel? packageModel =
        await ApiMethods.getPackageApi(bodyParams: bodyParameter);
    if (packageModel != null && packageModel.status == '1') {
      packageResult = packageModel.result;
    } else {
      CommonWidgets.showMyToastMessage('Failed to load packages');
    }
    isPageLoading.value = false;
    increment();
  }

  void clickOnNext() async {
    if (isApiLoading.value) return;
    await makePayment();
  }

  Future<void> bookAppointment(String amount, String paymentId) async {
    Map<String, dynamic> bodyParam = {
      "user_id": LocalData.userId,
      "mentor_id": parameter[ApiKeyConstants.mentorId] ?? '',
      "appointment_date": parameter[ApiKeyConstants.appointment_date] ?? '',
      // ✅ Use start_time and end_time instead of single time
      "start_time": startTime,
      "end_time": endTime,
      //  "duration": durationMinutes.toString(),
      "package_id": selectedPackage,
      "amount": amount,
      "payment_id": paymentId,
      "payment_status": "paid",
    };

    BookAppointmentModel? bookAppointmentModel =
        await ApiMethods.bookAppointmentApi(bodyParams: bodyParam);

    if (bookAppointmentModel != null && bookAppointmentModel.status == '1') {
      bookAppointmentResult = bookAppointmentModel.result!;
      Map<String, String> data = {
        ApiKeyConstants.appointmentId: bookAppointmentResult?.id ?? "",
      };
      Get.toNamed(Routes.BOOKING_SUCCESS, parameters: data);
      CommonWidgets.showMyToastMessage(
          bookAppointmentModel.message ?? 'Appointment booked successfully!');
    } else {
      CommonWidgets.showMyToastMessage(
          bookAppointmentModel?.message ?? 'Book appointment failed.');
    }
    increment();
  }

  Future<void> makePayment() async {
    try {
      isApiLoading.value = true;
      paymentIntent = await createPaymentIntent(selectedAmount, 'AUD');
      if (paymentIntent == null) {
        isApiLoading.value = false;
        return;
      }
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          googlePay: const PaymentSheetGooglePay(
            testEnv: true,
            currencyCode: "AUD",
            merchantCountryCode: "AU",
          ),
          merchantDisplayName: 'Flutterwings',
        ),
      );
      await displayPaymentSheet();
    } catch (e) {
      print("makePayment exception: $e");
      CommonWidgets.showMyToastMessage('Payment initialization failed.');
    } finally {
      isApiLoading.value = false;
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text("Paid successfully")),
      );
      await getPaymentIntentDetails(paymentIntent!['id']);
      paymentIntent = null;
    } on StripeException catch (e) {
      print('Stripe error: $e');
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text("Payment Cancelled")),
      );
    } catch (e) {
      print("displayPaymentSheet error: $e");
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency) async {
    try {
      int amountInCents = (int.parse(amount.isEmpty ? '0' : amount)) * 100;
      Map<String, dynamic> body = {
        'amount': amountInCents.toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      const secretKey = String.fromEnvironment('STRIPE_SECRET_KEY');
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      return jsonDecode(response.body);
    } catch (err) {
      print('createPaymentIntent error: $err');
      return null;
    }
  }

  Future<void> getPaymentIntentDetails(String paymentIntentId) async {
    try {
      const secretKey = String.fromEnvironment('STRIPE_SECRET_KEY');
      var response = await http.get(
        Uri.parse('https://api.stripe.com/v1/payment_intents/$paymentIntentId'),
        headers: {'Authorization': 'Bearer $secretKey'},
      );
      var details = jsonDecode(response.body);
      if (details != null && details['id'] != null) {
        String paymentId = details['id'];
        String paidAmount =
            '${((details['amount_received'] ?? 0) / 100).toStringAsFixed(2)}';
        await bookAppointment(paidAmount, paymentId);
      }
    } catch (e) {
      print('getPaymentIntentDetails error: $e');
    }
  }
}
