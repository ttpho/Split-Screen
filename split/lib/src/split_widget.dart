import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef void OnWidgetSizeChange(Size size);

class MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  final OnWidgetSizeChange onChange;

  MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = child!.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class MeasureSizeWidget extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const MeasureSizeWidget({
    Key? key,
    required this.onChange,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }
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

class SplitWidgetController {
  Axis axis;
  Offset offsetDrag = Offset.zero;
  Size parentSize = Size.zero;

  SplitWidgetController(this.axis);

  void updateNewParentSize(Size size) {
    parentSize = size;
    if (axis == Axis.horizontal) {
      offsetDrag = Offset(initHorizontalX, 0);
    }
    if (axis == Axis.vertical) {
      offsetDrag = Offset(0, initVerticalX);
    }
  }

  void updateNewOffset(Offset offset) {
    offsetDrag = offsetDrag + offset;

    if (axis == Axis.horizontal) {
      if (offsetDrag.dx <= minHorizontalX) {
        offsetDrag = Offset(minHorizontalX, 0);
      }
      if (offsetDrag.dx + dragSize.width >= parentSize.width - minHorizontalX) {
        offsetDrag = Offset(parentSize.width - minHorizontalX, 0);
      }

      offsetDrag = Offset(offsetDrag.dx, 0);
    }

    if (axis == Axis.vertical) {
      if (offsetDrag.dy <= minVerticalY) {
        offsetDrag = Offset(0, minVerticalY);
      }

      if (offsetDrag.dy + dragSize.height >= parentSize.height - minVerticalY) {
        offsetDrag = Offset(0, parentSize.height - minVerticalY);
      }

      offsetDrag = Offset(0, offsetDrag.dy);
    }
  }

  double get minHorizontalX => 48;

  double get initHorizontalX => parentSize.width / 2;

  double get minVerticalY => 48;

  double get initVerticalX => parentSize.height / 2;

  Size get dragSize {
    if (axis == Axis.horizontal) {
      return Size(48, parentSize.height);
    }

    if (axis == Axis.vertical) {
      return Size(parentSize.width, 48);
    }

    return Size.zero;
  }

  double get widthFirstChild {
    if (axis == Axis.horizontal) {
      return offsetDrag.dx;
    }

    if (axis == Axis.vertical) {
      return parentSize.width;
    }

    return 0;
  }

  double get heightFirstChild {
    if (axis == Axis.horizontal) {
      return parentSize.height;
    }

    if (axis == Axis.vertical) {
      return offsetDrag.dy;
    }

    return 0;
  }

  double get topLastChild {
    if (axis == Axis.horizontal) {
      return 0;
    }

    if (axis == Axis.vertical) {
      return offsetDrag.dy + dragSize.height;
    }

    return 0;
  }

  double get leftLastChild {
    if (axis == Axis.horizontal) {
      return offsetDrag.dx + dragSize.width;
    }

    if (axis == Axis.vertical) {
      return 0;
    }

    return 0;
  }

  double get widthLastChild {
    if (axis == Axis.horizontal) {
      return parentSize.width - (offsetDrag.dx + dragSize.width);
    }

    if (axis == Axis.vertical) {
      return parentSize.width;
    }

    return 0;
  }

  double get heightLastChild {
    if (axis == Axis.horizontal) {
      return parentSize.height;
    }

    if (axis == Axis.vertical) {
      return parentSize.height - (offsetDrag.dy + dragSize.height);
    }

    return 0;
  }
}

class SplitWidget extends StatefulWidget {
  final Widget firstChild;
  final Widget lastChild;
  final SplitWidgetController controller;

  const SplitWidget({
    Key? key,
    required this.firstChild,
    required this.lastChild,
    required this.controller,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplitWidgetSate();
}

class _SplitWidgetSate extends State<SplitWidget> {
  @override
  Widget build(BuildContext context) {
    return MeasureSizeWidget(
      onChange: (Size size) {
        setState(() {
          widget.controller.updateNewParentSize(size);
        });
      },
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            width: widget.controller.widthFirstChild,
            height: widget.controller.heightFirstChild,
            child: widget.firstChild,
          ),
          Positioned(
            top: widget.controller.offsetDrag.dy,
            left: widget.controller.offsetDrag.dx,
            width: widget.controller.dragSize.width,
            height: widget.controller.dragSize.height,
            child: DragWidget(
              axis: widget.controller.axis,
              child: DraggableIconWidget(),
              childWhenDragging: Container(color: Colors.black54),
              feedback: Container(color: Colors.black38),
              onDragEnd: (offset) {
                if (offset == null) return;
                setState(() {
                  widget.controller.updateNewOffset(offset);
                });
              },
              dragSize: widget.controller.dragSize,
            ),
          ),
          Positioned(
            top: widget.controller.topLastChild,
            left: widget.controller.leftLastChild,
            width: widget.controller.widthLastChild,
            height: widget.controller.heightLastChild,
            child: widget.lastChild,
          ),
        ],
      ),
    );
  }
}

class DraggableIconWidget extends StatelessWidget {
  const DraggableIconWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        child: Center(
          child: Icon(
            Icons.drag_indicator,
            color: Colors.black54,
          ),
        ),
      );
}

/*

class SplitWidget extends StatefulWidget {
  final Widget firstChild;
  final Widget lastChild;
  final Axis axis;
  final DragItemConfig? itemDefault;
  final DragItemConfig? itemDragging;
  final DragItemConfig? itemFeedback;
  final DragWidgetConfig? dragWidgetConfig;

  const SplitWidget({
    Key? key,
    required this.firstChild,
    required this.lastChild,
    required this.axis,
    this.itemDefault,
    this.itemDragging,
    this.itemFeedback,
    this.dragWidgetConfig,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplitWidgetState();
}

class _SplitWidgetState extends State<SplitWidget> {
  Size parentSize = Size.zero;
  final PositionWidget postionWidget = PositionWidget();

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
              axis: widget.axis,
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
            left: postionWidget.getFirst(widget.axis).position.dx,
            top: postionWidget.getFirst(widget.axis).position.dy,
            width: postionWidget.getFirst(widget.axis).size.width,
            height: postionWidget.getFirst(widget.axis).size.height,
            child: widget.firstChild,
          ),
          Positioned(
            left: postionWidget.getLast(widget.axis).position.dx,
            top: postionWidget.getLast(widget.axis).position.dy,
            width: postionWidget.getLast(widget.axis).size.width,
            height: postionWidget.getLast(widget.axis).size.height,
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

  const DragWidgetConfig({
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



*/
