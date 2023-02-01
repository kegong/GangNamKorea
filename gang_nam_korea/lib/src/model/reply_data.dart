import '../helper/extention.dart';

class ReplyData {
  final int replyNo;
  final int userNo;
  final int postNo;
  final int indexNo;
  final bool isSub;
  final String toUserName;
  final String content;
  final DateTime wdate;
  final String userName;
  final String userPhotoUrl;

  ReplyData({
    required this.replyNo,
    required this.userNo,
    required this.postNo,
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
      replyNo: json['replyId'],
      userNo: json['userId'],
      postNo: json['postId'],
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
