import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/core/di/service_locator.dart';
import 'dart:ui' as ui;

import 'package:ping/features/Chats/data/models/drawing_point.dart';
import 'package:ping/features/Chats/presentation/controllers/real_time_drwaing/real_time_drawing_bloc.dart';

class RealTimeDrawingPage extends StatefulWidget {
  const RealTimeDrawingPage({
    super.key,
    required this.roomId,
    required this.userId,
  });

  final String roomId;
  final String userId;

  @override
  State<RealTimeDrawingPage> createState() => _RealTimeDrawingPageState();
}

class _RealTimeDrawingPageState extends State<RealTimeDrawingPage> {
  // List<DrawingPoint?> _points = [];
  // Color _selectedColor = Colors.black;

  // // void _clearBoard() {
  // //   setState(() {
  // //     _points = [];
  // //   });
  // // }

  // void _startDrawing(Offset position) {
  //   setState(() {
  //     _points.add(
  //       DrawingPoint(
  //         position: position,
  //         paint: Paint()
  //           ..color = _selectedColor
  //           ..isAntiAlias = true
  //           ..strokeWidth = 5.0
  //           ..strokeCap = StrokeCap.round,
  //       ),
  //     );
  //   });
  // }

  // void _updateDrawing(Offset position) {
  //   setState(() {
  //     _points.add(
  //       DrawingPoint(
  //         position: position,
  //         paint: Paint()
  //           ..color = _selectedColor
  //           ..isAntiAlias = true
  //           ..strokeWidth = 5.0
  //           ..strokeCap = StrokeCap.round,
  //       ),
  //     );
  //   });
  // }

  // void _stopDrawing() {
  //   setState(() {
  //     _points.add(
  //       DrawingPoint(
  //         position: null,
  //         paint: null,
  //       ),
  //     );
  //   });
  // }

  // void _changeColor(Color color) {
  //   setState(() {
  //     _selectedColor = color;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RealTimeDrawingBloc>(),
      child: Builder(builder: (context) {
        RealTimeDrawingBloc drawingBloc = context.read<RealTimeDrawingBloc>();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Drawing Board'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => drawingBloc.add(ClearBoardDrawingEvent()),
              ),
            ],
          ),
          body: Stack(
            children: [
              BlocSelector<RealTimeDrawingBloc, RealTimeDrawingState, Color>(
                selector: (state) {
                  return state.selectedColor;
                },
                builder: (context, selectedColor) {
                  return GestureDetector(
                    onPanStart: (details) =>
                        drawingBloc.add(RealTimeDrawingStartedEvent(
                      drawingPoint: DrawingPoint(
                        position: details.localPosition,
                        paint: Paint()
                          ..color = selectedColor
                          ..isAntiAlias = true
                          ..strokeWidth = 5.0
                          ..strokeCap = StrokeCap.round,
                      ),
                    )),
                    onPanUpdate: (details) =>
                        drawingBloc.add(RealTimeDrawingUpdatedEvent(
                      drawingPoint: DrawingPoint(
                        position: details.localPosition,
                        paint: Paint()
                          ..color = selectedColor
                          ..isAntiAlias = true
                          ..strokeWidth = 5.0
                          ..strokeCap = StrokeCap.round,
                      ),
                    )),
                    onPanEnd: (details) =>
                        drawingBloc.add(RealTimeDrawingStoppedEvent()),
                    child: BlocSelector<RealTimeDrawingBloc,
                        RealTimeDrawingState, List<DrawingPoint?>>(
                      selector: (state) {
                        return state.points;
                      },
                      builder: (context, points) {
                        return CustomPaint(
                          painter: _DrawingPainter(points),
                          size: Size.infinite,
                        );
                      },
                    ),
                  );
                },
              ),
              _buildColorPalette(drawingBloc),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildColorPalette(RealTimeDrawingBloc drawingBloc) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: SafeArea(
          child: BlocSelector<RealTimeDrawingBloc, RealTimeDrawingState, Color>(
            selector: (state) {
              return state.selectedColor;
            },
            builder: (context, selectedColor) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Colors.black,
                  Colors.red,
                  Colors.green,
                  Colors.blue,
                  Colors.yellow,
                  Colors.purple,
                  Colors.orange,
                ]
                    .map(
                      (color) => _ColorChoice(
                        color: color,
                        isSelected: color == selectedColor,
                        onSelect: (color) => drawingBloc.add(
                          ChangeSelectedColorEvent(color: color),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ColorChoice extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final ValueChanged<Color> onSelect;

  const _ColorChoice({
    required this.color,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(color),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 5,
            )
          ],
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> points;

  _DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i]?.position != null && points[i + 1]?.position != null) {
        canvas.drawLine(
          points[i]!.position!,
          points[i + 1]!.position!,
          points[i]!.paint!,
        );
      } else if (points[i]?.position != null &&
          points[i + 1]?.position == null) {
        canvas.drawPoints(
          ui.PointMode.points,
          [points[i]!.position!],
          points[i]!.paint!,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) => true;
}
