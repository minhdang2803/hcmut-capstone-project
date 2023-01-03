part of 'vocab_cubit.dart';

abstract class VocabState extends Equatable {
  const VocabState();
}

class VocabInitial extends VocabState {
  @override
  List<Object> get props => [];
}

class VocabLoading extends VocabState {
  @override
  List<Object> get props => [];
}

class VocabSuccess extends VocabState {
  const VocabSuccess(this.data);

  final VocabInfos? data;

  @override
  List<Object?> get props => [data];
}

class VocabFailure extends VocabState {
  const VocabFailure(this.errorMessage, {this.errorCode});

  final int? errorCode;
  final String errorMessage;
  @override
  List<Object?> get props => [errorCode, errorMessage];
}
