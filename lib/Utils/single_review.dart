import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoot/Constants/Colors.dart';
import 'package:hoot/Constants/loaders.dart';
import 'package:hoot/Screens/home_page.dart';
import 'package:http/http.dart' as http;

class SingleReview extends StatefulWidget {
  final String setid;
  const SingleReview({super.key, required this.setid});

  @override
  State<SingleReview> createState() => _SingleReviewState();
}

class _SingleReviewState extends State<SingleReview> {
  Map<String, dynamic> cardData = {};
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.logoGreen,
        centerTitle: true,
        title: const Text(
          'Short Answer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isCompleted ? yesData(context) : noData(),
    );
  }

  Widget noData() {
    return Loaders.circleLottieLoader();
  }

  Widget yesData(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //CONTAINER

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFDF8FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.logoGreen,
                  width: 1,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 3.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 170,
                        child: Image.asset('assets/mic_bg.png'),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Submitted Successfully',
                        style: TextStyle(
                          fontSize: 24,
                          color: AppColors.logoGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Check out the report below, so that it will\nhelp to improve your performance',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildProgressBar('Accuracy',
                          cardData["accuracy"].toDouble(), AppColors.logoGreen),
                      const SizedBox(height: 16),
                      _buildProgressBar(
                          'Vocabulary',
                          cardData["vocabulary"].toDouble(),
                          AppColors.logoLightGreen),
                      const SizedBox(height: 20),
                      //SMALL BOX
                      // Container(
                      //   padding: const EdgeInsets.all(20),
                      //   decoration: BoxDecoration(
                      //       color: AppColors.lighterShade.withOpacity(0.10),
                      //       borderRadius: BorderRadius.circular(12),
                      //       border:
                      //           Border.all(color: AppColors.greyForReview)),
                      //   child: Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment:
                      //             MainAxisAlignment.spaceAround,
                      //         children: [
                      //           _buildMetric(
                      //               'Spellings', '12', AppColors.logoGreen),
                      //           _buildMetric(
                      //               'Words', '7', AppColors.yellowForReview),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          //BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.logoGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                elevation: 3,
                // minimumSize: const Size(40, 55),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: Text(
                  'Home',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //PROGRESS BAR
  Widget _buildProgressBar(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '$label ',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              // Spacer(),
              Align(
                alignment: Alignment.center,
                child: Text(
                  '${value.toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  //METRICS
  // ignore: unused_element
  Widget _buildMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 14, color: Colors.black, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          value.padLeft(2, '0'),
          style: TextStyle(
            fontSize: 20,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  //GETTIING USER DATA
  getUserData() async {
    String url =
        'http://node.technicalhub.io:4001/api/shortanswer-all-submissions';
    final response =
        await http.post(Uri.parse(url), body: {"roll_no": "22A86A6720"});
    final List<dynamic> body = jsonDecode(response.body);
    for (int i = 0; i < body.length; i++) {
      if (body[i]["set_id"] == widget.setid) {
        setState(() {
          cardData = body[i];
          debugPrint(cardData.toString());
          isCompleted = true;
        });
      }
    }
  }
}
