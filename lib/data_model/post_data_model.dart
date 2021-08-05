// Postların verilerinin tutulduğu model
class PostModel {
  final String userId;
  final String userName;
  final String content;
  final int like;

  PostModel(
      {required this.userId,
      required this.userName,
      required this.content,
      required this.like});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['content'] = this.content;
    data['like'] = this.like;
    return data;
  }

  PostModel.fromJson(Map<String, Object?> json)
      : this(
            userId: json['userId']! as String,
            userName: json['userName']! as String,
            content: json['content']! as String,
            like: json['like']! as int);
}
