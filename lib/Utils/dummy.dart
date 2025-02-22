//speech to text(User Speaking)

// listen() async {
//   if (!_speechEnabled) {
//     bool available = await _speechToText.initialize();
//     if (available) {
//       setState(() {
//         _speechEnabled = true;
//         // second_container_list[currentquestion - 1] = '';
//       });
//       _speechToText.listen(onResult: (result) {
//         setState(() {
//           second_container_list[currentquestion - 1] = result.recognizedWords;
//         });
//         if (result.finalResult && _timerSecond_container == 0) {
//           setState(() {
//             second_container_list[currentquestion - 1] =
//                 result.recognizedWords;
//             _speechToText.stop();
//           });
//         }
//       });
//     }
//   } else {
//     setState(() {
//       _speechEnabled = false;
//       _speechToText.stop();
//     });
//   }
// }

//DUMMY DATA
class DummyData {
  List<String> speechQuestion = [
    "Which animal is known as the 'Ship of the Desert'?",
    "How many days are there in a week?",
    "How many hours are there in a day?",
    "How many letters are there in the English alphabet?",
    "Rainbow consists of how many colours?",
    "How many minutes are there in an hour?",
    "How many vowels are there in the English alphabet and name them?",
    "Which animal is known as the king of the jungle?",
    "Name the National bird of India?",
    "What is the capital of India?"
  ];
}

class Dummy2 {
  List<dynamic> attempts = [
    [
      {'date': '2024-10-09'}, //
      [
        {
          'Q': 'Would you store food in a refrigerator or a suitcase?',
          'A': 'A refrigerator',
          'G': 'A suitcase'
        },
        {
          'Q': 'Would you store food in a refrigerator or a suitcase?',
          'A': 'A refrigerator',
          'G': 'A suitcase'
        },
        {
          'Q': 'Would you store food in a refrigerator or a suitcase?',
          'A': 'A refrigerator',
          'G': 'A suitcase'
        },
      ],
      {'accuracy': 60.0, 'vocabulary': 75.0, 'fluency': 90.0, 'grammar': 85.0},
    ],
  ];
}



/*
Padding(
      padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${index + 1}. ', style: reviewQuestionStyle),
            Expanded(
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Given Question\n',
                    style: reviewQuestionStyle,
                  ),
                  TextSpan(text: '${mapData['Q']}\n', style: reviewAnswerStyle),
                  TextSpan(
                      text: 'Correct Answer\n', style: reviewQuestionStyle),
                  TextSpan(text: '${mapData['A']}\n', style: reviewAnswerStyle),
                  TextSpan(text: 'Given Answer\n', style: reviewQuestionStyle),
                  TextSpan(
                      text: '${mapData['G']}\n', style: reviewAnswerStyle2),
                ]),
              ),
            ),
          ],
        )
      ]),
    );

    */




  // Widget _buildReview(List<dynamic> questionAnswerList) {
  //   return Container(
  //     height: questionAnswerList.length * 135,
  //     child: ListView.builder(
  //         itemCount: questionAnswerList.length,
  //         itemBuilder: (context, index) {
  //           return Padding(
  //             padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
  //             child: Column(mainAxisSize: MainAxisSize.min, children: [
  //               Row(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text('${index + 1}. ', style: reviewQuestionStyle),
  //                   Expanded(
  //                     child: RichText(
  //                       text: TextSpan(children: [
  //                         TextSpan(
  //                           text: 'Given Question\n',
  //                           style: reviewQuestionStyle,
  //                         ),
  //                         TextSpan(
  //                             text: '${questionAnswerList[index]['Q']}\n',
  //                             style: reviewAnswerStyle),
  //                         TextSpan(
  //                             text: 'Correct Answer\n',
  //                             style: reviewQuestionStyle),
  //                         TextSpan(
  //                             text: '${questionAnswerList[index]['A']}\n',
  //                             style: reviewAnswerStyle),
  //                         TextSpan(
  //                             text: 'Given Answer\n',
  //                             style: reviewQuestionStyle),
  //                         TextSpan(
  //                             text: '${questionAnswerList[index]['G']}',
  //                             style: reviewAnswerStyle2),
  //                       ]),
  //                     ),
  //                   ),
  //                 ],
  //               )
  //             ]),
  //           );
  //         }),
  //   );
  // }


//Review builder - NOT USED
  // Widget _buildReview(List<dynamic> questionAnswerList) {
  //   return SingleChildScrollView(
  //     child: Padding(
  //       padding: const EdgeInsets.only(bottom: 10),
  //       child: Column(
  //         children: List.generate(questionAnswerList.length, (index) {
  //           return Padding(
  //             padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
  //             child: Column(mainAxisSize: MainAxisSize.min, children: [
  //               Row(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text('${index + 1}. ',
  //                       style: const TextStyle(
  //                           fontSize: 10, fontWeight: FontWeight.w800)),
  //                   Expanded(
  //                     child: RichText(
  //                       text: TextSpan(children: [
  //                         // TextSpan(
  //                         //   text: '${index + 1}. ',
  //                         //   style: reviewQuestionStyle,
  //                         // ),
  //                         TextSpan(
  //                           text: 'Given Question\n',
  //                           style: reviewQuestionStyle,
  //                         ),
  //                         TextSpan(
  //                             text: '${questionAnswerList[index]['Q']}\n',
  //                             style: reviewAnswerStyle),
  //                         TextSpan(
  //                             text: 'Correct Answer\n',
  //                             style: reviewQuestionStyle),
  //                         TextSpan(
  //                             text: '${questionAnswerList[index]['A']}\n',
  //                             style: reviewAnswerStyle),
  //                         TextSpan(
  //                             text: 'Given Answer\n',
  //                             style: reviewQuestionStyle),
  //                         TextSpan(
  //                             text: '${questionAnswerList[index]['G']}',
  //                             style: reviewAnswerStyle2),
  //                       ]),
  //                     ),
  //                   ),
  //                 ],
  //               )
  //             ]),
  //           );
  //         }),
  //       ),
  //     ),
  //   );
  // }


  // void addToGlobal(List<String> questions, List<String> correctAnswers,
  //     List<String> myAnswers) {
  //   String currentDate = DateTime.now().toString().split(' ').first;
  //   Map<String, dynamic> dateMap = {'date': currentDate};
  //   List<Map<String, dynamic>> quesAnsList = [];
  //   for (int i = 0; i < questions.length; i++) {
  //     quesAnsList.add({
  //       'Q': questions[i],
  //       'A': correctAnswers[i],
  //       'G': myAnswers[i],
  //     });
  //   }
  //   Map<String, double> accuracyMap = {
  //     'accuracy': getRandomValue(),
  //     'vocabulary': getRandomValue(),
  //     'fluency': getRandomValue(),
  //     'grammar': getRandomValue(),
  //   };
  //   List<dynamic> newAttempt = [dateMap, quesAnsList, accuracyMap];
  //   globalAttempts.add(newAttempt);
  // }
