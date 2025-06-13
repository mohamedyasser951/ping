import 'dart:ui';


class DrawingPoint {
  final Offset? position;
  final Paint? paint;

  DrawingPoint({
    required this.position,
    required this.paint,
  });

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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'x': position?.dx,
      'y': position?.dy,
      'color': paint?.color.value,
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
