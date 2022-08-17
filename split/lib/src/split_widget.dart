import 'package:flutter/material.dart';
import 'package:split/src/split_horizontal_widget.dart';
import 'package:split/src/split_vertical_widget.dart';

class SplitWidget extends StatefulWidget {
  SplitWidget({
    Key? key,
    required this.childFirst,
    required this.childSecond,
  }) : super(key: key);
  final Widget childFirst;
  final Widget childSecond;

  @override
  _SplitWidget createState() => _SplitWidget();
}

class _SplitWidget extends State<SplitWidget> {
  @override
  Widget build(BuildContext context) => OrientationBuilder(
        builder: (context, orientation) {
          return (orientation == Orientation.portrait)
              ? SplitVerticalWidget(
                  childTop: widget.childFirst,
                  childBottom: widget.childSecond,
                )
              : SplitHorizontalWidget(
                  childStart: widget.childFirst,
                  childEnd: widget.childSecond,
                );
        },
      );
}
