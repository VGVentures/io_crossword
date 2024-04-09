part of 'drawer_bloc.dart';

sealed class DrawerEvent extends Equatable {
  const DrawerEvent();

  @override
  List<Object> get props => [];
}

class RecordDataRequested extends DrawerEvent {
  const RecordDataRequested();
}
