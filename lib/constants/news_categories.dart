
import 'package:flutter/material.dart';

class NewsCategories {
  static const String sports = 'Sports';

  static const String clubs = 'Clubs';

  static const String administration = 'Administration';

  static const String studentCouncil = 'Student Council';

  static const List<String> categories = [sports, clubs, administration, studentCouncil];

  static Color? getCategoryColor(String category, bool lighterShade) {
    if(category == sports) {
      return lighterShade ? Colors.red[100] : Colors.red;
    }
    else if(category == clubs) {
      return lighterShade ? Colors.blue[50] : Colors.blue;
    }
    else if(category == administration) {
      return lighterShade ? Colors.orange[50] : Colors.orange;
    }
    else if(category == studentCouncil) {
      return lighterShade ? Colors.purple[50] : Colors.purple;
    }
    else {
      return Colors.grey;
    }
  }
}