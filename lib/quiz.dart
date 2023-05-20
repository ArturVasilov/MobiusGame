import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobius/keyboard.dart';
import 'package:mobius/quiz_progress.dart';
import 'package:mobius/standings.dart';
import 'package:mobius/top_results.dart';
import 'package:provider/provider.dart';

import 'final_screen.dart';

class Quiz extends StatefulWidget {
  const Quiz({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return QuizState();
  }
}

class QuizState extends State<Quiz> {
  var _additionalTitle = "";

  final TextEditingController _nameFieldController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final TextEditingController _contactFieldController = TextEditingController();
  final _contactFocusNode = FocusNode();
  bool _isNameFocused = true;

  final _random = Random();

  @override
  Widget build(BuildContext context) {
    final quizData = context.watch<QuizProgressData>();
    final standingsData = context.watch<StandingsData>();

    _nameFocusNode.addListener(() {
      _isNameFocused = true;
    });
    _contactFocusNode.addListener(() {
      _isNameFocused = false;
    });

    return Column(
      children: [
        Expanded(flex: 3, child: buildHeaderWidget()),
        Expanded(
            flex: 17,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(flex: 2, child: TopResultsWidget()),
                Expanded(
                  flex: 5,
                  child: Card(
                      color: const Color(0xFFF5F5E9),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: buildCardContent(quizData, standingsData),
                      )),
                ),
                const Expanded(flex: 2, child: QuizProgress()),
              ],
            )),
      ],
    );
  }

  Widget buildHeaderWidget() {
    return Card(
        color: const Color(0xFFD34484),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Подготовьтесь к собеседованию на лучший офер",
                style: TextStyle(color: Color(0xFFF5F5E9), fontSize: 24),
              ),
              Container(
                height: 8,
              ),
              const Text(
                "Топ-3 участника игры получат Яндекс станцию",
                style: TextStyle(color: Color(0xFFF5F5E9), fontSize: 16),
              ),
            ],
          ),
        ));
  }

  Widget buildCardContent(
      QuizProgressData quizData, StandingsData standingsData) {
    if (quizData.isFinished()) {
      return const ResultWidget();
    } else if (quizData.initial) {
      return buildCardContentInitial(quizData, standingsData);
    } else {
      return buildCardContentQuestion(quizData, standingsData);
    }
  }

  Widget buildCardContentInitial(
      QuizProgressData quizData, StandingsData standingsData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Вы обычный разработчик мобильных приложений, второй год работаете в небольшой компании по разработке приложений. "
          "Внезапно вам поступило предложение пройти собеседование в компанию My Dreams, работать в которой вы всю жизнь считали недостижимой мечтой. "
          "Ради такого случая вы взяли отпуск на текущей работе и решили потратить ${QuizProgressData.daysAll} оставшихся до собеседования дней на подготовку. "
          "Вы выбрали направления, в которых хотите что-то подучить (и что скорее всего будут спрашивать на собеседовании):",
          style: TextStyle(
              fontSize: 16,
              color: Color(0xFF010123),
              fontWeight: FontWeight.w500,
              height: 1.5),
        ),
        const Text(
          "\n1. Язык программирования (Kotlin/Swift/Dart)"
          "\n2. SDK платформы (Android/iOS/Flutter)"
          "\n3. Многотопочность"
          "\n4. Алгоритмические задачки"
          "\n5.	Базовые знания Computer Science"
          "\n6. Софт-скиллы"
          "\n7. Задачи на логику",
          style: TextStyle(
              fontSize: 16,
              color: Color(0xFFD34484),
              fontWeight: FontWeight.w500,
              height: 1.5),
        ),
        const Text(
          "\nВы решили, что продуктивнее всего будет каждый день изучать что-то одно."
          "И вы хотите пройти собеседование максимально хорошо (в баллах). Итак, пора начинать.",
          style: TextStyle(
              fontSize: 16,
              color: Color(0xFF010123),
              fontWeight: FontWeight.w500,
              height: 1.5),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _displayTextInputDialog(context, standingsData, quizData);
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
                      'Начнем!',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ))),
            Container(
              height: 16,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildCardContentQuestion(
      QuizProgressData quizData, StandingsData standingsData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildQuestionTitle(quizData),
        Container(height: 24),
        buildAnswerItem('Язык программирования (Kotlin/Swift/Dart)',
            languageMessages, quizData, standingsData, () {
          quizData.makeAnswer(language: true);
        }),
        buildAnswerItem('SDK платформы (Android/iOS/Flutter)', platformMessages,
            quizData, standingsData, () {
          quizData.makeAnswer(platform: true);
        }),
        buildAnswerItem(
            'Многотопочность', multithreadMessages, quizData, standingsData,
            () {
          quizData.makeAnswer(multithread: true);
        }),
        buildAnswerItem('Алгоритмические задачки', algorithmMessages, quizData,
            standingsData, () {
          quizData.makeAnswer(algorithms: true);
        }),
        buildAnswerItem('Базовые знания Computer Science',
            computerScienceMessages, quizData, standingsData, () {
          quizData.makeAnswer(computerScience: true);
        }),
        buildAnswerItem(
            'Софт-скиллы', softSkillsMessages, quizData, standingsData, () {
          quizData.makeAnswer(soft: true);
        }),
        buildAnswerItem(
            'Задачи на логику', logicMessages, quizData, standingsData, () {
          quizData.makeAnswer(logic: true);
        }),
      ],
    );
  }

  Widget buildAnswerItem(
      String title,
      List<String> messages,
      QuizProgressData quizProgressData,
      StandingsData standingsData,
      VoidCallback clickCallback) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: 450,
              height: 45,
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      clickCallback();

                      if (quizProgressData.isFinished()) {
                        standingsData.setCurrentPlayerResult(
                            quizProgressData.calculateResult());
                      } else {
                        setCustomTitle(messages);
                      }
                    });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                              side: const BorderSide(
                                  color: Color(0xFF2B2B48), width: 1.0))),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      elevation: MaterialStateProperty.all(0)),
                  child: Text(
                    title,
                    style: const TextStyle(
                        backgroundColor: Colors.transparent,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2B2B48)),
                  ))),
          Container(
            height: 12,
          ),
        ]);
  }

  Widget buildQuestionTitle(QuizProgressData quizData) {
    if (_additionalTitle.length <= 10) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "День ${quizData.currentDay} из ${QuizProgressData.daysAll}. Что будем изучать?",
            style: const TextStyle(
                fontSize: 22,
                color: Color(0xFF010123),
                fontWeight: FontWeight.w500,
                height: 1.5),
          ),
        ],
      );
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: 80,
                child: Text(
                  _additionalTitle,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF010123),
                      fontWeight: FontWeight.w500,
                      height: 1.5),
                )),
            Container(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "День ${quizData.currentDay} из ${QuizProgressData.daysAll}. Что будем изучать?",
                  style: const TextStyle(
                      fontSize: 22,
                      color: Color(0xFF010123),
                      fontWeight: FontWeight.w500,
                      height: 1.5),
                ),
              ],
            ),
          ]);
    }
  }

  String? get _nameErrorText {
    // at any time, we can get the text from _controller.value.text
    final text = _nameFieldController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.isEmpty) {
      return 'Имя не может быть пустым';
    }
    if (text.length < 4) {
      return 'Имя должно быть длиннее 3х символов';
    }
    // return null if the text is valid
    return null;
  }

  String? get _contactErrorText {
    // at any time, we can get the text from _controller.value.text
    final text = _contactFieldController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text == "6543211") {
      // special secret action
      return null;
    }
    if (text.length != 11) {
      return 'В номере телефона должно быть 11 цифр';
    }
    if (int.tryParse(text) == null) {
      return 'В номере телефона должно быть только 11 цифр';
    }
    // return null if the text is valid
    return null;
  }

  Future<void> _displayTextInputDialog(BuildContext context,
      StandingsData standingsData, QuizProgressData quizData) async {
    return showDialog(
        context: context,
        builder: (context) {
          return ValueListenableBuilder(
              valueListenable: _contactFieldController,
              builder: (BuildContext context, TextEditingValue value, __) {
                return ValueListenableBuilder(
                  // Note: pass _controller to the animation argument
                  valueListenable: _nameFieldController,
                  builder: (context, TextEditingValue value, __) {
                    return buildDialog(standingsData, quizData);
                  },
                );
              });
        });
  }

  AlertDialog buildDialog(
      StandingsData standingsData, QuizProgressData quizData) {
    return AlertDialog(
      actionsPadding: const EdgeInsets.all(12),
      buttonPadding: const EdgeInsets.all(12),
      title: const Text('Давайте познакомимся!\n'
          'Укажите имя, которое будет в списке победителей,\n'
          'и телефон для связи и вручения приза.'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: _nameFieldController,
          focusNode: _nameFocusNode,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            labelText: 'Введите свое УНИКАЛЬНОЕ имя/логин',
            errorText: _nameErrorText,
          ),
        ),
        TextField(
          controller: _contactFieldController,
          focusNode: _contactFocusNode,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            labelText: 'Введите телефон',
            errorText: _contactErrorText,
          ),
        ),
        Container(
          height: 16,
        ),
        KeyboardWidget(
          inputCallback: (text) => {handleNewInput(text)},
          backspaceCallback: () => {handleBackspaceEvent()},
        ),
      ]),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () {
              setState(() {
                _nameFieldController.clear();
                _contactFieldController.clear();
                _isNameFocused = true;
                Navigator.pop(context);
              });
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: const BorderSide(
                            color: Color(0xFF2B2B48), width: 1.0))),
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                foregroundColor: MaterialStateProperty.all(Colors.black),
                elevation: MaterialStateProperty.all(0)),
            child: const Padding(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Text(
                  "ОТМЕНА",
                  style: TextStyle(
                      backgroundColor: Colors.transparent,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF2B2B48)),
                ))),
        ElevatedButton(
            onPressed: () {
              setState(() {
                if (_nameErrorText == null && _contactErrorText == null) {
                  if (_nameFieldController.value.text == "secret_action" &&
                      _contactFieldController.value.text == "6543211") {
                    _displaySecretStatsDialog(context, standingsData);
                  } else {
                    if (standingsData.isCorrectPhone(_nameFieldController.value.text,
                          _contactFieldController.value.text)) {
                      standingsData.startNewGame(
                          _nameFieldController.value.text,
                          _contactFieldController.value.text);
                      quizData.startNewGame();
                      _nameFieldController.clear();
                      _contactFieldController.clear();
                      _isNameFocused = true;
                      _additionalTitle = "";
                      Navigator.pop(context);
                    } else {
                      _displayContactErrorDialog();
                    }
                  }
                }
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
                padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Text(
                  'ГОТОВО',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ))),
      ],
    );
  }

  void handleNewInput(String text) {
    if (_isNameFocused) {
      _nameFieldController.text = _nameFieldController.value.text + text;
    } else {
      if (text == "1" ||
          text == "2" ||
          text == "3" ||
          text == "4" ||
          text == "5" ||
          text == "6" ||
          text == "7" ||
          text == "8" ||
          text == "9" ||
          text == "0") {
        _contactFieldController.text =
            _contactFieldController.value.text + text;
      }
    }
  }

  void handleBackspaceEvent() {
    if (_isNameFocused) {
      String text = _nameFieldController.value.text;
      if (text.isNotEmpty) {
        _nameFieldController.text = text.substring(0, text.length - 1);
      }
    } else {
      String text = _contactFieldController.value.text;
      if (text.isNotEmpty) {
        _contactFieldController.text = text.substring(0, text.length - 1);
      }
    }
  }

  Future<void> _displayContactErrorDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.all(12),
          buttonPadding: const EdgeInsets.all(12),
          title: const Text('У этого пользователя уже указан другой телефон!'),
          content: Container(height: 15,),
          actions: <Widget>[
            MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'ЗАКРЫТЬ',
                    style: TextStyle(fontSize: 14),
                  )),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _displaySecretStatsDialog(
      BuildContext context, StandingsData standingsData) async {
    List<MapEntry<String, int>> top = standingsData.topStandings(5);
    Map<String, String> contacts = standingsData.contacts();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.all(12),
          buttonPadding: const EdgeInsets.all(12),
          title: const Text('Победители с контактами'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            buildTopPlayerWidget(top, contacts, 1),
            buildTopPlayerWidget(top, contacts, 2),
            buildTopPlayerWidget(top, contacts, 3),
            buildTopPlayerWidget(top, contacts, 4),
            buildTopPlayerWidget(top, contacts, 5),
          ]),
          actions: <Widget>[
            MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'ЗАКРЫТЬ',
                    style: TextStyle(fontSize: 14),
                  )),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildTopPlayerWidget(List<MapEntry<String, int>> top,
      Map<String, String> contacts, int place) {
    var symbol = "";
    if (place == 1) {
      symbol = "🥇";
    } else if (place == 2) {
      symbol = "🥈";
    } else if (place == 3) {
      symbol = "🥉";
    }

    String player = top[place - 1].key;
    return Text(
      "$symbol $place. $player — ${top[place - 1].value}. Телефон - ${contacts[player]}",
      style: const TextStyle(color: Colors.black, height: 1.5, fontSize: 20),
    );
  }

  @override
  void dispose() {
    _nameFieldController.dispose();
    _contactFieldController.dispose();
    _isNameFocused = true;
    super.dispose();
  }

  void setCustomTitle(List<String> messageFrom) {
    int index = _random.nextInt(messageFrom.length);
    _additionalTitle = messageFrom[index];
  }

  static const List<String> languageMessages = [
    "Хороший выбор, вы вспомнили все основные конструкции языка и теперь готовы даже к самому душному собеседованию.",
    "Изучение языка привело к пониманию, что emptyList это не пустой звук, а пустой список.",
    "Вы изучили всю редкую функциональность языка, и теперь осталась лишь одна проблема — вы никак не можете понять, когда это вообще можно использовать.",
    "Вы добросовестно читаете книжки, но все это скучно и хочется уже бежать создавать приложения.",
    "Успешно изучены все статьи \"топ-100 вопросов на собеседовании\". Теперь вы готовы как никогда!"
  ];

  static const List<String> platformMessages = [
    "Вы внимательно изучили исходники SDK. \nПлюсы: вы поняли как, работают многие вещи. \nМинусы: вам больше не смешно в цирке.",
    "У вас было 11 статей на медиуме, 15 на хабре, море чатов, 3 книги по платформенной разработке и официальная документация. Не то чтобы всё это было категорически необходимо для изучения, но если уж начал учить SDK платформы, то к делу надо подходить серьёзно.",
    "Вы изучили UI фрэймворк вашего SDK. Жаль, что через неделю они выпускают новый.",
    "Хорошая работа! Прочитать одну статью и целый день смотреть в потолок — это несомненно значимо поднимет ваши скиллы!",
    "Вы сосредоточились и буквально за день изучили все кишки всех платформ. Теперь вы не сомневаетесь, что \"С++ за 21 день\" — это реально."
  ];

  static const List<String> multithreadMessages = [
    "Потоков много - вы один. Изучали сколько могли, пока голова не вызвала Thread.sleep().",
    "Вы поставили изучение multithreading на поток, а все остальное — на потом.",
    "Вы решили изучать многопоточность, и стали признанным экспертом в организации обедов для философов.",
    "Следующие дни несомненно будут более продуктивными, так как вы сможете параллельно изучать несколько тем (на самом деле нет, тогда слишком сложно было бы кодить такой квест).",
    "Отлично, теперь вы знаете, чем отличаются понятия multithreading и concurrency.",
  ];

  static const List<String> algorithmMessages = [
    "Вы изучили алгоритмы и структуры данных. Теперь вы крутите красно-черные деревья примерно на уровне пропеллера.",
    "Вы преисполнились пониманием и осознали, что кратчайший путь к сердцу кого угодно определяется алгоритмом Дейкстры.",
    "Вы углубились в теорию алгоритмов — изучили недетерминированные проблемы с полиномиальным временем, задачу выполнимости булевых формул и теорию категорий. Страшно представить, какие еще ужасы таятся в недрах этой дисциплины?",
    "Теперь ты можешь оптимизировать свой код настолько, что он будет работать быстрее, чем ты успеешь его написать (нет).",
    "Отлично, теперь ты умеешь строить алгоритм Укконена построения суффиксного дерева. Это наверняка поможет вам развернуть односвязный список.",
    "Теперь ты смотришь свысока на тех, кто не знает алгоритм Ленстры — Ленстры — Ловаса, хотя сам узнал про него на сегодня.",
    "Супер, теперь ты можешь написать алгоритм, который решит все твои проблемы. Если только бы ты мог решить, какой алгоритм тебе нужен."
  ];

  static const List<String> computerScienceMessages = [
    "Вы изучили базы данных и теперь хранимые процедуры триггерят у вас агрессию.",
    "Вы вспомнили, что вы вспомнили, что вы вспомнили, что все вспомнили, что такое рекурсия, что такое рекурсия, что такое рекурсия, что такое рекурсия.",
    "Модель OSI? Не вопрос. Assembler? Что может быть проще. Вас переполняет чувство невероятной уверенности и собственного превосходства.",
    "Теоретические изыскания — это хорошо, но ты ведь уже все это знаешь. Не пора ли применить все на практике?",
    "Вы далеко продвинулись в изучении SQL и теперь не можете удержаться от добавления \"'); DROP TABLE users;\" в конце своего ника на любом сайте.",
    "Вы изучали весь день Computer Science и не можете избавиться от навязчевого желания рассказать коллегам, что монада — это всего лишь моноид в категории эндофункторов"
  ];

  static const List<String> softSkillsMessages = [
    "Вы изучили все про time management. Теперь можно смело писать в LinkedIn \"Senior Pomodoro Developer\".",
    "Теперь ты знаешь, что ответить рекрутёру на вопрос: \"Какие ваши сильные стороны?\"",
    "Ещё вчера ты был middle, а теперь настоящий лидер, так что может тебе стоит претендовать на позицию тимлида?",
    "Теперь вы можете не только находить общий язык со своими коллегами, но и говорить на языке менеджеров, используя слова \"синергия\", \"эффективность\" и \"коллаборация\".",
    "Теперь вы знаете, как работать в команде! Вы можете успешно делегировать задачи своим коллегам и говорить им, что это \"важный этап их профессионального роста\".",
    "Теперь вы можете не только управлять своим временем, но и управлять своими коллегами, выступая в роли \"главного мотиватора\" и \"духовного лидера\".",
    "Ты получил навык презентации, а значит можешь пообещать работодателю, что будешь рассказывать об успехах компании на конференциях."
  ];

  static const List<String> logicMessages = [
    "Вы поняли жизнь, анекдоты про логиков и почему люки круглые. Не останавливайтесь на достигнутом!",
    "Кажется, вы начали осознавать, что вместо логики можно было изучить что-то более полезное. Логично!",
    "Круто! В офисе за кофе с коллегами сможешь долго обсуждать парадокс \"Все критяне лжецы\". Но кто-то должен работать вместо этого.",
    "Эти занятия логикой были полезны. Или это сообщение ложно.",
    "Логика поможет тебе пройти все этапы собеседования. А мы обещаем, что наши рекрутеры точно будут с острова рыцарей.",
    "Теперь ты умеешь решать все задачи про мудрецов и колпаки, так держать!",
    "Ну теперь знаешь, сколько теннисных мячей поместится в автобусе, сколько стеклянных шариков нужно разбить в 100-этажном здании и почем сегодня услуги мойщика окон."
  ];
}
