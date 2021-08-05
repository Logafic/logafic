// İş ve Etkinlik ilanlarının kontrol edildiği ve tutulduğu model
class JobsModel {
  String? userId;
  String? userName;
  String? userProfileImage;
  String? title;
  String? jobsName;
  String? companyName;
  String? category;
  String? location;
  String? explanation;
  int rank = 0;
  String? createdAt;

  JobsModel(
    String category,
    String userId,
    String userName,
    String userProfileImage,
    String jobsName,
    String title,
    String companyName,
    String location,
    String explanation,
  ) {
    this.title = title;
    this.userId = userId;
    this.userName = userName;
    this.userProfileImage = userProfileImage;
    this.companyName = companyName;
    this.jobsName = jobsName;
    this.location = location;
    this.category = category;
    this.explanation = explanation;
  }

  JobsModel.fromJson(Map<String, dynamic> json) {
    userId = json["userId"];
    jobsName = json["jobsName"];
    userName = json['userName'];
    userProfileImage = json['userProfileImage'];
    companyName = json["companyName"];
    category = json['category'];
    rank = json['rank'];
    location = json["location"];
    title = json["title"];
    explanation = json['explanation'];
    createdAt = json["created_at"];
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "jobsName": jobsName,
        'userName': userName,
        'userProfileImage': userProfileImage,
        "companyName": companyName,
        "category": category,
        "title": title,
        "rank": rank,
        "location": location,
        "explanation": explanation,
        "created_at": DateTime.now().toString()
      };
}
