class MetaDataModel {
  late final int totalRecords;
  late final String page;
  late final String limit;
  late final int totalPage;

  MetaDataModel({
    required this.totalRecords,
    required this.page,
    required this.limit,
    required this.totalPage,
  });

  MetaDataModel.fromJson(Map<String, dynamic> json) {
    totalRecords = json["total_records"];
    page = json["page"];
    limit = json["limit"];
    totalPage = json["total_page"];
  }
}
