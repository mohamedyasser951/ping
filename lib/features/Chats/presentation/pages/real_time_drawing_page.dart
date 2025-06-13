import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:ping/features/Chats/data/models/drawing_point.dart';

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
  List<DrawingPoint?> _points = [];
  Color _selectedColor = Colors.black;

  void _clearBoard() {
    setState(() {
      _points = [];
    });
  }

  void _startDrawing(Offset position) {
    setState(() {
      _points.add(
        DrawingPoint(
          position: position,
          paint: Paint()
            ..color = _selectedColor
            ..isAntiAlias = true
            ..strokeWidth = 5.0
            ..strokeCap = StrokeCap.round,
        ),
      );
    });
  }

  void _updateDrawing(Offset position) {
    setState(() {
      _points.add(
        DrawingPoint(
          position: position,
          paint: Paint()
            ..color = _selectedColor
            ..isAntiAlias = true
            ..strokeWidth = 5.0
            ..strokeCap = StrokeCap.round,
        ),
      );
    });
  }

  void _stopDrawing() {
    setState(() {
      _points.add(
        DrawingPoint(
          position: null,
          paint: null,
        ),
      );
    });
  }

  void _changeColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawing Board'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearBoard,
          ),
        ],
      ),
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: (details) => _startDrawing(details.localPosition),
            onPanUpdate: (details) => _updateDrawing(details.localPosition),
            onPanEnd: (details) => _stopDrawing(),
            child: CustomPaint(
              painter: _DrawingPainter(_points),
              size: Size.infinite,
            ),
          ),
          _buildColorPalette(),
        ],
      ),
    );
  }

  Widget _buildColorPalette() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: SafeArea(
          child: Row(
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
                    isSelected: color == _selectedColor,
                    onSelect: _changeColor,
                  ),
                )
                .toList(),
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

