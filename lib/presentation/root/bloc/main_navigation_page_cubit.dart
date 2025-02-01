import 'package:flutter_bloc/flutter_bloc.dart';

enum MainNavigationPageState {
  home,
  history,
  wallet,
  other,
  add,
}

class MainNavigationCubit extends Cubit<MainNavigationPageState> {
  MainNavigationCubit() : super(MainNavigationPageState.home);
  void updateIndex(MainNavigationPageState state) => emit(state);
}