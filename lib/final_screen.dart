import 'package:flutter/material.dart';
import 'package:mobius/quiz_progress.dart';
import 'package:mobius/standings.dart';
import 'package:provider/provider.dart';

class ResultWidget extends StatefulWidget {
  const ResultWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ResultWidgetState();
  }
}

class ResultWidgetState extends State<ResultWidget> {
  @override
  Widget build(BuildContext context) {
    final quizData = context.watch<QuizProgressData>();
    final standingsData = context.watch<StandingsData>();

    return Padding(
        padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
        child: Column(
          children: [
            const Text(
              "Ты прошел подготовку и отправился на собеседование!",
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF010123),
                  fontWeight: FontWeight.w500,
                  height: 1.5),
            ),
            Container(
              height: 9,
            ),
            const Text(
              "Спустя два часа...",
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF010123),
                  fontWeight: FontWeight.w500,
                  height: 1.5),
            ),
            Container(
              height: 16,
            ),
            const Divider(color: Color(0xFF010123)),
            Container(
              height: 16,
            ),
            buildResultTitle(quizData, standingsData),
            Container(
              height: 16,
            ),
            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        quizData.reset();
                      });
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            )),
                        backgroundColor:
                        MaterialStateProperty.all(const Color(0xFFD34484))),
                    child: const Padding(
                        padding: EdgeInsets.fromLTRB(80, 16, 80, 16),
                        child: Text(
                          'На главную',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ))),
              ],
            ),
            Container(
              height: 16,
            ),
          ],
        ));
  }

  Widget buildResultTitle(
      QuizProgressData quizData, StandingsData standingsData) {
    List<InlineSpan> textParts = [];

    TextStyle defaultStyle = const TextStyle(
        fontSize: 22,
        color: Color(0xFF010123),
        fontWeight: FontWeight.w500,
        height: 1.5);
    TextStyle highlightedStyle = const TextStyle(
        fontSize: 22,
        color: Color(0xFFD34484),
        fontWeight: FontWeight.w500,
        height: 1.5);

    textParts.add(TextSpan(text: "Поздравляю, ", style: defaultStyle));
    textParts.add(
        TextSpan(text: standingsData.currentPlayer, style: highlightedStyle));
    textParts.add(TextSpan(text: "! Ты набрал(-а) ", style: defaultStyle));
    textParts.add(TextSpan(
        text: quizData.calculateResult().toString(), style: highlightedStyle));
    textParts.add(TextSpan(text: " очков. ", style: defaultStyle));

    Result result = standingsData.currentResult;
    if (result.beforeScore < 0) {
      textParts
          .add(TextSpan(text: "На текущий момент это ", style: defaultStyle));
      textParts.add(
          TextSpan(text: result.place.toString(), style: highlightedStyle));
    } else if (result.score > result.beforeScore) {
      if (result.place > result.beforePlace) {
        textParts
            .add(TextSpan(text: "Ты улучшил(-а) свою позицию в рейтинге и теперь занимаешь ", style: defaultStyle));
        textParts.add(
            TextSpan(text: result.place.toString(), style: highlightedStyle));
      } else if (result.place == 1) {
        textParts
            .add(TextSpan(text: "Ты набрал(-а) больше очков и укрепил свое лидерство! Ты занимаешь ", style: defaultStyle));
        textParts.add(
            TextSpan(text: result.place.toString(), style: highlightedStyle));
      } else {
        textParts
            .add(TextSpan(text: "Ты набрал(-а) больше очков, но пока не смог подняться выше в рейтинге. Ты занимаешь ", style: defaultStyle));
        textParts.add(
            TextSpan(text: result.place.toString(), style: highlightedStyle));
      }
    } else {
      textParts
          .add(TextSpan(text: "Правда, это немного хуже твоего текущего результата. И ты все еще занимаешь ", style: defaultStyle));
      textParts.add(
          TextSpan(text: result.place.toString(), style: highlightedStyle));
    }
    textParts.add(TextSpan(text: " место!", style: defaultStyle));

    return RichText(text: TextSpan(children: textParts));
  }
}
