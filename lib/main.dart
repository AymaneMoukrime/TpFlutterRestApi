import 'package:flutter/material.dart';
import 'comment_list_secreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comments App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CommentListScreen(),
    );
  }
}
