import 'package:flutter/material.dart';
import 'package:split/src/draggable_config.dart';
import 'package:split/src/split_widget.dart';

class PostionWidgetInfo {
  Offset position;
  Size size;

  PostionWidgetInfo({
    this.position = Offset.zero,
    this.size = Size.zero,
  });
}

class PositionWidget {
  PostionWidgetInfo top = PostionWidgetInfo();
  PostionWidgetInfo bottom = PostionWidgetInfo();

  PostionWidgetInfo start = PostionWidgetInfo();
  PostionWidgetInfo end = PostionWidgetInfo();

  // Size(DraggableConfig.kTapSize, DraggableConfig.kTapSize)
  PostionWidgetInfo drag = PostionWidgetInfo(
    size: Size.zero,
    position: Offset.zero,
  );

  PostionWidgetInfo getFirst(final Axis axis) {
    if (axis == Axis.vertical) {
      return top;
    }

    return start;
  }

  PostionWidgetInfo getLast(final Axis axis) {
    if (axis == Axis.vertical) {
      return bottom;
    }

    return end;
  }

  void update(
    Size parentSize,
    Offset offsetDrag,
    Size sizeDrag,
    final Axis axis, {
    final double minWidth = 50,
    final double minHeight = 50,
    final double currentWidth = 100,
    final double currentHeight = 100,
  }) {
    if (axis == Axis.vertical) {
      var newDy = offsetDrag == Offset.zero ? currentHeight : offsetDrag.dy;
      if (newDy <= minHeight) {
        newDy = minHeight;
      }

      if (parentSize.height <= (offsetDrag.dy + sizeDrag.height + minHeight)) {
        newDy = parentSize.height - minHeight - sizeDrag.height;
      }

      top.size = Size(parentSize.width, newDy);
      top.position = Offset.zero;

      drag.size = Size(parentSize.width, sizeDrag.height);
      drag.position = Offset(0, newDy);

      bottom.size =
          Size(parentSize.width, parentSize.height - (newDy + sizeDrag.height));
      bottom.position = Offset(0, newDy + sizeDrag.height);
    }

    if (axis == Axis.horizontal) {
      var newDx = offsetDrag == Offset.zero ? currentWidth : offsetDrag.dx;
      if (newDx < minWidth) {
        newDx = minWidth;
      }

      if (newDx + sizeDrag.width >= parentSize.width - minWidth) {
        newDx = parentSize.width - minWidth - sizeDrag.width;
      }

      start.size = Size(newDx, parentSize.height);
      start.position = Offset.zero;

      drag.size = Size(sizeDrag.width, parentSize.height);
      drag.position = Offset(newDx, 0);

      end.size =
          Size(parentSize.width - (newDx + sizeDrag.width), parentSize.height);
      end.position = Offset(newDx + sizeDrag.width, 0);
    }
  }

  void updateV2({
    required Size parentSize,
    required Offset offsetDrag,
    required Size sizeDrag,
    required final Axis axis,
    final DragWidgetConfig dragWidgetConfig = const DragWidgetConfig(),
  }) {
    final sizeDragHeight =
        sizeDrag == Offset.zero ? dragWidgetConfig.heightDrag : sizeDrag.height;
    final sizeDragWidth =
        sizeDrag == Offset.zero ? dragWidgetConfig.heightDrag : sizeDrag.height;

    if (axis == Axis.vertical) {
      var newDy = offsetDrag == Offset.zero ? currentHeight : offsetDrag.dy;
      if (newDy <= minHeight) {
        newDy = minHeight;
      }

      if (parentSize.height <= (offsetDrag.dy + sizeDrag.height + minHeight)) {
        newDy = parentSize.height - minHeight - sizeDrag.height;
      }

      top.size = Size(parentSize.width, newDy);
      top.position = Offset.zero;

      drag.size = Size(parentSize.width, sizeDragHeight);
      drag.position = Offset(0, newDy);

      bottom.size =
          Size(parentSize.width, parentSize.height - (newDy + sizeDrag.height));
      bottom.position = Offset(0, newDy + sizeDrag.height);
    }

    if (axis == Axis.horizontal) {
      var newDx = offsetDrag == Offset.zero ? currentWidth : offsetDrag.dx;
      if (newDx < minWidth) {
        newDx = minWidth;
      }

      if (newDx + sizeDrag.width >= parentSize.width - minWidth) {
        newDx = parentSize.width - minWidth - sizeDrag.width;
      }

      start.size = Size(newDx, parentSize.height);
      start.position = Offset.zero;

      drag.size = Size(sizeDragWidth, parentSize.height);
      drag.position = Offset(newDx, 0);

      end.size =
          Size(parentSize.width - (newDx + sizeDrag.width), parentSize.height);
      end.position = Offset(newDx + sizeDrag.width, 0);
    }
  }
}
