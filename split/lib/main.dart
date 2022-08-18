import 'package:flutter/material.dart';
import 'package:split/split.dart';
import 'package:split/src/measure_size_render_object.dart';
import 'package:split/src/postion_widget.dart';

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
        margin: EdgeInsets.all(50.0),
        child: SizedView(),
        /*
        SplitWidget(
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
        */
      ),
    );
  }
}

class SizedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = Size.zero;
    Offset dragOffset = Offset.zero;

    final axis = Axis.horizontal;

    final PositionWidget postionWidget = PositionWidget();
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        height: 300,
        width: 600,
        child: MeasureSizeWidget(
          onChange: (Size newSize) {
            setState((() {
              size = newSize;
              postionWidget.update(
                size,
                dragOffset,
                postionWidget.drag.size,
                axis,
              );
            }));
          },
          child: Stack(
            children: [
              PageWidget(
                color: Colors.red,
                text:
                    "${size.toString()} ${postionWidget.drag.position.toString()}",
              ),
              Positioned(
                left: postionWidget.drag.position.dx,
                top: postionWidget.drag.position.dy,
                child: DragWidget(
                  axis: axis,
                  dragSize: postionWidget.drag.size,
                  onDragEnd: (offset) {
                    if (offset != null) {
                      setState(
                        () {
                          final currentOffset =
                              postionWidget.drag.position + offset;
                          postionWidget.update(
                            size,
                            currentOffset,
                            postionWidget.drag.size,
                            axis,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              Positioned(
                left: postionWidget.getFirst(axis).position.dx,
                top: postionWidget.getFirst(axis).position.dy,
                width: postionWidget.getFirst(axis).size.width,
                height: postionWidget.getFirst(axis).size.height,
                child: PageWidget(
                  text: "FIRST",
                  color: Colors.green,
                ),
              ),
              Positioned(
                left: postionWidget.getLast(axis).position.dx,
                top: postionWidget.getLast(axis).position.dy,
                width: postionWidget.getLast(axis).size.width,
                height: postionWidget.getLast(axis).size.height,
                child: PageWidget(
                  text: "LAST",
                  color: Colors.yellow,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class DragWidget extends StatelessWidget {
  final void Function(
    Offset? offset,
  ) onDragEnd;

  final Size dragSize;
  final Axis axis;

  const DragWidget({
    Key? key,
    required this.onDragEnd,
    required this.dragSize,
    required this.axis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = dragSize.width;
    double height = dragSize.height;
    return Draggable(
      child: Container(
        height: height,
        width: width,
        color: Colors.black,
      ),
      childWhenDragging: Container(
        height: height,
        width: width,
        color: Colors.grey,
      ),
      feedback: Container(
        height: height,
        width: width,
        color: Colors.blue,
      ),
      onDragEnd: (drag) {
        final renderBox = context.findRenderObject() as RenderBox?;
        var offset = renderBox?.globalToLocal(drag.offset) ?? Offset.zero;
        onDragEnd(offset);
      },
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
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
