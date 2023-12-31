import 'package:flutter/material.dart';
import 'package:proj_2/activity/Basketball.dart';
import 'package:proj_2/activity/badminton.dart';

void main() {
  runApp(MaterialApp(
    routes: {

      "/" : (context) => BasketballMatchApp(),
    },
  ));
}
