import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef OnWidgetSizeChange = void Function(Size size);

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
      childWhenDragging: SizedBox(
        height: height,
        width: width,
        child: childWhenDragging,
      ),
      feedback: SizedBox(
        height: height,
        width: width,
        child: feedback,
      ),
      onDragEnd: (drag) {
        final renderBox = context.findRenderObject() as RenderBox?;
        var offset = renderBox?.globalToLocal(drag.offset) ?? Offset.zero;
        onDragEnd(offset);
      },
      child: SizedBox(
        height: height,
        width: width,
        child: child,
      ),
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
              childWhenDragging: Container(color: Colors.black54),
              feedback: Container(color: Colors.black38),
              onDragEnd: (offset) {
                if (offset == null) return;
                setState(() {
                  widget.controller.updateNewOffset(offset);
                });
              },
              dragSize: widget.controller.dragSize,
              child: const DraggableIconWidget(),
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
        child: const Center(
          child: Icon(
            Icons.drag_indicator,
            color: Colors.black54,
          ),
        ),
      );
}
