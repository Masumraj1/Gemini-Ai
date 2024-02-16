import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {


  ChatUser myself = ChatUser(id: "1", firstName: "Masum");
  ChatUser bot = ChatUser(id: "2", firstName: "Gemini");
  List<ChatMessage> allMessages = [];

  final ourUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyBLsn0DQWghHd1JWCSCBllvoTZULOEyplI";

  final header = {'Content-Type': 'application/json'};

  getData(ChatMessage m) async {
    try {
      allMessages.insert(0, m);
      setState(() {});
      var data = {
        "contents": [
          {
            "parts": [
              {"text": m.text}
            ]
          }
        ]
      };
      await http
          .post(Uri.parse(ourUrl), headers: header, body: jsonEncode(data))
          .then((value) {
        if (value.statusCode == 200) {
          var result = jsonDecode(value.body);
          print(result['candidates'][0]["content"]['parts'][0]['text']);

          ChatMessage m1 = ChatMessage(
              text: result['candidates'][0]["content"]['parts'][0]['text'],
              user: bot, createdAt: DateTime.now());
          allMessages.insert(0, m1);
          setState(() {

          });
        } else {
          print("Error occured");
        }
      })
          .catchError((e) {
        print(
            "======================This is big error========================================$e");
      });
    }catch (e){
      print("============================This is error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashChat(
          currentUser: myself,
          onSend: (ChatMessage m) {
            getData(m);
          },
          messages: allMessages),
    );
  }
}
