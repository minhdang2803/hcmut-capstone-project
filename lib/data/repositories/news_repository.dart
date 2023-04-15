import 'package:bke/data/data_source/remote/news/news_source.dart';
import 'package:bke/data/models/network/base_response.dart';
import '../models/news/news_model.dart';

class NewsRepository {
  late final NewsSource _newsSource;

  NewsRepository._internal() {
    _newsSource = NewsSourceImpl();
    // _NewsLocalSource = NewsLocalSourceImpl();
  }
  static final _instance = NewsRepository._internal();

  factory NewsRepository.instance() => _instance;

  Future<BaseResponse<NewsInfos>> getTopHeadlines() async {
    final res = await _newsSource.getTopHeadlines();
    return res;
  }

  Future<BaseResponse<NewsInfos>> getByCategory(String category) async {
    return await _newsSource.getByCategory(category);
  }
}
