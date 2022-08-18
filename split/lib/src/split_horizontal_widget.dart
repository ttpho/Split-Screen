import 'package:flutter/material.dart';
import 'package:split/src/draggable_config.dart';
import 'package:split/src/measure_size_render_object.dart';
import 'package:split/src/positioned_draggable_icon.dart';

class SplitHorizontalWidget extends StatefulWidget {
  SplitHorizontalWidget({
    Key? key,
    required this.childStart,
    required this.childEnd,
  }) : super(key: key);
  final Widget childStart;
  final Widget childEnd;

  @override
  _SplitHorizontalWidget createState() => _SplitHorizontalWidget();
}

class _SplitHorizontalWidget extends State<SplitHorizontalWidget> {
  var childSize = Size.zero;

  double _leftDraggableIcon = 0.0;

  @override
  Widget build(BuildContext context) {
    return MeasureSize(
      onChange: (Size size) {
        setState(() {
          childSize = size;
          _leftDraggableIcon = (childSize.width - DraggableConfig.kTapSize) / 2;
        });
      },
      child: Stack(
        children: <Widget>[
          Positioned(
            child: widget.childStart,
            top: 0,
            left: 0,
            width: _leftDraggableIcon,
            height: childSize.height,
          ),
          Positioned(
            child: widget.childEnd,
            top: 0,
            left: _leftDraggableIcon + DraggableConfig.kTapSize,
            width: childSize.width -
                (_leftDraggableIcon + DraggableConfig.kTapSize),
            height: childSize.height,
          ),
          PositionedDraggableIcon(
            size: childSize,
            top: 0,
            left: _leftDraggableIcon,
            draggable: DraggableConfig(
              backgroundColor: Colors.black12,
              icon: Icons.more_vert,
              iconColor: Colors.white,
            ),
            feedback: DraggableConfig(
              backgroundColor: Colors.black,
              icon: Icons.more_vert,
              iconColor: Colors.white,
            ),
            axis: Axis.horizontal,
            onChangePosition: (top, left) {
              setState(() {
                _leftDraggableIcon = left;
              });
            },
          ),
        ],
      ),
    );
  }
}
