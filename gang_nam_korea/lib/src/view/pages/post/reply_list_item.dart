import 'package:flutter/material.dart';
import 'package:gang_nam_korea/src/helper/time_helper.dart';
import 'package:gang_nam_korea/src/viewmodel/common/app_controller.dart';
import 'package:gang_nam_korea/src/viewmodel/common/server_controller.dart';

import '../../../model/reply_data.dart';
import '../../common/common_widget.dart';
import 'complain_page.dart';
import 'reply_list_page.dart';

class ReplyListItem extends StatelessWidget {
  const ReplyListItem({
    Key? key,
    required this.reply,
    required this.postOwnerNo,
    required this.isShowMenu,
    required this.isShowReplyWrite,
    required this.isOnlyTime,
    required this.isDivider,
    required this.setReloadFunc,
  }) : super(key: key);

  final ReplyData reply;
  final int postOwnerNo;
  final bool isShowMenu;
  final bool isShowReplyWrite;
  final bool isOnlyTime;
  final bool isDivider;
  final Function setReloadFunc;

  @override
  Widget build(BuildContext context) {
    if (AppController.to.blockUsers.containsKey(reply.userNo)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: reply.isSub ? const EdgeInsets.only(top: 12, left: 30) : const EdgeInsets.only(top: 12),
            child: const Text(
              '차단된 사용자 입니다.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          isDivider
              ? const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Divider(height: 1),
                )
              : const SizedBox.shrink(),
        ],
      );
    }

    return Column(
      children: [
        Container(
          color: AppController.to.isMyUserNo(reply.userNo) ? Colors.white : Colors.white,
          child: Padding(
            padding: reply.isSub ? const EdgeInsets.only(top: 12, left: 30) : const EdgeInsets.only(top: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ProfilePage(curUserId: gUserData.userNo!),
                    //   ),
                    // );
                  },
                  child: CommonWidget.buildCircleAvatar(
                    photoUrl: reply.userPhotoUrl,
                    radius: reply.isSub && isShowReplyWrite && !isShowMenu ? 13 : 15,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ProfilePage(curUserId: gUserData.userNo!),
                        //   ),
                        // );
                      },
                      child: Text(
                        reply.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: reply.toUserName.isEmpty ? '' : '${reply.toUserName} ',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                            text: reply.content,
                            style: const TextStyle(
                              color: Colors.black,
                            )),
                      ]),
                    ),
                    Row(
                      children: [
                        Text(
                          isOnlyTime
                              ? TimeHelper.timeToStringYMDHM(reply.wdate)
                              : TimeHelper.timeToTodayAgoAfterDayTime(reply.wdate),
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(width: 10),
                        isShowReplyWrite
                            ? GestureDetector(
                                onTap: () {
                                  moveReplyListPage(context);
                                },
                                child: const Text(
                                  '답글쓰기',
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    )
                  ],
                ),
                const Expanded(child: SizedBox()),
                isShowMenu
                    ? GestureDetector(
                        onTap: () {
                          showMenu(context);
                        },
                        child: const Icon(
                          Icons.more_horiz,
                          color: Colors.grey,
                          size: 23,
                        ))
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
        isDivider
            ? const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Divider(height: 1),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  moveReplyListPage(BuildContext context) async {
    final isNeedReload = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ReplyListPage(
            postNo: reply.postNo,
            ownerNo: postOwnerNo,
            indexNo: reply.indexNo,
            toUserName: reply.isSub ? reply.userName : '',
          );
        },
      ),
    );

    if (isNeedReload != null && isNeedReload) {
      setReloadFunc();
    }
  }

  showMenu(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: AppController.to.isMyUserNo(reply.userNo)
                    ? [
                        _buildMenuButton(context, '답글 쓰기'),
                        //_buildMenuButton(context, '수정'),
                        _buildMenuButton(context, '삭제'),
                      ]
                    : [
                        _buildMenuButton(context, '답글 쓰기'),
                        _buildMenuButton(context, '신고 하기'),
                        _buildMenuButton(context, '작성자 차단'),
                      ],
              ),
            ),
          );
        });
  }

  _buildMenuButton(BuildContext context, String title) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();

        if (title == '답글 쓰기') {
          moveReplyListPage(context);
        } else if (title == '수정') {
        } else if (title == '삭제') {
          CommonWidget.showConfirmDialog(
            context,
            content: '정말 삭제하시겠습니까?',
            actionText1: '아니요',
            actionText2: '예',
            onPressed2: () {
              ServerController.to
                  .request('REPLY_DELETE', {'replyNo': reply.replyNo, 'postNo': reply.postNo, 'ownerNo': postOwnerNo},
                      retFunc: (json) {
                setReloadFunc();
              });
            },
          );
        } else if (title == '신고 하기') {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return ComplainPage(
              otherUserNo: reply.userNo,
              postNo: reply.postNo,
              replyNo: reply.replyNo,
              content: reply.content,
              userName: reply.userName,
            );
          }));
        } else if (title == '작성자 차단') {
          CommonWidget.showConfirmDialog(context, title: '작성자 차단', content: '이 회원을 차단하고 쓴 글과 댓글을 보지 않겠습니까?',
              onPressed2: () {
            ServerController.to.request(
              'USER_BLOCK',
              {'blockUserId': reply.userNo},
              retFunc: (json) {
                AppController.to.blockUsers.addEntries(<int, int>{reply.userNo: reply.userNo}.entries);
              },
            );
          });
        }
      },
      child: Text(title, style: const TextStyle(fontSize: 18, color: Colors.black)),
    );
  }
}
