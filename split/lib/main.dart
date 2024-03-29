import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:split/src/split_widget.dart';
import 'dart:io' show Platform;
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      debugShowCheckedModeBanner: false,
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
        title: Text(widget.title ?? ""),
      ),
      body: Builder(builder: (context) {
        if (kIsWeb) {
          return WebScreenDisplayWidget();
        }
        if (Platform.isAndroid || Platform.isIOS) {
          return MobileDisplayWidget();
        }
        return WebScreenDisplayWidget();
      }),

      // WebScreenDisplayWidget(),
    );
  }
}

class MobileDisplayWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplitWidget(
      controller: SplitWidgetController(
        Axis.vertical,
      ),
      firstChild: WebViewPageWidget(
        url: "https://www.google.com/search?q=android",
      ),
      lastChild: WebViewPageWidget(
        url: "https://github.com/search?q=android",
      ),
    );
  }
}

class WebScreenDisplayWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplitWidget(
      controller: SplitWidgetController(
        Axis.horizontal,
      ),
      firstChild: PageWidget(
        color: Colors.red,
        text: "A",
      ),
      lastChild: SplitWidget(
        controller: SplitWidgetController(
          Axis.vertical,
        ),
        firstChild: PageWidget(
          color: Colors.green,
          text: "B",
        ),
        lastChild: PageWidget(
          color: Colors.orange,
          text: "C",
        ),
      ),
    );
  }
}

class WebViewPageWidget extends StatefulWidget {
  final String url;

  const WebViewPageWidget({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  _WebViewPageWidgetState createState() => _WebViewPageWidgetState();
}

class _WebViewPageWidgetState extends State<WebViewPageWidget> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: widget.url,
    );
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
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
