part of 'real_time_drawing_bloc.dart';

enum RealTimeDrawingStatus { initial }

@immutable
class RealTimeDrawingState {
  final RealTimeDrawingStatus status;
  final List<DrawingPoint?> points;
  final Color selectedColor;

  const RealTimeDrawingState({
    this.status = RealTimeDrawingStatus.initial,
    this.points = const [],
    this.selectedColor = Colors.black,
  });

  RealTimeDrawingState copyWith({
    RealTimeDrawingStatus? status,
    List<DrawingPoint?>? points,
    Color? selectedColor,
  }) =>
      RealTimeDrawingState(
        status: status ?? this.status,
        points: points ?? this.points,
        selectedColor: selectedColor ?? this.selectedColor,
      );

  @override
  int get hashCode =>
      status.hashCode ^ Object.hashAll(points) ^ selectedColor.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RealTimeDrawingState &&
        other.status == status &&
        other.points == points &&
        other.selectedColor == selectedColor;
  }
}
