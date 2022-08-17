import 'package:flutter/material.dart';
import 'package:split/src/draggable_config.dart';
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
  double _leftDraggableIcon = 0.0;

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    final double heightScreen = MediaQuery.of(context).size.height;
    final padding = MediaQuery.of(context).padding;
    final double heightWithoutStatusToolbar =
        heightScreen - padding.top - kToolbarHeight;

    if (_leftDraggableIcon == 0.0) {
      _leftDraggableIcon = (widthScreen - DraggableConfig.kTapSize) / 2;
    }

    return Stack(
      children: <Widget>[
        Positioned(
          child: widget.childStart,
          top: 0,
          left: 0,
          width: _leftDraggableIcon,
          height: heightWithoutStatusToolbar,
        ),
        Positioned(
          child: widget.childEnd,
          top: 0,
          left: _leftDraggableIcon + DraggableConfig.kTapSize,
          width: widthScreen - (_leftDraggableIcon + DraggableConfig.kTapSize),
          height: heightWithoutStatusToolbar,
        ),
        PositionedDraggableIcon(
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
    );
  }
}
