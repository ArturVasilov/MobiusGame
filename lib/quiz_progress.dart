import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizProgressData extends ChangeNotifier {
  QuizProgressData() {
    reset();
  }

  final _random = Random();

  var _initial = true;

  static const int daysAll = 24;

  int _currentDay = 1;

  double _language = 0.25;
  double _platform = 0.35;
  double _multithread = 0.17;
  double _computerScience = 0.24;
  double _algorithms = 0.28;
  double _soft = 0.3;
  double _logic = 0.1;

  int _language_days_in_row = 0;
  int _algorithm_days_in_row = 0;
  int _platform_days_in_row = 0;
  int _multithread_days_in_row = 0;
  int _computer_science_days_in_row = 0;

  int _days_without_language = 0;
  int _days_without_platform = 0;
  int _days_without_algorithms = 0;

  bool get initial => _initial;

  int get currentDay => _currentDay;

  double get language => _language;

  double get platform => _platform;

  double get multithread => _multithread;

  double get computerScience => _computerScience;

  double get algorithms => _algorithms;

  double get soft => _soft;

  double get logic => _logic;

  void startNewGame() {
    _initial = false;
  }

  void makeAnswer(
      {bool language = false,
      bool platform = false,
      bool multithread = false,
      bool computerScience = false,
      bool algorithms = false,
      bool soft = false,
      bool logic = false}) {
    if (language) {
      double diff = makeBaseAddiction(_language, 3);
      _language_days_in_row++;
      _days_without_language = 0;
      if (_language > _computerScience * 2) {
        diff = diff * 0.7;
      } else if (_computerScience < 0.4) {
        diff = diff * 0.88;
      }
      if (_language_days_in_row >= 3) {
        diff = diff * 1.15;
        _computerScience = adjust(_computerScience + 0.06);
        _algorithms = adjust(_algorithms - 0.02);
      }
      _language = adjust(_language + diff);
    } else {
      _language_days_in_row = 0;
      _days_without_language++;

      if (_days_without_language >= 8) {
        if (daysLeft() == 1) {
          _language = adjust(_language - 0.4);
        } else {
          _language = adjust(_language - 0.1);
        }
      }
    }

    if (platform) {
      double diff = makeBaseAddiction(_platform, 2);
      _platform_days_in_row++;
      _days_without_platform = 0;
      if ((_computerScience + _language) > 1.0) {
        diff = diff * 1.05;
      } else if (_platform > _language) {
        diff = diff * 0.7;
      }
      if (_platform_days_in_row >= 3) {
        diff = diff * 1.15;
        _language = adjust(_language + 0.05);
        _algorithms = adjust(_algorithms - 0.04);
      }
      _platform = adjust(_platform + diff);
    } else {
      _platform_days_in_row = 0;
      _days_without_platform++;

      if (_days_without_platform >= 10) {
        if (daysLeft() == 1) {
          _platform = adjust(_platform - 0.3);
        } else {
          _platform = adjust(_platform - 0.15);
        }
      }
    }

    if (multithread) {
      double diff = makeBaseAddiction(_multithread, 4);
      _multithread_days_in_row++;
      if (_multithread > _language) {
        diff = diff * 0.6;
      } else if (_multithread_days_in_row >= 3) {
        diff = diff * 1.3;
      }
      _multithread = adjust(_multithread + diff);
    } else {
      _multithread_days_in_row = 0;
    }

    if (computerScience) {
      double diff = makeBaseAddiction(_computerScience, 3);
      _computer_science_days_in_row++;
      if (_computer_science_days_in_row >= 2) {
        diff = diff * 1.05;
        _algorithms = adjust(_algorithms + 0.03);
      }
      _computerScience = adjust(_computerScience + diff);
    } else {
      _computer_science_days_in_row = 0;
    }

    if (algorithms) {
      double diff = makeBaseAddiction(_algorithms, 4);
      _algorithm_days_in_row++;
      _days_without_algorithms = 0;
      if (_algorithm_days_in_row >= 3) {
        _soft = adjust(_soft - 0.5);
        diff = diff * 1.2;
        _computerScience = min(1.0, _computerScience + 0.1);
      } else if (_algorithms > _computerScience) {
        diff = diff * 0.8;
      }
      _algorithms = adjust(_algorithms + diff);

      _language = adjust(_language - 0.01);
      _platform = adjust(_platform - 0.02);
    } else {
      _algorithm_days_in_row = 0;
      _days_without_algorithms++;

      if (_days_without_algorithms >= 6) {
        if (daysLeft() == 1) {
          _algorithms = adjust(_algorithms - 0.3);
        } else {
          _algorithms = adjust(_algorithms - 0.05);
        }
      }
    }

    if (soft) {
      double diff = makeBaseAddiction(_soft, 1);
      if (daysLeft() == 1) {
        diff = diff * 2;
      }
      if (_soft >= 0.9) {
        _language = adjust(_language - 0.03);
        _platform = adjust(_platform - 0.03);
        _algorithms = adjust(_algorithms - 0.03);
      }
      _soft = adjust(_soft + diff);
    }

    if (logic) {
      double diff = makeBaseAddiction(_logic, 1);
      _logic = adjust(_logic + diff);

      _soft = adjust(_soft - 0.05);
      _language = adjust(_language - 0.03);
      _platform = adjust(_platform - 0.02);

      if (daysLeft() == 1) {
        _soft = adjust(_soft - 0.1);
        _language = adjust(_language - 0.05);
        _platform = adjust(_platform - 0.05);
      }
    }

    _currentDay++;

    notifyListeners();
  }

  double makeBaseAddiction(double currentScore, int difficultyLevel) {
    if (currentScore < 0.3) {
      switch (difficultyLevel) {
        case 1: return 0.45;
        case 2: return 0.35;
        case 3: return 0.25;
        case 4: return 0.2;
        default: return 0.2;
      }
    }

    if (currentScore < 0.6) {
      double percent = 0.5;
      switch (difficultyLevel) {
        case 1:
          percent = 0.6;
          break;
        case 2:
          percent = 0.45;
          break;
        case 3:
          percent = 0.35;
          break;
        case 4:
        default:
          percent = 0.2;
          break;
      }

      return (1.0 - currentScore) * percent;
    }

    if (currentScore < 0.85) {
      double percent = 0.5;
      switch (difficultyLevel) {
        case 1:
          percent = 0.8;
          break;
        case 2:
          percent = 0.65;
          break;
        case 3:
          percent = 0.45;
          break;
        case 4:
        default:
          percent = 0.25;
          break;
      }

      return (1.0 - currentScore) * percent;
    }

    switch (difficultyLevel) {
      case 1: return 0.2;
      case 2: return 0.15;
      case 3: return 0.1;
      case 4: return 0.05;
      default: return 0.05;
    }
  }

  double adjust(double value) {
    return max(0.0, min(1.0, value));
  }

  void reset() {
    _initial = true;

    _currentDay = 1;

    _language = 0.25;
    _platform = 0.35;
    _multithread = 0.17;
    _computerScience = 0.24;
    _algorithms = 0.28;
    _soft = 0.3;
    _logic = 0.1;

    shiftValues();
    shiftValues();
    shiftValues();

    _language_days_in_row = 0;
    _algorithm_days_in_row = 0;
    _platform_days_in_row = 0;
    _multithread_days_in_row = 0;
    _computer_science_days_in_row = 0;

    _days_without_language = 0;
    _days_without_platform = 0;
    _days_without_algorithms = 0;

    notifyListeners();
  }

  void shiftValues() {
    int change = _random.nextInt(5) + 1;
    switch (change) {
      case 1:
        _language -= 0.02;
        _computerScience += 0.03;
        break;
      case 2:
        _algorithms -= 0.01;
        _soft += 0.01;
        break;
      case 3:
        _soft -= 0.02;
        _algorithms += 0.02;
        break;
      case 4:
        _computerScience -= 0.01;
        _logic += 0.04;
        break;
      case 5:
        _multithread += 0.03;
        _computerScience -= 0.04;
        break;
    }
  }

  int calculateResult() {
    var result = (language * 1800 +
            platform * 2100 +
            multithread * 1600 +
            computerScience * 1200 +
            algorithms * 1500 +
            soft * 1500 +
            logic * 300);

    if (soft < 0.01) {
      result = result * 0.5;
    } else if (soft < 0.2) {
      result = result * 0.85;
    }

    if (language < 0.5) {
      result = result * 0.8;
    }
    if (platform < 0.6) {
      result = result * 0.9;
    }
    if (multithread < 0.5) {
      result = result * 0.85;
    }

    return result.toInt();
  }

  bool isFinished() {
    return _currentDay > daysAll;
  }

  int daysLeft() {
    return daysAll - _currentDay + 1;
  }
}

