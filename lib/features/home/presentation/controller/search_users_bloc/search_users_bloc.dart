import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/features/Chats/data/models/chat_room.dart';
import 'package:ping/features/auth/data/models/user_model.dart';
import 'package:ping/features/home/data/repository/home_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'search_users_event.dart';
part 'search_users_state.dart';

class SearchUsersBloc extends Bloc<SearchUsersEvent, SearchUsersState> {
    final HomeRepository _homeRepository;

  SearchUsersBloc({
    required HomeRepository homeRepository,
  })  : _homeRepository = homeRepository,
        super(const SearchUsersState()) {
    on<SearchUsersEvent>(
      _onSearchUsersEvent,
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 300))
          .switchMap(mapper),
    );
  }


  Future<void> _onSearchUsersEvent(
    SearchUsersEvent event,
    Emitter<SearchUsersState> emit,
  ) async {
    emit(state.copyWith(status: SearchUsersStatus.loading));

    try {
      final users = await _homeRepository.searchUsers(event.query);
      emit(state.copyWith(status: SearchUsersStatus.loaded, users: users));
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchUsersStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
