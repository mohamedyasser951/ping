import 'package:flutter/material.dart';
import 'dart:ui' as ui;


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
          userId: widget.userId,
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
          userId: widget.userId,
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
          userId: widget.userId,
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
              color: Colors.black.withOpacity(0.2),
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

class DrawingPoint {
  final Offset? position;
  final DateTime timestamp;
  final Paint? paint;
  final String userId;

  DrawingPoint({
    required this.position,
    required this.paint,
    required this.userId,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory DrawingPoint.fromMap(Map<String, dynamic> map) {
    return DrawingPoint(
      position: map['x'] == null && map['y'] == null
          ? null
          : Offset(map['x'], map['y']),
      paint: map['color'] == null
          ? null
          : (Paint()
            ..color = Color(map['color'])
            ..isAntiAlias = true
            ..strokeWidth = 5.0
            ..strokeCap = StrokeCap.round),
      userId: map['userId'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'x': position?.dx,
      'y': position?.dy,
      'color': paint?.color.value,
      'userId': userId,
      'timestamp': timestamp.toIso8601String(),
    }..removeWhere((_, v) => v == null);
  }

  @override
  String toString() {
    return 'DrawingPoint(position: $position, paint: $paint, userId: $userId, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DrawingPoint &&
        other.position == position &&
        other.paint == paint &&
        other.userId == userId &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode =>
      position.hashCode ^ paint.hashCode ^ userId.hashCode ^ timestamp.hashCode;
}
