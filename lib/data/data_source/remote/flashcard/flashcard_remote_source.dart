// import 'dart:html';

// import 'package:bke/data/configs/endpoint.dart';
// import 'package:bke/data/models/flashcard/flashcard_collection_model.dart';
// import 'package:bke/data/models/network/api_service_request.dart';
// import 'package:bke/data/models/network/base_response.dart';
// import 'package:bke/data/models/network/cvn_exception.dart';
// import 'package:bke/data/services/api_service.dart';

// abstract class FlashcardRemoteSource {
//   Future<BaseResponse<List<FlashcardCollectionModel>>> getAll();
//   void updateToServer(List<FlashcardCollectionModel> data);
// }

// class FlashcardRemoteSourceImpl implements FlashcardRemoteSource {
//   final APIService _api = APIService.instance();
//   @override
//   Future<BaseResponse<List<FlashcardCollectionModel>>> getAll() {
//     try {
//       const String path = EndPoint.getAllFlashcard;
//       final response = APIServiceRequest(
//           path, (response) => List<FlashcardRemoteSourceImpl);
//     } on RemoteException catch (error) {}
//   }

//   @override
//   void updateToServer(List<FlashcardCollectionModel> data) {
//     // TODO: implement updateToServer
//   }
// }
