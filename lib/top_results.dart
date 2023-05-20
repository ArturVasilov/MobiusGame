import 'package:flutter/material.dart';
import 'package:mobius/standings.dart';
import 'package:provider/provider.dart';

class TopResultsWidget extends StatefulWidget {

  const TopResultsWidget({Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TopResultsWidgetState();
  }
}

class TopResultsWidgetState extends State<TopResultsWidget> {
  @override
  Widget build(BuildContext context) {
    final standingsData = context.watch<StandingsData>();
    List<MapEntry<String, int>> top = standingsData.topStandings(5);

    return Card(
      color: const Color(0xFFF5F5E9),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                color: const Color(0xFFD34484),
                child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "* Текущий топ-5 *",
                      style: TextStyle(
                          color: Color(0xFFF5F5E9),
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          height: 1.5),
                    ))),
            Container(
              height: 8,
            ),
            buildTopPlayerWidget(top, 1),
            Container(
              height: 4,
            ),
            buildTopPlayerWidget(top, 2),
            Container(
              height: 4,
            ),
            buildTopPlayerWidget(top, 3),
            Container(
              height: 4,
            ),
            buildTopPlayerWidget(top, 4),
            Container(
              height: 4,
            ),
            buildTopPlayerWidget(top, 5),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget buildTopPlayerWidget(List<MapEntry<String, int>> top, int place) {
    var symbol = "";
    if (place == 1) {
      symbol = "🥇";
    } else if (place == 2) {
      symbol = "🥈";
    } else if (place == 3) {
      symbol = "🥉";
    }

    return Text(
      "$symbol $place. ${top[place - 1].key} — ${top[place - 1].value}",
      style: const TextStyle(color: Color(0xFF010123), height: 1.5, fontSize: 20),
    );
  }
}
