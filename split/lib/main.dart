import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'SplitWidget.dart';

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
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          child: SplitWidget(
            childFirst: _webView("https://www.google.com/"),
            childSecond: _webView("https://duckduckgo.com/"),
          ),
        ));
  }

  _webView(final String url) => WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      );
}
