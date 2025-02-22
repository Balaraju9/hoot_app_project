import 'dart:convert';
import 'package:hoot/Constants/loaders.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hoot/Constants/Colors.dart';
import 'dart:math' as math;

var headingStyle = TextStyle(color: AppColors.logoGreen, fontSize: 15);
var textingStyle = const TextStyle(color: Colors.black, fontSize: 10);
var reviewQuestionStyle =
    const TextStyle(fontWeight: FontWeight.w700, color: Colors.black);
var reviewAnswerStyle = TextStyle(color: AppColors.logoGreen);
var reviewAnswerStyle2 = const TextStyle(color: Colors.red);

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<dynamic> allData = [];
  late List<bool> isExpandedList;
  late List<bool> isReviewList;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  initializeData() async {
    await getUserData();
    isExpandedList = List<bool>.filled(allData.length, false);
    // isReviewList = List<bool>.filled(allData.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: AppBar(
        backgroundColor: AppColors.logoGreen,
        title: const Text(
          'Questionnaire',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading ? noData() : yesData(),
    );
  }

  Widget noData() {
    return Loaders.circleLottieLoader();
  }

  Widget yesData() {
    return SizedBox(
      child: ListView.builder(
          itemCount: allData.length,
          itemBuilder: (context, index) {
            final indexData = allData[index];
            return _buildCard(index, indexData);
          }),
    );
  }

  //Card builder
  Widget _buildCard(int index, dynamic indexData) {
    bool isExpanded = isExpandedList[index];
    // bool isReview = isReviewList[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFFECECEC),
            border: Border.all(color: Colors.grey),
            boxShadow: getBoxShadow()),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 13, right: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    indexData['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(' ${indexData['date']}'),
                  Row(
                    children: [
                      Text(indexData['set_id']),
                      // TextButton(
                      // onPressed: () {
                      //   setState(() {
                      //     isReviewList[index] = !isReviewList[index];
                      //     isExpandedList[index] = false;
                      //   });
                      // },
                      // child: Text(
                      //   'Review',
                      //   style: TextStyle(
                      //       color: AppColors.logoGreen,
                      //       fontWeight: FontWeight.bold),
                      // )),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            // isReviewList[index] = false;
                            isExpandedList[index] = !isExpandedList[index];
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              'Statistics',
                              style: TextStyle(
                                  color: AppColors.yellowForReview,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              isExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: AppColors.yellowForReview,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isExpanded) _buildInfo(indexData),
            // if (isReview) _buildReview(indexData[1]),
          ],
        ),
      ),
    );
  }

  //Statistics builder
  Widget _buildInfo(dynamic indexData) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 10, bottom: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomPaint(
            size: const Size(180, 180),
            painter: CustomCircularPainter(
                accuracy: (indexData['accuracy'] ?? 0).toDouble(),
                fluency: (indexData['fluency'] ?? 0).toDouble()),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStat(AppColors.logoGreen, 'Accuracy',
                  '${indexData['accuracy']?.toStringAsFixed(1) ?? 0}%'),
              _buildStat(AppColors.yellowForReview, 'Vocabulary',
                  '${indexData['vocabulary']?.toStringAsFixed(1) ?? 0}%'),
              _buildStat(null, 'Fluency',
                  '${indexData['fluency']?.toStringAsFixed(1) ?? 0}%'),
              // _buildStat(null, 'Grammar',
              //     '${indexData[2]['grammar']?.toStringAsFixed(1) ?? 0}%'),
            ],
          )
        ],
      ),
    );
  }

  //Stat Details
  Widget _buildStat(Color? color, String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: (color != null) ? color : const Color(0xFFECECEC),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: (color != null) ? color : AppColors.logoGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

//---------------------
//GETTIING USER DATA
  getUserData() async {
    String url =
        'http://node.technicalhub.io:4001/api/shortanswer-all-submissions';
    final response =
        await http.post(Uri.parse(url), body: {"roll_no": "22A86A6720"});
    final List<dynamic> body = jsonDecode(response.body);
    debugPrint(body.toString());
    setState(() {
      isLoading = false;
      allData = body;
    });
  }
}
//---------------------------

//Statistics Painter
class CustomCircularPainter extends CustomPainter {
  double accuracy;
  double fluency;
  CustomCircularPainter({required this.accuracy, required this.fluency});
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.width / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    //circles
    paint.color = AppColors.greyForReview;
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center, radius * 0.6, paint);

    //Draw progress arcs
    final rect = Rect.fromCircle(center: center, radius: radius);
    final smallerRect = Rect.fromCircle(center: center, radius: radius * 0.6);

    // Accuracy arc (outer)
    paint.color = AppColors.logoGreen;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * (accuracy / 100),
      false,
      paint,
    );

    // Fluency arc (inner)
    paint.color = AppColors.logoYellow;
    canvas.drawArc(
      smallerRect,
      -math.pi / 2,
      2 * math.pi * (fluency / 100),
      false,
      paint,
    );

    //Draw center text
    final textpainter = TextPainter(
      text: TextSpan(children: [
        TextSpan(
            text: '${fluency.toStringAsFixed(1)}\n',
            style: TextStyle(
                color: AppColors.logoGreen,
                fontWeight: FontWeight.w800,
                fontSize: 20)),
        const TextSpan(
            text: 'Fluency',
            style: TextStyle(color: Colors.black, fontSize: 18))
      ]),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textpainter.layout();
    textpainter.paint(
      canvas,
      center - Offset(textpainter.width / 2, textpainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

//Box Shadow Widget
List<BoxShadow> getBoxShadow() {
  return [
    const BoxShadow(
      color: Colors.grey,
      offset: Offset(0.0, 2.0),
      blurRadius: 5.0,
      spreadRadius: 2.0,
    ),
  ];
}
