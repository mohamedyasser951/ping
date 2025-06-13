part of 'real_time_drawing_bloc.dart';

@immutable
sealed class BoardEvent {
  const BoardEvent();
}

class StartDrawingEvent extends BoardEvent {
  final DrawingPoint drawingPoint;
  const StartDrawingEvent({required this.drawingPoint});
}

class UpdateDrawingEvent extends BoardEvent {
  final DrawingPoint drawingPoint;
  const UpdateDrawingEvent({required this.drawingPoint});
}

class EndDrawingEvent extends BoardEvent {}

class ClearBoardDrawingEvent extends BoardEvent {}

class ChangeSelectedColorEvent extends BoardEvent {
  final Color color;
  const ChangeSelectedColorEvent({required this.color});
}
