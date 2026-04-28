// import 'package:agora_chat_sdk/agora_chat_sdk.dart';
// import 'package:flutter/material.dart';
//
// final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
//     GlobalKey<ScaffoldMessengerState>();
//
// class Chat1Screen extends StatefulWidget {
//   const Chat1Screen({super.key});
//
//   @override
//   State<Chat1Screen> createState() => _Chat1ScreenState();
// }
//
// class _Chat1ScreenState extends State<Chat1Screen> {
//   static const String appKey = "411255326#1447492";
//   static const String userId = "abc123456";
//   String token =
//       "007eJxTYJho4NYmEs32cgvvj7bvKQ83v2o1Vz+zxtosR5tbivtB1E8FBnOLFIOUlCSLlEQjM5PUFDNLY0tTU0uLROPkJONkc+OUKLeIdAE+Bob5+uHMjAysDIxACOJzMiQmJRsaGZuYmgEAOVEdOw==";
//   late ChatClient agoraChatClient;
//   bool isJoined = false;
//
//   ScrollController scrollController = ScrollController();
//   TextEditingController messageBoxController = TextEditingController();
//   String messageContent = "", recipientId = "";
//   final List<Widget> messageList = [];
//
//   showLog(String message) {
//     scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
//       content: Text(message),
//     ));
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     setupChatClient();
//     setupListeners();
//   }
//
//   void setupChatClient() async {
//     ChatOptions options = ChatOptions(
//       appKey: appKey,
//       autoLogin: false,
//     );
//     agoraChatClient = ChatClient.getInstance;
//     await agoraChatClient.init(options);
// // Notify the SDK that the Ul is ready. After the following method is executed, callbacks within ChatRoomEventHandler and ChatGroupEventHandler can be triggered.
//     await ChatClient.getInstance.startCallback();
//   }
//
//   void setupListeners() {
//     agoraChatClient.addConnectionEventHandler(
//       "CONNECTION_HANDLER",
//       ConnectionEventHandler(
//           onConnected: onConnected,
//           onDisconnected: onDisconnected,
//           onTokenWillExpire: onTokenWillExpire,
//           onTokenDidExpire: onTokenDidExpire),
//     );
//
//     agoraChatClient.chatManager.addEventHandler(
//       "MESSAGE_HANDLER",
//       ChatEventHandler(onMessagesReceived: onMessagesReceived),
//     );
//   }
//
//   void onMessagesReceived(List<ChatMessage> messages) {
//     for (var msg in messages) {
//       if (msg.body.type == MessageType.TXT) {
//         ChatTextMessageBody body = msg.body as ChatTextMessageBody;
//         displayMessage(body.content, false);
//         showLog("Message from ${msg.from}");
//       } else {
//         String msgType = msg.body.type.name;
//         showLog("Received $msgType message, from ${msg.from}");
//       }
//     }
//   }
//
//   void onTokenWillExpire() {
//     // The token is about to expire. Get a new token
//     // from the token server and renew the token.
//   }
//
//   void onTokenDidExpire() {
//     // The token has expired
//   }
//
//   void onDisconnected() {
//     // Disconnected from the Chat server
//   }
//
//   void onConnected() {
//     showLog("Connected");
//   }
//
//   void joinLeave() async {
//     if (!isJoined) {
//       // Log in
//       try {
//         await agoraChatClient.loginWithAgoraToken(userId, token);
//         showLog("Logged in successfully as $userId");
//         setState(() {
//           isJoined = true;
//         });
//       } on ChatError catch (e) {
//         if (e.code == 200) {
//           // Already logged in
//           setState(() {
//             isJoined = true;
//           });
//         } else {
//           showLog("Login failed, code: ${e.code}, desc: ${e.description}");
//         }
//       }
//     } else {
//       // Log out
//       try {
//         await agoraChatClient.logout(true);
//         showLog("Logged out successfully");
//         setState(() {
//           isJoined = false;
//         });
//       } on ChatError catch (e) {
//         showLog("Logout failed, code: ${e.code}, desc: ${e.description}");
//       }
//     }
//   }
//
//   void sendMessage() async {
//     if (recipientId.isEmpty || messageContent.isEmpty) {
//       showLog("Enter recipient user ID and type a message");
//       return;
//     }
//
//     var msg = ChatMessage.createTxtSendMessage(
//       targetId: recipientId,
//       content: messageContent,
//     );
//     ChatClient.getInstance.chatManager.addMessageEvent(
//       "UNIQUE_HANDLER_ID",
//       ChatMessageEvent(
//         onSuccess: (msgId, msg) {
//           print("on message succeed");
//         },
//         onProgress: (msgId, progress) {
//           print("on message progress");
//         },
//         onError: (msgId, msg, error) {
//           print(
//             "on message failed, code: ${error.code}, desc: ${error.description}",
//           );
//         },
//       ),
//     );
//     ChatClient.getInstance.chatManager.removeMessageEvent("UNIQUE_HANDLER_ID");
//     agoraChatClient.chatManager.sendMessage(msg);
//   }
//
//   void displayMessage(String text, bool isSentMessage) {
//     messageList.add(Row(children: [
//       Expanded(
//         child: Align(
//           alignment:
//               isSentMessage ? Alignment.centerRight : Alignment.centerLeft,
//           child: Container(
//             padding: const EdgeInsets.all(10),
//             margin: EdgeInsets.fromLTRB(
//                 (isSentMessage ? 50 : 0), 5, (isSentMessage ? 0 : 50), 5),
//             decoration: BoxDecoration(
//               color: isSentMessage
//                   ? const Color(0xFFDCF8C6)
//                   : const Color(0xFFFFFFFF),
//             ),
//             child: Text(text),
//           ),
//         ),
//       ),
//     ]));
//
//     setState(() {
//       scrollController.jumpTo(scrollController.position.maxScrollExtent + 50);
//     });
//   }
//
//   @override
//   void dispose() {
//     agoraChatClient.chatManager.removeEventHandler("MESSAGE_HANDLER");
//     agoraChatClient.removeConnectionEventHandler("CONNECTION_HANDLER");
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Chat"),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: SizedBox(
//                     height: 40,
//                     child: TextField(
//                       decoration: const InputDecoration(
//                         filled: true,
//                         fillColor: Colors.white,
//                         hintText: "Enter recipient's userId",
//                       ),
//                       onChanged: (chatUserId) => recipientId = chatUserId,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 SizedBox(
//                   width: 80,
//                   height: 40,
//                   child: ElevatedButton(
//                     onPressed: joinLeave,
//                     child: Text(isJoined ? "Leave" : "Join"),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 controller: scrollController,
//                 itemBuilder: (_, index) {
//                   return messageList[index];
//                 },
//                 itemCount: messageList.length,
//               ),
//             ),
//             Row(children: [
//               Expanded(
//                 child: SizedBox(
//                   height: 40,
//                   child: TextField(
//                     controller: messageBoxController,
//                     decoration: const InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       hintText: "Message",
//                     ),
//                     onChanged: (msg) => messageContent = msg,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               SizedBox(
//                 width: 50,
//                 height: 40,
//                 child: ElevatedButton(
//                   onPressed: sendMessage,
//                   child: const Text(">>"),
//                 ),
//               ),
//             ]),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/local_data.dart';
import '../data/apis/api_models/get_appointmentlist_model.dart';

