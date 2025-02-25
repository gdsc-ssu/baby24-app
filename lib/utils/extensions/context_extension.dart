import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}
