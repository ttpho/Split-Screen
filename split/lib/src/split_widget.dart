import 'package:flutter/material.dart';
import 'package:split/src/measure_size_render_object.dart';
import 'package:split/src/postion_widget.dart';

class SplitWidget extends StatefulWidget {
  final Widget firstChild;
  final Widget lastChild;
  final Axis axis;
  final DragItemConfig? itemDefault;
  final DragItemConfig? itemDragging;
  final DragItemConfig? itemFeedback;

  const SplitWidget({
    Key? key,
    required this.firstChild,
    required this.lastChild,
    required this.axis,
    this.itemDefault,
    this.itemDragging,
    this.itemFeedback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplitWidgetState();
}

class _SplitWidgetState extends State<SplitWidget> {
  Size parentSize = Size.zero;
  final PositionWidget postionWidget = PositionWidget();
  final DragWidgetConfig dragWidgetConfigDefault = DragWidgetConfig();

  void _updateNewState(final Offset dragOffset) {
    postionWidget.update(
      parentSize,
      dragOffset,
      postionWidget.drag.size,
      widget.axis,
    );
  }

  @override
  Widget build(BuildContext context) {
    final axis = widget.axis;
    return MeasureSizeWidget(
      onChange: (Size newSize) {
        setState(() {
          parentSize = newSize;
          _updateNewState(Offset.zero);
        });
      },
      child: Stack(
        children: [
          Positioned(
            left: postionWidget.drag.position.dx,
            top: postionWidget.drag.position.dy,
            child: DragWidget(
              axis: axis,
              dragSize: postionWidget.drag.size,
              child: DraggableIconWidget(
                config: widget.itemDefault,
              ),
              childWhenDragging: DraggableIconWidget(
                config: widget.itemDragging,
              ),
              feedback: DraggableIconWidget(
                config: widget.itemFeedback,
              ),
              onDragEnd: (offset) {
                if (offset != null) {
                  setState(() {
                    final currentOffset = postionWidget.drag.position + offset;
                    _updateNewState(currentOffset);
                  });
                }
              },
            ),
          ),
          Positioned(
            left: postionWidget.getFirst(axis).position.dx,
            top: postionWidget.getFirst(axis).position.dy,
            width: postionWidget.getFirst(axis).size.width,
            height: postionWidget.getFirst(axis).size.height,
            child: widget.firstChild,
          ),
          Positioned(
            left: postionWidget.getLast(axis).position.dx,
            top: postionWidget.getLast(axis).position.dy,
            width: postionWidget.getLast(axis).size.width,
            height: postionWidget.getLast(axis).size.height,
            child: widget.lastChild,
          ),
        ],
      ),
    );
  }
}

class DragWidgetConfig {
  final double widthDrag;
  final double heightDrag;
  final double minTopDrag;
  final double minLeftDrag;
  final double minTopVisibleDrag;
  final double minLeftVisibleDrag;

  DragWidgetConfig({
    this.widthDrag = 56.0,
    this.heightDrag = 56.0,
    this.minTopDrag = 56.0,
    this.minLeftDrag = 56.0,
    this.minTopVisibleDrag = 280.0,
    this.minLeftVisibleDrag = 280.0,
  });
}

class DragItemConfig {
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;

  DragItemConfig({
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
  });
}

class DraggableIconWidget extends StatelessWidget {
  final DragItemConfig? config;

  const DraggableIconWidget({
    Key? key,
    required this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => config == null
      ? Container()
      : Container(
          color: config?.backgroundColor ?? Colors.transparent,
          child: Center(
            child: Icon(
              config?.icon ?? Icons.drag_handle,
              color: config?.iconColor ?? Colors.transparent,
            ),
          ),
        );
}

class DragWidget extends StatelessWidget {
  final void Function(
    Offset? offset,
  ) onDragEnd;

  final Size dragSize;
  final Axis axis;

  final Widget? child;
  final Widget? feedback;
  final Widget? childWhenDragging;

  const DragWidget({
    Key? key,
    required this.onDragEnd,
    required this.dragSize,
    required this.axis,
    this.child,
    this.feedback,
    this.childWhenDragging,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = dragSize.width;
    double height = dragSize.height;
    return Draggable(
      child: Container(
        height: height,
        width: width,
        child: child,
      ),
      childWhenDragging: Container(
        height: height,
        width: width,
        child: childWhenDragging,
      ),
      feedback: Container(
        height: height,
        width: width,
        child: feedback,
      ),
      onDragEnd: (drag) {
        final renderBox = context.findRenderObject() as RenderBox?;
        var offset = renderBox?.globalToLocal(drag.offset) ?? Offset.zero;
        onDragEnd(offset);
      },
    );
  }
}
