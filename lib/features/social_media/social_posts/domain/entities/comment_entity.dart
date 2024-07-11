class CommentEntity {
  final String id;
  final String content;
  final String post;
  final num likesCount;
  final num loveCount;
  final num wowCount;
  final num sadCount;
  final num angryCount;
  final num repliesCount;
  final DateTime createdAt;
  CommentEntity({
    required this.id,
    required this.content,
    required this.post,
    required this.createdAt,
     this.likesCount= 0,
     this.loveCount= 0,
     this.wowCount= 0,
     this.sadCount= 0,
     this.angryCount= 0,
     this.repliesCount= 0,
   
  });

  
}
