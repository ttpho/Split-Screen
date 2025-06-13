# Split Screen 
divide screen into two parts in flutter, use draggable flutter to change position Widget and split two views

# Video demo 
[![video demo](https://img.youtube.com/vi/TPiZqJiK0LQ/0.jpg)](https://www.youtube.com/watch?v=TPiZqJiK0LQ)


# AI Solution

Widget: X <-> Y <-> Z , X (top/left), Y is dragging widget and Z (bottom/right) 

### Dragging widget Y left and right to achieve dynamic width for widgets X and Z

```dart
import 'package:flutter/material.dart';

class DynamicWidthRow extends StatefulWidget {
  @override
  _DynamicWidthRowState createState() => _DynamicWidthRowState();
}

class _DynamicWidthRowState extends State<DynamicWidthRow> {
  // Initial flex factors for X and Z
  double _flexX = 1.0;
  double _flexZ = 1.0;

  // This will store the initial drag position relative to the start of Y.
  // Not strictly needed for this basic example, but good for more complex
  // drag behaviors.
  double _initialDragDx = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Width Row'),
      ),
      body: Row(
        children: <Widget>[
          // Widget X
          Expanded(
            flex: (_flexX * 100).toInt(), // Multiply by 100 to work with int flex
            child: Container(
              color: Colors.red,
              child: Center(
                child: Text('X', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          // Widget Y (Draggable handle)
          GestureDetector(
            onHorizontalDragStart: (details) {
              _initialDragDx = details.localPosition.dx;
            },
            onHorizontalDragUpdate: (details) {
              // Calculate the change in horizontal position
              double deltaX = details.delta.dx;

              // Adjust flex factors based on drag.
              // You'll need to fine-tune the sensitivity.
              // Ensure flex factors don't go below a certain minimum (e.g., 0.1)
              // to prevent the widgets from disappearing or having zero width.

              setState(() {
                _flexX = (_flexX + (deltaX / 300)).clamp(0.1, 5.0); // Adjust sensitivity and limits
                _flexZ = (_flexZ - (deltaX / 300)).clamp(0.1, 5.0); // Adjust sensitivity and limits
              });
            },
            child: Container(
              width: 20.0, // Width of the draggable handle
              color: Colors.blue,
              child: Icon(Icons.drag_handle, color: Colors.white),
            ),
          ),
          // Widget Z
          Expanded(
            flex: (_flexZ * 100).toInt(), // Multiply by 100 to work with int flex
            child: Container(
              color: Colors.green,
              child: Center(
                child: Text('Z', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DynamicWidthRow(),
  ));
}
```


### Dragging widget Y up and down changes the dynamic heights of widgets X and Z


```dart 

import 'package:flutter/material.dart';

class DynamicHeightColumn extends StatefulWidget {
  @override
  _DynamicHeightColumnState createState() => _DynamicHeightColumnState();
}

class _DynamicHeightColumnState extends State<DynamicHeightColumn> {
  // Initial flex factors for X and Z for vertical distribution
  double _flexX = 1.0;
  double _flexZ = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Height Column'),
      ),
      body: Column( // Use Column for vertical arrangement
        children: <Widget>[
          // Widget X
          Expanded(
            flex: (_flexX * 100).toInt(), // Multiply by 100 for finer control with int flex
            child: Container(
              color: Colors.purple, // Different color for distinction
              child: Center(
                child: Text('X', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
            ),
          ),
          // Widget Y (Draggable handle)
          GestureDetector(
            onVerticalDragUpdate: (details) { // Use onVerticalDragUpdate for vertical drag
              // Calculate the change in vertical position
              double deltaY = details.delta.dy;

              // Adjust flex factors based on drag.
              // When dragging down (positive deltaY), _flexX increases, _flexZ decreases.
              // When dragging up (negative deltaY), _flexX decreases, _flexZ increases.
              // You'll need to fine-tune the sensitivity.
              // Ensure flex factors don't go below a certain minimum (e.g., 0.1)
              // to prevent the widgets from disappearing or having zero height.

              setState(() {
                _flexX = (_flexX + (deltaY / 300)).clamp(0.1, 5.0); // Adjust sensitivity and limits
                _flexZ = (_flexZ - (deltaY / 300)).clamp(0.1, 5.0); // Adjust sensitivity and limits
              });
            },
            child: Container(
              height: 20.0, // Height of the draggable handle
              color: Colors.orange, // Different color
              child: Center(
                child: Icon(Icons.drag_handle, color: Colors.white), // Drag handle icon
              ),
            ),
          ),
          // Widget Z
          Expanded(
            flex: (_flexZ * 100).toInt(), // Multiply by 100 for finer control with int flex
            child: Container(
              color: Colors.teal, // Different color
              child: Center(
                child: Text('Z', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DynamicHeightColumn(),
  ));
}

```
