import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';

enum DrawMode { freeDraw, rectangle, circle, triangle }

class Shape {
  final DrawMode drawMode;
  final Offset start;
  final Offset end;
  final Color color;
  final List<Offset>? points; // For freeDraw mode

  Shape({
    required this.drawMode,
    this.start = Offset.zero,
    required this.color,
    this.end = Offset.zero,
    this.points,
  });
}

class WhiteBoardView extends StatefulWidget {
  const WhiteBoardView({super.key});

  @override
  WhiteBoardViewState createState() => WhiteBoardViewState();
}

class WhiteBoardViewState extends State<WhiteBoardView> {
  List<Offset?> _points = [];
  final List<Shape> _shapes = [];
  DrawMode _drawMode = DrawMode.freeDraw;
  Offset? _startPoint;
  final List<Shape> _undoneShapes = [];
  Color _selectedColor = Colors.black; // Default color

  final List<Color> _colors = [
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];
  @override
  Widget build(BuildContext context) {
    void undo() {
      if (_shapes.isNotEmpty) {
        setState(() {
          _undoneShapes.add(_shapes.removeLast());
        });
      }
    }

    void redo() {
      print('test');
      if (_undoneShapes.isNotEmpty) {
        setState(() {
          _shapes.add(_undoneShapes.removeLast());
        });
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // centerTitle: true,
          title: const Text(
            'Whiteboard',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: undo,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.undo,
                    color: Colors.white,
                    size: 40.zH,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: redo,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.redo,
                    color: Colors.white,
                    size: 40.zH,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: GestureDetector(
          onPanStart: (details) {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            _startPoint = renderBox.globalToLocal(details.globalPosition);
            if (_drawMode == DrawMode.freeDraw) {
              _points.add(_startPoint);
            }
          },
          onPanUpdate: (details) {
            setState(() {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              Offset localPosition =
                  renderBox.globalToLocal(details.globalPosition);
              if (_drawMode == DrawMode.freeDraw) {
                _points.add(localPosition);
              } else {
                _points = [_startPoint, localPosition];
              }
            });
          },
          onPanEnd: (details) {
            setState(() {
              if (_drawMode == DrawMode.freeDraw) {
                // Save free draw points
                _shapes.add(Shape(
                  drawMode: DrawMode.freeDraw,
                  points: List.from(_points),
                  color: _selectedColor,
                ));
                _points.clear(); // Clear points after saving
              } else if (_startPoint != null && _points.isNotEmpty) {
                // Save the shape
                _shapes.add(Shape(
                  drawMode: _drawMode,
                  start: _startPoint!,
                  end: _points.last!,
                  color: _selectedColor,
                ));
                _points.clear(); // Clear points after saving the shape
              }
              // Clear the redo list as we have drawn a new shape
              _undoneShapes.clear();
            });
          },
          child: CustomPaint(
            painter: WhiteboardPainter(_points, _drawMode, _shapes),
            size: Size.infinite,
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
              bottom: 120.0.zR), // Adds 20 pixels of space below the bottom bar
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 40.0,
                padding: EdgeInsets.all(5.zR),
                margin: EdgeInsets.all(5.zR),
                decoration: BoxDecoration(
                    border: Border.all(color: _selectedColor, width: 5.zR),
                    borderRadius: BorderRadius.circular(20.zR)),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _colors.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = _colors[index];
                        });
                      },
                      child: Container(
                        width: 50.zR,
                        height: 50.zR,
                        margin: EdgeInsets.symmetric(horizontal: 5.zW),
                        decoration: BoxDecoration(
                          color: _colors[index],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _selectedColor == _colors[index]
                                ? Colors.black
                                : Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.brush),
                      onPressed: () {
                        setState(() {
                          _drawMode = DrawMode.freeDraw;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.crop_square),
                      onPressed: () {
                        setState(() {
                          _drawMode = DrawMode.rectangle;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.circle),
                      onPressed: () {
                        setState(() {
                          _drawMode = DrawMode.circle;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.change_history),
                      onPressed: () {
                        setState(() {
                          _drawMode = DrawMode.triangle;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _points.clear(); // Clear the board
                          _shapes.clear();
                          _undoneShapes.clear();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WhiteboardPainter extends CustomPainter {
  final List<Offset?> points;
  final DrawMode drawMode;
  final List<Shape> shapes;

  WhiteboardPainter(this.points, this.drawMode, this.shapes);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black // Border color
      ..style = PaintingStyle.stroke // Stroke instead of fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    // Draw saved shapes and free draw lines
    for (Shape shape in shapes) {
      paint.color = shape.color; // Use the shape's color
      if (shape.drawMode == DrawMode.freeDraw) {
        drawFreeDraw(canvas, shape.points!, paint);
      } else {
        drawShape(canvas, shape.start, shape.end, shape.drawMode, paint);
      }
    }

    // Draw the shape currently being drawn
    if (drawMode != DrawMode.freeDraw &&
        points.isNotEmpty &&
        points.length == 2) {
      paint.color = shapes.isNotEmpty ? shapes.last.color : Colors.black;
      Offset start = points.first!;
      Offset end = points.last!;
      drawShape(canvas, start, end, drawMode, paint);
    }

    // Draw free draw lines in progress
    if (drawMode == DrawMode.freeDraw) {
      drawFreeDraw(canvas, points, paint);
    }
  }

  void drawShape(
      Canvas canvas, Offset start, Offset end, DrawMode drawMode, Paint paint) {
    switch (drawMode) {
      case DrawMode.rectangle:
        canvas.drawRect(Rect.fromPoints(start, end), paint);
        break;
      case DrawMode.circle:
        double radius = (end - start).distance / 2;
        canvas.drawCircle(
            Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2),
            radius,
            paint);
        break;
      case DrawMode.triangle:
        drawTriangle(canvas, paint, start, end);
        break;
      default:
        break;
    }
  }

  void drawFreeDraw(Canvas canvas, List<Offset?> points, Paint paint) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [points[i]!], paint);
      }
    }
  }

  void drawTriangle(Canvas canvas, Paint paint, Offset start, Offset end) {
    double midX = (start.dx + end.dx) / 2;
    Path path = Path()
      ..moveTo(midX, start.dy)
      ..lineTo(end.dx, end.dy)
      ..lineTo(start.dx, end.dy)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
