// Bildirimlerin kontrol edildiği ve tutulduğu model

class NotificationModel {
  NotificationModel(
      {required this.userName, required this.userId, required this.date});

  NotificationModel.fromJson(Map<String, Object?> json)
      : this(
            userId: json['userId']! as String,
            userName: json['userName']! as String,
            date: json['date']! as String);

  final String userName;
  final String userId;
  final String date;

  Map<String, Object?> toJson() {
    return {'userName': userName, 'userId': userId, 'date': date};
  }
}
