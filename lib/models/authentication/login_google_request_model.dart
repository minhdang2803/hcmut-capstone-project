class GoogleLoginRequestModel {
  GoogleLoginRequestModel({
    required this.googleId,
    required this.displayName,
    required this.email,
    this.photoUrl,
  });
  late final String googleId;
  late final String displayName;
  late final String email;
  late final String? photoUrl;

  GoogleLoginRequestModel.fromJson(Map<String, dynamic> json) {
    googleId = json['google_id'];
    displayName = json['display_name'];
    email = json['email'];
    photoUrl = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['google_id'] = googleId;
    _data['display_name'] = displayName;
    _data['email'] = email;
    _data['photo_url'] = photoUrl;
    return _data;
  }
}
