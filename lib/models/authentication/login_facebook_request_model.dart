class FacebookLoginRequestModel {
  FacebookLoginRequestModel({
    required this.facebookId,
    required this.displayName,
    required this.email,
    this.photoUrl,
  });
  late final String facebookId;
  late final String displayName;
  late final String email;
  late final String? photoUrl;

  FacebookLoginRequestModel.fromJson(Map<String, dynamic> json) {
    facebookId = json['facebook_id'];
    displayName = json['display_name'];
    email = json['email'];
    photoUrl = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['facebook_id'] = facebookId;
    _data['display_name'] = displayName;
    _data['email'] = email;
    _data['photo_url'] = photoUrl;
    return _data;
  }
}
