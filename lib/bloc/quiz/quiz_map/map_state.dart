part of 'map_cubit.dart';

enum MapStatus { inital, loading, done, fail }

class MapState extends Equatable {
  MapState({this.listMapObject, this.status, this.errorMessage});
  late final List<MapObjectLocal>? listMapObject;
  late final MapStatus? status;
  late final String? errorMessage;

  MapState.initial() {
    listMapObject = [];
    status = MapStatus.inital;
    errorMessage = "";
  }

  MapState copyWith({
    List<MapObjectLocal>? listMapObject,
    MapStatus? status,
    String? errorMessage,
  }) {
    return MapState(
      listMapObject: listMapObject ?? this.listMapObject,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [listMapObject, status, errorMessage];
}
