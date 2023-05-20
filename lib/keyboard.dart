import 'package:flutter/material.dart';

class KeyboardWidget extends StatefulWidget {
  final Function(String) inputCallback;
  final VoidCallback backspaceCallback;

  const KeyboardWidget(
      {Key? key, required this.inputCallback, required this.backspaceCallback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return KeyboardWidgetState();
  }
}

class KeyboardWidgetState extends State<KeyboardWidget> {
  bool _caps = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            buildButton("1"),
            buildButton("2"),
            buildButton("3"),
            buildButton("4"),
            buildButton("5"),
            buildButton("6"),
            buildButton("7"),
            buildButton("8"),
            buildButton("9"),
            buildButton("0"),
          ],
        ),
        Row(
          children: [
            buildButton("q"),
            buildButton("w"),
            buildButton("e"),
            buildButton("r"),
            buildButton("t"),
            buildButton("y"),
            buildButton("u"),
            buildButton("i"),
            buildButton("o"),
            buildButton("p"),
          ],
        ),
        Row(
          children: [
            buildButton("a"),
            buildButton("s"),
            buildButton("d"),
            buildButton("f"),
            buildButton("g"),
            buildButton("h"),
            buildButton("j"),
            buildButton("k"),
            buildButton("l"),
            buildBackspaceButton(),
          ],
        ),
        Row(
          children: [
            buildButton("z"),
            buildButton("x"),
            buildButton("c"),
            buildButton("v"),
            buildButton("b"),
            buildButton("n"),
            buildButton("m"),
            buildCapsButton(),
          ],
        )
      ],
    );
  }

  Widget buildButton(String text) {
    return Padding(
        padding: const EdgeInsets.all(3),
        child: SizedBox(
            width: 50,
            height: 40,
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.inputCallback(
                        _caps ? text.toUpperCase() : text.toLowerCase());
                    _caps = false;
                  });
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFFD34484))),
                child: Text(
                  _caps ? text.toUpperCase() : text.toLowerCase(),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ))));
  }

  Widget buildBackspaceButton() {
    return Padding(
        padding: const EdgeInsets.all(3),
        child: SizedBox(
            width: 50,
            height: 40,
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.backspaceCallback();
                    _caps = false;
                  });
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFFD34484))),
                child: const Text(
                  "←",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ))));
  }

  Widget buildCapsButton() {
    return Padding(
        padding: const EdgeInsets.all(3),
        child: SizedBox(
            width: 162,
            height: 40,
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _caps = !_caps;
                  });
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFFD34484))),
                child: const Text(
                  "⇧",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ))));
  }
}
