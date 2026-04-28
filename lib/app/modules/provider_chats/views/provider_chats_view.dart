import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/provider_chats_controller.dart';

class ProviderChatsView extends GetView<ProviderChatsController> {
  const ProviderChatsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Mentor ChatsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Mentor ChatsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