class Chat1Screen extends StatefulWidget {

  final GetAppointmentListResult appointmentListResult;
  final String token;
  final String receiverId;

  const Chat1Screen(      {super.key,
    required this.appointmentListResult,
    required this.token,
    required this.receiverId});


  @override
  State<Chat1Screen> createState() => _Chat1ScreenState();
}

class _Chat1ScreenState extends State<Chat1Screen> {
  late AgoraRtmClient _rtmClient;

  final String _appId =
      "78d0ddb8da264ed69395598a3cb3c73d"; // Replace with your Agora App ID
  final String _userId = LocalData.userId; //
  ScrollController scrollController = ScrollController();
  String? _messageContent, _chatId;
  final List<String> _logText = [];

  @override
  void initState() {
    super.initState();
    _initSDK();
    _addChatListener();
  }

  @override
  void dispose() {
    ChatClient.getInstance.chatManager.removeEventHandler('78d0ddb8da264ed69395598a3cb3c73d');
    ChatClient.getInstance.chatManager.removeMessageEvent('78d0ddb8da264ed69395598a3cb3c73d');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("chat"),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10),
             Text("login userId: ${widget.receiverId}"),
             Text("agoraToken: ${widget.token}"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: _signIn,
                    child: const Text("SIGN IN"),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                      MaterialStateProperty.all(Colors.lightBlue),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    onPressed: _signOut,
                    child: const Text("SIGN OUT"),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                      MaterialStateProperty.all(Colors.lightBlue),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter recipient's userId",
              ),
              onChanged: (chatId) => _chatId = chatId,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter message",
              ),
              onChanged: (msg) => _messageContent = msg,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _sendMessage,
              child: const Text("SEND TEXT"),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
              ),
            ),
            Flexible(
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (_, index) {
                  return Text(_logText[index]);
                },
                itemCount: _logText.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _initSDK() async {
    ChatOptions options = ChatOptions(
      appKey: "78d0ddb8da264ed69395598a3cb3c73d",
      autoLogin: false,
    );
    await ChatClient.getInstance.init(options);
  }

  void _addChatListener() {
    ChatClient.getInstance.chatManager.addEventHandler(
      'UNIQUE_HANDLER_ID',
      ChatEventHandler(onMessagesReceived: onMessagesReceived),
    );

    ChatClient.getInstance.chatManager.addMessageEvent(
      'UNIQUE_HANDLER_ID',
      ChatMessageEvent(
        onSuccess: (msgId, msg) {
          _addLogToConsole("send message: $_messageContent");
        },
        onError: (msgId, msg, error) {
          _addLogToConsole(
            "send message failed, code: ${error.code}, desc: ${error.description}",
          );
        },
      ),
    );
  }

  void _signIn() async {
    try {
      await ChatClient.getInstance.loginWithToken(
        _userId,
        widget.token,
      );
      _addLogToConsole("login succeed, userId: ${_userId}");
    } on ChatError catch (e) {
      _addLogToConsole("login failed, code: ${e.code}, desc: ${e.description}");
    }
  }

  void _signOut() async {
    try {
      await ChatClient.getInstance.logout(true);
      _addLogToConsole("sign out succeed");
    } on ChatError catch (e) {
      _addLogToConsole(
          "sign out failed, code: ${e.code}, desc: ${e.description}");
    }
  }

  void _sendMessage() async {
    if (_chatId == null || _messageContent == null) {
      _addLogToConsole("single chat id or message content is null");
      return;
    }

    var msg = ChatMessage.createTxtSendMessage(
      targetId: _chatId!,
      content: _messageContent!,
    );

    ChatClient.getInstance.chatManager.sendMessage(msg);
  }

  void onMessagesReceived(List<ChatMessage> messages) {
    for (var msg in messages) {
      switch (msg.body.type) {
        case MessageType.TXT:
          {
            ChatTextMessageBody body = msg.body as ChatTextMessageBody;
            _addLogToConsole(
              "receive text message: ${body.content}, from: ${msg.from}",
            );
          }
          break;
        case MessageType.IMAGE:
          {
            _addLogToConsole(
              "receive image message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.VIDEO:
          {
            _addLogToConsole(
              "receive video message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.LOCATION:
          {
            _addLogToConsole(
              "receive location message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.VOICE:
          {
            _addLogToConsole(
              "receive voice message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.FILE:
          {
            _addLogToConsole(
              "receive image message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.CUSTOM:
          {
            _addLogToConsole(
              "receive custom message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.CMD:
          {}
          break;
        case MessageType.COMBINE:
          _addLogToConsole(
            "receive combine message, from: ${msg.from}",
          );
      }
    }
  }

  void _addLogToConsole(String log) {
    _logText.add(_timeString + ": " + log);
    setState(() {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  String get _timeString {
    return DateTime.now().toString().split(".").first;
  }
}