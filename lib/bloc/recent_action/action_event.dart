import 'package:equatable/equatable.dart';

abstract class ActionEvent extends Equatable{
  const ActionEvent();
}


class GetRecentActionsEvent extends ActionEvent{
  const GetRecentActionsEvent();
  @override
  List<Object> get props => [];
}

