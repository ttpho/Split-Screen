import 'package:flutter/material.dart';
import 'package:split/src/draggable_config.dart';
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

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    final double heightScreen = MediaQuery.of(context).size.height;
    final padding = MediaQuery.of(context).padding;
    final double heightWithoutStatusToolbar =
        heightScreen - padding.top - kToolbarHeight;

    if (_topDraggableIcon.value == 0.0) {
      _topDraggableIcon.value =
          (heightWithoutStatusToolbar - DraggableConfig.kTapSize) / 2;
    }

    return ValueListenableBuilder<double>(
      valueListenable: _topDraggableIcon,
      builder: (BuildContext context, double value, Widget? child) {
        return Stack(
          children: <Widget>[
            Positioned(
              child: widget.childTop,
              top: 0,
              left: 0,
              width: widthScreen,
              height: value,
            ),
            Positioned(
              child: widget.childBottom,
              top: value + DraggableConfig.kTapSize,
              left: 0,
              width: widthScreen,
              height: heightWithoutStatusToolbar -
                  (value + DraggableConfig.kTapSize),
            ),
            PositionedDraggableIcon(
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
    );
  }
}
