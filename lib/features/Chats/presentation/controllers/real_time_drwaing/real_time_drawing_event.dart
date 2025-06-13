part of 'real_time_drawing_bloc.dart';

@immutable
sealed class RealTimeDrawingEvent {
  const RealTimeDrawingEvent();
}

class RealTimeDrawingStartedEvent extends RealTimeDrawingEvent {
  final DrawingPoint drawingPoint;
  const RealTimeDrawingStartedEvent({required this.drawingPoint});
}

class RealTimeDrawingUpdatedEvent extends RealTimeDrawingEvent {
  final DrawingPoint drawingPoint;
  const RealTimeDrawingUpdatedEvent({required this.drawingPoint});
}

class RealTimeDrawingStoppedEvent extends RealTimeDrawingEvent {}

class ClearBoardDrawingEvent extends RealTimeDrawingEvent {}

class ChangeSelectedColorEvent extends RealTimeDrawingEvent {
  final Color color;
  const ChangeSelectedColorEvent({required this.color});
}
