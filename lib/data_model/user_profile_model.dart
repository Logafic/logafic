// Kullanıcı profil verilerinin kontrol edildiği ve tutulduğu model
class UserProfile {
  String? userEmail;
  String? userId;
  String? userName;
  String? universty;
  String? userProfileImage;
  String? userBackImage;
  String? department;
  String? city;
  String? gender;
  String? webSite;
  String? linkedin;
  String? twitter;
  String? instagram;
  String? birtday;
  String? biograpfy;
  bool? unreadMessage;
  bool? unreadNotification;
  // bool? isAdmin;

  UserProfile({
    this.userEmail,
    this.userId,
    this.userName,
    this.universty,
    this.userProfileImage,
    this.userBackImage,
    this.department,
    this.city,
    this.gender,
    this.webSite,
    this.linkedin,
    this.twitter,
    this.instagram,
    this.birtday,
    this.biograpfy,
    // this.isAdmin,
    this.unreadMessage,
    this.unreadNotification,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['userProfileImage'] = this.userProfileImage;
    data['userBackImage'] = this.userBackImage;
    data['department'] = this.department;
    data['universty'] = this.universty;
    data['city'] = this.city;
    data['gender'] = this.gender;
    data['webSite'] = this.webSite;
    data['linkedin'] = this.linkedin;
    data['twitter'] = this.twitter;
    data['instagram'] = this.instagram;
    data['birtday'] = this.birtday;
    data['biograpfy'] = this.biograpfy;
    data['email'] = this.userEmail;
    // data['isAdmin'] = this.isAdmin;
    data['unreadNotification'] = this.unreadNotification;
    data['unreadMessage'] = this.unreadMessage;

    return data;
  }

  factory UserProfile.fromMap(Map data) {
    return UserProfile(
      userId: data['userId'],
      userName: data['userName'],
      department: data['department'],
      city: data['city'],
      gender: data['gender'],
      webSite: data['website'],
      linkedin: data['linkedin'],
      twitter: data['twitter'],
      instagram: data['instagram'],
      birtday: data['birtday'],
      biograpfy: data['biograpfy'],
      userEmail: data['email'],
      userBackImage: data['userBackImage'],
      userProfileImage: data['userProfileImage'],
      // isAdmin: data['isAdmin'],
      unreadMessage: data['unreadMessage'],
      unreadNotification: data['unreadNotification'],
      universty: data['universty'],
    );
  }
}
