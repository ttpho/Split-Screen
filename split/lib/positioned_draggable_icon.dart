import 'package:flutter/material.dart';
import 'package:split/draggable_icon_config.dart';

class DraggableIcon extends StatelessWidget {
  final DraggableIconConfig? config;

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
  final DraggableIconConfig? draggable;
  final DraggableIconConfig? feedback;

  PositionedDraggableIcon({
    Key? key,
    this.axis: Axis.vertical,
    this.top,
    this.left,
    this.onChangePosition,
    this.draggable,
    this.feedback,
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
    final double widthScreen = MediaQuery.of(context).size.width;
    final double heightScreen = MediaQuery.of(context).size.height;
    final padding = MediaQuery.of(context).padding;
    final double heightWithoutStatusToolbar =
        heightScreen - padding.top - kToolbarHeight;
    return Positioned(
      key: _key,
      top: top,
      left: left,
      child: Draggable(
        axis: widget.axis,
        child: Container(
          width: widget.axis == Axis.vertical
              ? widthScreen
              : DraggableIconConfig.kTapSize,
          height: widget.axis == Axis.vertical
              ? DraggableIconConfig.kTapSize
              : heightWithoutStatusToolbar,
          child: DraggableIcon(config: widget.draggable),
        ),
        feedback: Container(
          width: widget.axis == Axis.vertical
              ? widthScreen
              : DraggableIconConfig.kTapSize,
          height: widget.axis == Axis.vertical
              ? DraggableIconConfig.kTapSize
              : heightWithoutStatusToolbar,
          child: DraggableIcon(config: widget.feedback),
        ),
        childWhenDragging: Container(),
        onDragEnd: (drag) {
          setState(() {
            var _top = drag.offset.dy - yOff;
            var _left = drag.offset.dx - xOff;
            if (widget.axis == Axis.vertical) {
              if (_top < DraggableIconConfig.kMinTop) {
                top = DraggableIconConfig.kMinTop;
              } else if (_top >
                  (heightWithoutStatusToolbar - DraggableIconConfig.kMinTop)) {
                top = heightWithoutStatusToolbar - DraggableIconConfig.kMinTop;
              } else {
                top = _top;
              }
            } else {
              top = _top;
              if (_left < DraggableIconConfig.kMinLeft) {
                left = DraggableIconConfig.kMinLeft;
              } else if (_left > (widthScreen - DraggableIconConfig.kMinLeft)) {
                left = widthScreen - DraggableIconConfig.kMinLeft;
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
