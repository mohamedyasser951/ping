import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/features/Chats/data/models/drawing_point.dart';
part 'real_time_drawing_event.dart';
part 'real_time_drawing_state.dart';

class RealTimeDrawingBloc
    extends Bloc<RealTimeDrawingEvent, RealTimeDrawingState> {
  RealTimeDrawingBloc() : super(const RealTimeDrawingState()) {
    on<RealTimeDrawingStartedEvent>(_onRealTimeDrawingStartedEvent);
    on<RealTimeDrawingUpdatedEvent>(_onRealTimeDrawingEvent);
    on<RealTimeDrawingStoppedEvent>(_onRealTimeDrawingStoppedEvent);
    on<ClearBoardDrawingEvent>(_onClearBoardDrawingEvent);
    on<ChangeSelectedColorEvent>(_onChangeSelectedColorEvent);
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
