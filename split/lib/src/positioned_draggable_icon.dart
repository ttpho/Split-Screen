import 'package:flutter/material.dart';
import 'package:split/src/draggable_config.dart';

class DraggableIcon extends StatelessWidget {
  final DraggableConfig? config;

  const DraggableIcon({
    Key? key,
    required this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: config?.backgroundColor ?? Colors.black,
        child: Center(
          child: Icon(
            config?.icon ?? Icons.more_horiz,
            color: config?.iconColor ?? Colors.white,
          ),
        ),
      );
}

class PositionedDraggableIcon extends StatefulWidget {
  final double? top;
  final double? left;
  final Function? onChangePosition;
  final Axis axis;
  final DraggableConfig? draggable;
  final DraggableConfig? feedback;
  final Size size;

  PositionedDraggableIcon({
    Key? key,
    this.axis: Axis.vertical,
    this.top,
    this.left,
    this.onChangePosition,
    this.draggable,
    this.feedback,
    required this.size,
  }) : super(key: key);

  @override
  _PositionedDraggableIconState createState() =>
      _PositionedDraggableIconState();
}

class _PositionedDraggableIconState extends State<PositionedDraggableIcon> {
  final GlobalKey _key = GlobalKey();
  double? top, left;
  double xOff = 0;
  double yOff = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    top = widget.top;
    left = widget.left;
    super.initState();
  }

  void _getRenderOffsets() {
    final RenderBox renderBoxWidget =
        _key.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBoxWidget.localToGlobal(Offset.zero);

    yOff = offset.dy - this.top!;
    xOff = offset.dx - this.left!;
  }

  void _afterLayout(_) {
    _getRenderOffsets();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    return Positioned(
      key: _key,
      top: top,
      left: left,
      child: Draggable(
        axis: widget.axis,
        child: Container(
          width: widget.axis == Axis.vertical
              ? size.width
              : DraggableConfig.kTapSize,
          height: widget.axis == Axis.vertical
              ? DraggableConfig.kTapSize
              : size.height,
          child: DraggableIcon(config: widget.draggable),
        ),
        feedback: Container(
          width: widget.axis == Axis.vertical
              ? size.width
              : DraggableConfig.kTapSize,
          height: widget.axis == Axis.vertical
              ? DraggableConfig.kTapSize
              : size.height,
          child: DraggableIcon(config: widget.feedback),
        ),
        childWhenDragging: Container(),
        onDragEnd: (drag) {
          setState(() {
            var _top = drag.offset.dy - yOff;
            var _left = drag.offset.dx - xOff;
            if (widget.axis == Axis.vertical) {
              if (_top < DraggableConfig.kMinTop) {
                top = DraggableConfig.kMinTop;
              } else if (_top > (size.height - DraggableConfig.kMinTop)) {
                top = size.height - DraggableConfig.kMinTop;
              } else {
                top = _top;
              }
            } else {
              top = _top;
              if (_left < DraggableConfig.kMinLeft) {
                left = DraggableConfig.kMinLeft;
              } else if (_left > (size.width - DraggableConfig.kMinLeft)) {
                left = size.width - DraggableConfig.kMinLeft;
              } else {
                left = _left;
              }
            }
            if (widget.onChangePosition != null) {
              widget.onChangePosition!(top, left);
            }
          });
        },
      ),
    );
  }
}
