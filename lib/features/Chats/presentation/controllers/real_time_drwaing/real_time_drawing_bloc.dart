import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/features/Chats/data/models/drawing_point.dart';
part 'real_time_drawing_event.dart';
part 'real_time_drawing_state.dart';

class RealTimeDrawingBloc
    extends Bloc<RealTimeDrawingEvent, RealTimeDrawingState> {
  RealTimeDrawingBloc() : super(const RealTimeDrawingState()) {
    on<RealTimeDrawingStartedEvent>(_onRealTimeDrawingStartedEvent);
    on<RealTimeDrawingUpdatedEvent>(_onRealTimeDrawingEvent,
        transformer: (events, mapper) => events.where((event) {
              DrawingPoint? lastPoint =
                  state.points.isNotEmpty && state.points.last != null
                      ? state.points.last!
                      : null;

              if (lastPoint == null) return true;

              double distance = _calculateDistance(
                  lastPoint.position, event.drawingPoint.position);

              bool isValidDistance = distance >= 5;
              bool isValidTime = event.drawingPoint.timestamp
                      .difference(lastPoint.timestamp)
                      .inMilliseconds <
                  10;

              return isValidDistance || isValidTime;
            }));
    on<RealTimeDrawingStoppedEvent>(_onRealTimeDrawingStoppedEvent);
    on<ClearBoardDrawingEvent>(_onClearBoardDrawingEvent);
    on<ChangeSelectedColorEvent>(_onChangeSelectedColorEvent);
  }
  double _calculateDistance(Offset? p1, Offset? p2) {
    if (p1 == null || p2 == null) return 0;
    return (p1 - p2).distance;
  }

  void _onRealTimeDrawingStartedEvent(
      RealTimeDrawingStartedEvent event, Emitter<RealTimeDrawingState> emit) {
    final DrawingPoint newPoints = event.drawingPoint;
    emit(state.copyWith(points: [...state.points, newPoints]));
  }

  void _onRealTimeDrawingEvent(
      RealTimeDrawingUpdatedEvent event, Emitter<RealTimeDrawingState> emit) {
    final DrawingPoint newPoints = event.drawingPoint;
    emit(state.copyWith(points: [...state.points, newPoints]));
  }

  void _onRealTimeDrawingStoppedEvent(
      RealTimeDrawingStoppedEvent event, Emitter<RealTimeDrawingState> emit) {
    emit(state.copyWith(points: [...state.points, null]));
  }

  void _onClearBoardDrawingEvent(
      ClearBoardDrawingEvent event, Emitter<RealTimeDrawingState> emit) {
    emit(state.copyWith(points: []));
  }

  void _onChangeSelectedColorEvent(
      ChangeSelectedColorEvent event, Emitter<RealTimeDrawingState> emit) {
    emit(state.copyWith(selectedColor: event.color));
  }
}
