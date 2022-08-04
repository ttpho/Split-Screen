import 'package:flutter/material.dart';
import 'package:split/draggable_icon_config.dart';

import 'positioned_draggable_icon.dart';

class SplitWidget extends StatefulWidget {
  SplitWidget({
    Key? key,
    required this.childFirst,
    required this.childSecond,
  }) : super(key: key);
  final Widget childFirst;
  final Widget childSecond;

  @override
  _SplitWidget createState() => _SplitWidget();
}

class _SplitWidget extends State<SplitWidget> {
  @override
  Widget build(BuildContext context) =>
      OrientationBuilder(builder: (context, orientation) {
        return (orientation == Orientation.portrait)
            ? SplitVerticalWidget(
                childTop: widget.childFirst,
                childBottom: widget.childSecond,
              )
            : SplitHorizontalWidget(
                childStart: widget.childFirst,
                childEnd: widget.childSecond,
              );
      });
}

class SplitVerticalWidget extends StatefulWidget {
  SplitVerticalWidget({Key? key, this.childTop, this.childBottom})
      : super(key: key);
  final Widget? childTop;
  final Widget? childBottom;

  @override
  _SplitVerticalWidget createState() => _SplitVerticalWidget();
}

class _SplitVerticalWidget extends State<SplitVerticalWidget> {
  double _topDraggableIcon = 0.0;

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    final double heightScreen = MediaQuery.of(context).size.height;
    final padding = MediaQuery.of(context).padding;
    final double heightWithoutStatusToolbar =
        heightScreen - padding.top - kToolbarHeight;

    if (_topDraggableIcon == 0.0) {
      _topDraggableIcon =
          (heightWithoutStatusToolbar - DraggableIconConfig.kTapSize) / 2;
    }

    return Stack(
      children: <Widget>[
        Positioned(
          child: widget.childTop!,
          top: 0,
          left: 0,
          width: widthScreen,
          height: _topDraggableIcon,
        ),
        Positioned(
          child: widget.childBottom!,
          top: _topDraggableIcon + DraggableIconConfig.kTapSize,
          left: 0,
          width: widthScreen,
          height: heightWithoutStatusToolbar -
              (_topDraggableIcon + DraggableIconConfig.kTapSize),
        ),
        PositionedDraggableIcon(
          left: 0,
          top: _topDraggableIcon,
          draggable: DraggableIconConfig(
            backgroundColor: Colors.black12,
            icon: Icons.more_horiz,
            iconColor: Colors.white,
          ),
          feedback: DraggableIconConfig(
            backgroundColor: Colors.black,
            icon: Icons.more_horiz,
            iconColor: Colors.white,
          ),
          axis: Axis.vertical,
          onChangePosition: (top, left) {
            setState(() {
              _topDraggableIcon = top;
            });
          },
        ),
      ],
    );
  }
}

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
      _leftDraggableIcon = (widthScreen - DraggableIconConfig.kTapSize) / 2;
    }

    return Stack(children: <Widget>[
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
        left: _leftDraggableIcon + DraggableIconConfig.kTapSize,
        width:
            widthScreen - (_leftDraggableIcon + DraggableIconConfig.kTapSize),
        height: heightWithoutStatusToolbar,
      ),
      PositionedDraggableIcon(
        top: 0,
        left: _leftDraggableIcon,
        draggable: DraggableIconConfig(
          backgroundColor: Colors.black12,
          icon: Icons.more_vert,
          iconColor: Colors.white,
        ),
        feedback: DraggableIconConfig(
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
    ]);
  }

  _childViewDragging(final Color color) => Container(
        color: color,
        child: Center(
          child: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
        ),
      );
}
