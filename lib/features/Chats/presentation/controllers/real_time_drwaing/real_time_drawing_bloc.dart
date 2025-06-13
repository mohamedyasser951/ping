import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/features/Chats/data/models/drawing_point.dart';
import 'package:rxdart/rxdart.dart';
part 'real_time_drawing_event.dart';
part 'real_time_drawing_state.dart';

class RealTimeDrawingBloc extends Bloc<BoardEvent, RealTimeDrawingState> {
  RealTimeDrawingBloc() : super(const RealTimeDrawingState()) {
    on<StartDrawingEvent>(_onRealTimeDrawingStartedEvent);
    on<UpdateDrawingEvent>(_onRealTimeDrawingEvent,
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
            }).switchMap(mapper));
    on<EndDrawingEvent>(_onRealTimeDrawingStoppedEvent);
    on<ClearBoardDrawingEvent>(_onClearBoardDrawingEvent);
    on<ChangeSelectedColorEvent>(_onChangeSelectedColorEvent);
  }
  double _calculateDistance(Offset? p1, Offset? p2) {
    if (p1 == null || p2 == null) return 0;
    return (p1 - p2).distance;
  }

  void _onRealTimeDrawingStartedEvent(
      StartDrawingEvent event, Emitter<RealTimeDrawingState> emit) {
    final DrawingPoint newPoints = event.drawingPoint;
    emit(state.copyWith(points: [...state.points, newPoints]));
  }

  void _onRealTimeDrawingEvent(
      UpdateDrawingEvent event, Emitter<RealTimeDrawingState> emit) {
    final DrawingPoint newPoints = event.drawingPoint;
    emit(state.copyWith(points: [...state.points, newPoints]));
  }

  void _onRealTimeDrawingStoppedEvent(
      EndDrawingEvent event, Emitter<RealTimeDrawingState> emit) {
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
