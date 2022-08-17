import 'package:flutter/material.dart';
import 'package:split/split.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title!),
        ),
        body: Container(
          child: SplitWidget(
            childFirst: SplitVerticalWidget(
              childTop: const PageWidget(
                color: Colors.red,
                text: "A",
              ),
              childBottom: const PageWidget(
                color: Colors.blue,
                text: "B",
              ),
            ),
            childSecond: SplitHorizontalWidget(
              childStart: const PageWidget(
                color: Colors.yellow,
                text: "C",
              ),
              childEnd: const PageWidget(
                color: Colors.green,
                text: "D",
              ),
            ),
          ),
        ));
  }
}

class PageWidget extends StatelessWidget {
  final String text;
  final Color color;

  const PageWidget({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 44,
          ),
        ),
      ),
    );
  }
}
