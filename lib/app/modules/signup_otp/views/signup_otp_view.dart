import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/signup_otp_controller.dart';

class SignupOtpView extends GetView<SignupOtpController> {
  const SignupOtpView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignupOtpView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SignupOtpView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
