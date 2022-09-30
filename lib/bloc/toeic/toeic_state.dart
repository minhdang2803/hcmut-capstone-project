part of 'toeic_cubit.dart';

abstract class ToeicState extends Equatable {
  const ToeicState();
}

class ToeicInitial extends ToeicState {
  @override
  List<Object> get props => [];
}

class ToeicLoading extends ToeicState {
  @override
  List<Object> get props => [];
}

class ToeicSuccess extends ToeicState {
  const ToeicSuccess(this.toeic);

  final ToeicTest? toeic;

  @override
  List<Object?> get props => [toeic];
}

class ToeicFailure extends ToeicState {
  const ToeicFailure(this.errorMessage, {this.errorCode});

  final int? errorCode;
  final String errorMessage;
  @override
  List<Object?> get props => [errorCode, errorMessage];
}
