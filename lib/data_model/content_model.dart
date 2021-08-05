// İçeriklerin kontrol edildiği ve tutulduğu model

class ContentModel {
  String? parentId;
  String? parentName;
  int? id;
  String? image;
  String? content;
  String? follows;
  String? comment;
  String? createdAt;

  ContentModel(
      {required this.parentId,
      required this.parentName,
      required this.id,
      required this.image,
      required this.content,
      required this.follows,
      required this.comment,
      required this.createdAt});

  ContentModel.fromJson(Map<String, dynamic> json) {
    parentId = json['parent_id'];
    parentName = json['parent_name'];
    id = json['id'];
    image = json['image'];
    content = json['content'];
    follows = json['follows'];
    comment = json['comment'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parent_id'] = this.parentId;
    data['parent_name'] = this.parentName;
    data['id'] = this.id;
    data['image'] = this.image;
    data['content'] = this.content;
    data['follows'] = this.follows;
    data['comment'] = this.comment;
    data['created_at'] = this.createdAt;
    return data;
  }
}
