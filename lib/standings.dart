import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StandingsData extends ChangeNotifier {
  static const playerPrefixKey = "player_key_prefix-";
  static const playerTimestampPrefixKey = "player_timestamp_key_prefix-";
  static const contactPrefixKey = "player_contact_key_prefix-";

  final HashMap<String, int> _standings = HashMap();
  final HashMap<String, int> _timestamps = HashMap();
  final HashMap<String, String> _contacts = HashMap();

  StandingsData() {
    _standings["TestPlayer5"] = 0;
    _standings["TestPlayer4"] = 1;
    _standings["TestPlayer3"] = 2;
    _standings["TestPlayer2"] = 3;
    _standings["TestPlayer1"] = 4;

    _timestamps["TestPlayer5"] = 0;
    _timestamps["TestPlayer4"] = 1;
    _timestamps["TestPlayer3"] = 2;
    _timestamps["TestPlayer2"] = 3;
    _timestamps["TestPlayer1"] = 4;

    readStandings();
  }

  void readStandings() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    Set<String> keys = preferences.getKeys();
    for (var key in keys) {
      if (key.startsWith(playerPrefixKey)) {
        int score = preferences.getInt(key)!;
        String playerName = key.substring(playerPrefixKey.length);
        _standings[playerName] = score;
      }
      if (key.startsWith(playerTimestampPrefixKey)) {
        int timestamp = preferences.getInt(key)!;
        String playerName = key.substring(playerTimestampPrefixKey.length);
        _timestamps[playerName] = timestamp;
      }
      if (key.startsWith(contactPrefixKey)) {
        String contact = preferences.getString(key)!;
        String playerName = key.substring(contactPrefixKey.length);
        _contacts[playerName] = contact;
      }
    }

    notifyListeners();
  }

  void saveContact(String playerName, playerContact) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(contactPrefixKey + playerName, playerContact);
  }

  String currentPlayer = "BestPlayerEver";
  Result _currentResult = Result();

  Result get currentResult => _currentResult;

  void startNewGame(String playerName, String playerContact) {
    currentPlayer = playerName;
    _contacts[playerName] = playerContact;
    saveContact(playerName, playerContact);

    _currentResult = Result();
  }

  bool isCorrectPhone(String playerName, String playerContact) {
    String? contact = _contacts[playerName];
    if (contact == null) {
      return true;
    }
    return playerContact == contact;
  }

  void setCurrentPlayerResult(int score) {
    int currentPlace = -1;

    _currentResult.score = score;

    List<MapEntry<String, int>> currentResults = _standings.entries.toList();
    currentResults.sort((result1, result2) => compare(result1, result2));

    for (var i = 0; i < currentResults.length; i++) {
      if (currentResults[i].key == currentPlayer) {
        currentPlace = i + 1;
        break;
      }
    }

    int? currentScore = _standings[currentPlayer];
    if (currentScore != null) {
      _currentResult.beforeScore = currentScore;
    }
    if (currentScore == null || currentScore < score) {
      _standings[currentPlayer] = score;
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      _timestamps[currentPlayer] = timestamp;
      saveResult(timestamp);
    }

    int place = -1;

    currentResults = _standings.entries.toList();
    currentResults.sort((result1, result2) => compare(result1, result2));

    for (var i = 0; i < currentResults.length; i++) {
      if (currentResults[i].key == currentPlayer) {
        place = i + 1;
        break;
      }
    }

    _currentResult.place = place;
    _currentResult.beforePlace = currentPlace;

    notifyListeners();
  }

  int compare(MapEntry<String, int> result1, MapEntry<String, int> result2) {
    int result = result2.value.compareTo(result1.value);
    if (result == 0) {
      int? timestamp2 = _timestamps[result2.key];
      int? timestamp1 = _timestamps[result1.key];

      if (timestamp1 != null && timestamp2 != null) {
        return timestamp1.compareTo(timestamp2);
      }
    }
    return result;
  }

  void saveResult(int timestamp) async {
    if (currentResult.score > currentResult.beforeScore) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setInt(
          playerPrefixKey + currentPlayer, currentResult.score);
      await preferences.setInt(
          playerTimestampPrefixKey + currentPlayer, timestamp);
    }
  }

  List<MapEntry<String, int>> topStandings(int count) {
    List<MapEntry<String, int>> currentResults = _standings.entries.toList();
    currentResults.sort((result1, result2) => compare(result1, result2));
    return currentResults.take(min(count, currentResults.length)).toList();
  }

  Map<String, String> contacts() {
    return _contacts;
  }
}

class Result {
  int place = -1;
  int beforePlace = -1;
  int score = -1;
  int beforeScore = -1;
}
