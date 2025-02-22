import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoot/Constants/Colors.dart';
import 'package:hoot/Screens/Hoot/STT_TESTING.dart';
import 'package:hoot/Screens/shortanswer_android.dart';
import 'package:hoot/Screens/shortanswer_ios.dart';
import 'package:hoot/Utils/cardstuff.dart';
import 'package:hoot/Utils/review_page.dart';
import 'package:hoot/Utils/single_review.dart';
import 'package:hoot/Widgets/button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOOT"),
        centerTitle: true,
        backgroundColor: AppColors.logoGreen,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 30,
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Platform.isIOS
                            ? const ShortAnswerIOS()
                            : const ShortAnswerAndroid(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.question_answer,
                    size: 30,
                  )),
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReviewPage()),
                );
              },
              icon: const Icon(Icons.text_snippet)),
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SingleReview(
                            setid: '6704f70dea925e66fe066b30',
                          )),
                );
              },
              icon: const Icon(Icons.screen_lock_landscape)),
          BestUIButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CardSuff()),
                );
              },
              label: 'Card')
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.surround_sound_outlined),
          onPressed: () {
            Get.to(() => const MyTTSTesting());
          }),
    );
  }
}
