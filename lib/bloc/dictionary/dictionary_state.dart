part of 'dictionary_cubit.dart';

enum DictionaryStatus { loading, done, fail, initial }

class DictionaryState extends Equatable {
  DictionaryState(
    this.errorMessage,
    this.status,
    this.vocabList,
  );
  late final List<LocalVocabInfo>? vocabList;
  late final String? errorMessage;
  late final DictionaryStatus? status;
  DictionaryState.initial() {
    vocabList = [];
    status = DictionaryStatus.initial;
    errorMessage = "";
  }

  DictionaryState copyWith({
    List<LocalVocabInfo>? vocabList,
    String? errorMessage,
    DictionaryStatus? status,
  }) {
    return DictionaryState(
      errorMessage ?? this.errorMessage,
      status ?? this.status,
      vocabList ?? this.vocabList,
    );
  }

  @override
  List<Object?> get props => [errorMessage, vocabList, status];
}
