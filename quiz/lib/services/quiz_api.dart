import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quiz/models/question.dart';

class QuizApi {
  static Future<List<Question>> fetch() async {
    try {
      var url =
          'https://script.google.com/macros/s/AKfycbzzRMgGOUm8Mo7Gote8h3zyoK70LftJ4ZL0cAxHXppMdJzHsjRQ/exec';
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return List<Question>.from(
            data["questions"].map((x) => Question.fromMap(x)));
      } else {
        return List<Question>();
      }
    } catch (error) {
      print(error);
      return List<Question>();
    }
  }
}
