part of 'category_video_cubit.dart';

enum CategoryVideoStatus { done, loading, fail, initial }

class CategoryVideoState extends Equatable {
  late final CategoryVideoStatus? status;
  late final Map<String, List<VideoYoutubeInfo>>? data;
  late final String? errorMessage;
  CategoryVideoState.initial() {
    status = CategoryVideoStatus.initial;
    errorMessage = '';
    data = {};
  }
  CategoryVideoState({
    this.errorMessage,
    this.status,
    this.data,
  });

  CategoryVideoState copyWith({
    String? errorMessage,
    CategoryVideoStatus? status,
    Map<String, List<VideoYoutubeInfo>>? data,
  }) {
    return CategoryVideoState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [
        errorMessage,
        status,
        data,
      ];
}
