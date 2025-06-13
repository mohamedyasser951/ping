import 'dart:ui';

class DrawingPoint {
  final Offset? position;
  final Paint? paint;
  final DateTime timestamp;

  DrawingPoint({
    required this.position,
    required this.paint,
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
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
        'x': position?.dx,
      'y': position?.dy,
      'color': paint?.color.value,
      'timestamp': timestamp.toIso8601String(),
    }..removeWhere((_, v) => v == null);
  }

  @override
  String toString() {
    return 'DrawingPoint(position: $position, paint: $paint,)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DrawingPoint &&
        other.position == position &&
        other.paint == paint;
  }

  @override
  int get hashCode => position.hashCode ^ paint.hashCode;
}
