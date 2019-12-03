import 'package:flutter/material.dart';

class PositionedDraggableIcon extends StatefulWidget {
  final double top;
  final double left;
  final Function onChangePosition;
  final Axis axis;
  final Widget childDraggable;
  final Widget childFeedback;

  PositionedDraggableIcon(
      {Key key,
      this.axis: Axis.vertical,
      this.childDraggable,
      this.childFeedback,
      this.top,
      this.left,
      this.onChangePosition})
      : super(key: key);

  @override
  _PositionedDraggableIconState createState() =>
      _PositionedDraggableIconState();

  static final double kTapSize = 20.0;
}

class _PositionedDraggableIconState extends State<PositionedDraggableIcon> {
  static final double _kMinTop = 56.0;
  static final double _kMinLeft = 56.0;

  final GlobalKey _key = GlobalKey();
  double top, left;
  double xOff, yOff;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    top = widget.top;
    left = widget.left;
    super.initState();
  }

  void _getRenderOffsets() {
    final RenderBox renderBoxWidget = _key.currentContext.findRenderObject();
    final offset = renderBoxWidget.localToGlobal(Offset.zero);

    yOff = offset.dy - this.top;
    xOff = offset.dx - this.left;
  }

  void _afterLayout(_) {
    _getRenderOffsets();
  }

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    final double heightScreen = MediaQuery.of(context).size.height;
    final padding = MediaQuery.of(context).padding;
    // height without status and toolbar
    // ignore: unused_local_variable
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
              : PositionedDraggableIcon.kTapSize,
          height: widget.axis == Axis.vertical
              ? PositionedDraggableIcon.kTapSize
              : heightWithoutStatusToolbar,
          child: widget.childDraggable,
        ),
        feedback: Container(
          width: widget.axis == Axis.vertical
              ? widthScreen
              : PositionedDraggableIcon.kTapSize,
          height: widget.axis == Axis.vertical
              ? PositionedDraggableIcon.kTapSize
              : heightWithoutStatusToolbar,
          child: widget.childFeedback,
        ),
        childWhenDragging: Container(),
        onDragEnd: (drag) {
          setState(() {
            var _top = drag.offset.dy - yOff;
            var _left = drag.offset.dx - xOff;
            if (widget.axis == Axis.vertical) {
              if (_top < _kMinTop) {
                top = _kMinTop;
              } else if (_top > (heightWithoutStatusToolbar - _kMinTop)) {
                top = heightWithoutStatusToolbar - _kMinTop;
              } else {
                top = _top;
              }
            } else {
              top = _top;
              if (_left < _kMinLeft) {
                left = _kMinLeft;
              } else if (_left > (widthScreen - _kMinLeft)) {
                left = widthScreen - _kMinLeft;
              } else {
                left = _left;
              }
            }
            if (widget.onChangePosition != null) {
              widget.onChangePosition(top, left);
            }
          });
        },
      ),
    );
  }
}
