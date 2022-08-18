import 'package:flutter/material.dart';
import 'package:split/src/draggable_config.dart';
import 'package:split/src/measure_size_render_object.dart';
import 'package:split/src/positioned_draggable_icon.dart';

class SplitVerticalWidget extends StatefulWidget {
  final Widget childTop;
  final Widget childBottom;

  const SplitVerticalWidget({
    Key? key,
    required this.childTop,
    required this.childBottom,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplitVerticalWidgetState();
}

class _SplitVerticalWidgetState extends State<SplitVerticalWidget> {
  final ValueNotifier<double> _topDraggableIcon = ValueNotifier<double>(0.0);
  var childSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    return MeasureSize(
      onChange: (Size size) {
        setState(() {
          childSize = size;
          _topDraggableIcon.value =
              (childSize.height - DraggableConfig.kTapSize) / 2;
        });
      },
      child: ValueListenableBuilder<double>(
        valueListenable: _topDraggableIcon,
        builder: (BuildContext context, double value, Widget? child) {
          return Stack(
            children: <Widget>[
              Positioned(
                child: widget.childTop,
                top: 0,
                left: 0,
                width: childSize.width,
                height: value,
              ),
              Positioned(
                child: widget.childBottom,
                top: value + DraggableConfig.kTapSize,
                left: 0,
                width: childSize.width,
                height: childSize.height - (value + DraggableConfig.kTapSize),
              ),
              PositionedDraggableIcon(
                size: childSize,
                left: 0,
                top: value,
                draggable: DraggableConfig(
                  backgroundColor: Colors.black12,
                  icon: Icons.more_horiz,
                  iconColor: Colors.white,
                ),
                feedback: DraggableConfig(
                  backgroundColor: Colors.black,
                  icon: Icons.more_horiz,
                  iconColor: Colors.white,
                ),
                axis: Axis.vertical,
                onChangePosition: (top, left) {
                  _topDraggableIcon.value = top;
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
