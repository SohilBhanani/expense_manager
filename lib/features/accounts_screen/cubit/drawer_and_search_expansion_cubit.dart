import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerAndSearchExpansionCubit
    extends Cubit<DrawerAndSearchExpansionState> {
  DrawerAndSearchExpansionCubit() : super(DrawerAndSearchClosed());

  void toggleDrawer({bool? toggle}) {
    if (toggle == null) {
      state is DrawerOpen ? emit(DrawerClose()) : emit(DrawerOpen());
    } else if (toggle) {
      emit(DrawerOpen());
    } else if (!toggle) {
      emit(DrawerClose());
    }
  }

  void toggleSearch({bool? toggle}) {
    if (toggle == null) {
      state is SearchOpen ? emit(SearchClose()) : emit(SearchOpen());
    } else if (toggle) {
      emit(SearchOpen());
    } else if (!toggle) {
      emit(SearchClose());
    }
  }
}

abstract class DrawerAndSearchExpansionState extends Equatable {
  const DrawerAndSearchExpansionState();

  @override
  List<Object> get props => [];
}

class DrawerAndSearchClosed extends DrawerAndSearchExpansionState {}

class DrawerOpen extends DrawerAndSearchExpansionState {}

class DrawerClose extends DrawerAndSearchExpansionState {}

class SearchOpen extends DrawerAndSearchExpansionState {}

class SearchClose extends DrawerAndSearchExpansionState {}
