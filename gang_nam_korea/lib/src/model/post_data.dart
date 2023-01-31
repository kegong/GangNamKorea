import '../util/extention.dart';
import '../util/time_util.dart';

class PostData {
  int postNo = 0;
  int userNo = 0;
  String nickName = "";
  String subject = "";
  String content = "";
  String thumbUrl = "";
  int readCnt = 0;
  int replyCnt = 0;
  int likeCnt = 0;
  int unlikeCnt = 0;
  DateTime? wdate;

  PostData({
    required this.postNo,
    required this.userNo,
    required this.nickName,
    required this.subject,
    required this.content,
    required this.thumbUrl,
    required this.readCnt,
    required this.replyCnt,
    required this.likeCnt,
    required this.unlikeCnt,
    required this.wdate,
  });

  factory PostData.fromJson(Map<String, dynamic> json) {
    return PostData(
      postNo: Parser.toInt(json['postNo']),
      userNo: Parser.toInt(json['userNo']),
      nickName: json['nickName'],
      subject: json['subject'],
      content: json['content'] ?? '',
      thumbUrl: json['thumbUrl'],
      readCnt: Parser.toInt(json['readCnt']),
      replyCnt: Parser.toInt(json['replyCnt']),
      likeCnt: Parser.toInt(json['likeCnt']),
      unlikeCnt: Parser.toInt(json['unlikeCnt']),
      wdate: Parser.toDateTime(json['wdate']),
    );
  }

  String getNameTimeReadCount() {
    return '$nickName  ${TimeUtil.timeToTodayTimeAfterDay(wdate!)}  조회 ${Parser.toCommaString(readCnt)}  댓글 $replyCnt';
  }

  static List<PostData> parsePosts(jsonPosts, {List<PostData>? oldPosts}) {
    List<PostData> posts = [];

    if (oldPosts != null) posts.addAll(oldPosts);

    for (var item in jsonPosts) {
      posts.add(PostData.fromJson(item));
    }

    return posts;
  }
}
