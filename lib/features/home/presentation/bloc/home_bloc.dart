import 'package:bloc/bloc.dart';
import 'package:usfx_asistencia_docentes_movil/features/home/presentation/bloc/home_event.dart';
import 'package:usfx_asistencia_docentes_movil/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {});
  }
}

class HomeInitial extends HomeState {}