class QuizProgress extends StatefulWidget {
  const QuizProgress({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return QuizProgressState();
  }
}

class QuizProgressState extends State<QuizProgress> {
  @override
  Widget build(BuildContext context) {
    final quizData = context.watch<QuizProgressData>();
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
            buildSkillWidget(
                "Язык программирования (Kotlin/Swift/Dart)", quizData.language),
            buildSkillWidget(
                "SDK платформы (Android/iOS/Flutter)", quizData.platform),
            buildSkillWidget("Многопоточность", quizData.multithread),
            buildSkillWidget("Алгоритмические задачки", quizData.algorithms),
            buildSkillWidget(
                "Базовые знания Computer Science", quizData.computerScience),
            buildSkillWidget("Софт-скиллы", quizData.soft),
            buildSkillWidget("Задачи на логику", quizData.logic),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  buildSkillWidget(String skillTitle, double value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          skillTitle,
          style: const TextStyle(color: Color(0xFF010123),
              fontWeight: FontWeight.w400, fontSize: 16),
        ),
        Container(
          height: 10,
        ),
        LinearProgressIndicator(
          value: value,
          minHeight: 5,
          backgroundColor: const Color(0xFF010123),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD34484)),
        ),
        Container(
          height: 7,
        ),
        Text(
          "${(value * 100).round()} из 100",
          style: const TextStyle(color: Color(0xFF010123),
              fontWeight: FontWeight.w400, fontSize: 12),
        ),
        Container(
          height: 10,
        ),
      ],
    );
  }
}
