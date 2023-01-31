import '../util/extention.dart';

class ReplyData {
  final String replyId;
  final String userId;
  final String postId;
  final int indexNo;
  final bool isSub;
  final String toUserName;
  final String content;
  final DateTime wdate;
  final String userName;
  final String userPhotoUrl;

  ReplyData({
    required this.replyId,
    required this.userId,
    required this.postId,
    required this.indexNo,
    required this.isSub,
    required this.toUserName,
    required this.content,
    required this.wdate,
    required this.userName,
    required this.userPhotoUrl,
  });

  factory ReplyData.fromJson(Map<String, dynamic> json) {
    return ReplyData(
      replyId: json['replyId'],
      userId: json['userId'],
      postId: json['postId'],
      indexNo: Parser.toInt(json['indexNo']),
      isSub: json['isSub'] == "1",
      toUserName: json['toUserName'],
      content: json['content'],
      wdate: Parser.toDateTime(json['wdate']),
      userName: json['userName'],
      userPhotoUrl: json['userPhotoUrl'],
    );
  }

  static List<ReplyData> parseReplys(jsonReplys) {
    List<ReplyData> replys = [];

    for (var item in jsonReplys) {
      replys.add(ReplyData.fromJson(item));
    }

    return replys;
  }
}
