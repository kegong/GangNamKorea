import 'package:flutter/material.dart';
import 'package:gang_nam_korea/src/viewmodel/common/server_controller.dart';
import 'package:uuid/uuid.dart';

import '../../../model/reply_data.dart';
import 'reply_list_item.dart';

class ReplyListPage extends StatefulWidget {
  const ReplyListPage(
      {Key? key,
      required this.postNo,
      required this.ownerNo,
      this.indexNo,
      this.likeValue,
      this.likeCount,
      this.toUserName,
      this.isNeedScrollLast})
      : super(key: key);

  final int postNo;
  final int ownerNo;
  final int? indexNo;
  final int? likeValue;
  final int? likeCount;
  final String? toUserName;
  final bool? isNeedScrollLast;

  @override
  State<ReplyListPage> createState() => _ReplyListPageState();
}

class _ReplyListPageState extends State<ReplyListPage> {
  bool isLoading = true;
  bool isNeedReloadPrePage = false;
  bool isNeedScrollLast = false;
  bool isNeedScrollLittle = false;

  List<ReplyData> replys = [];
  int likeValue = 0;
  int likeCount = 0;
  String order = "ASC";

  final TextEditingController _contentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  getTitle() {
    if (widget.indexNo == null) {
      return "댓글  ${replys.length}";
    } else {
      return "답글쓰기";
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.likeValue != null) likeValue = widget.likeValue!;
    if (widget.likeCount != null) likeCount = widget.likeCount!;
    if (widget.isNeedScrollLast != null) isNeedScrollLast = widget.isNeedScrollLast!;

    requestReplys();
  }

  @override
  void dispose() {
    super.dispose();
    _contentController.dispose();
    _scrollController.dispose();
  }

  requestReplys() {
    ServerController.to.request(
      'REPLY_LIST',
      {'postId': widget.postNo, 'order': order, 'indexNo': widget.indexNo ?? 0},
      retFunc: (json) {
        var replys = ReplyData.parseReplys(json['replys']);

        setState(() {
          replys = replys;

          if (isNeedScrollLast) {
            isNeedScrollLast = false;
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent + 10);
          }

          if (isNeedScrollLittle) {
            isNeedScrollLittle = false;
            _scrollController.jumpTo(_scrollController.position.pixels + 100);
          }

          isLoading = false;
        });
      },
      errorFunc: (error, {json}) {
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(isNeedReloadPrePage);
        return Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop(isNeedReloadPrePage);
            },
          ),
          title: Text(getTitle()),
          titleSpacing: 0,
        ),
        body: _buildBody(),
      ),
    );
  }

  _buildBody() {
    if (isLoading) return Container(); //CommonWidget.buildCircularProgress();

    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              _buildLikes(),
              _buildSoltMenu(),
              _buildReplys(),
            ],
          ),
        )),
        const Divider(height: 1),
        _buildBottom(),
      ],
    );
  }

  _buildLikes() {
    if (widget.indexNo != null) return const SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLikeIcon(),
              _buildLikeUser(),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  _buildLikeIcon() {
    return InkWell(
        onTap: () {
          isNeedReloadPrePage = true;
          setState(() {
            int oldLikeValue = likeValue;
            if (likeValue == 1) {
              likeValue = 0;
              if (likeCount > 0) likeCount--;
            } else {
              likeValue = 1;
              likeCount++;
            }

            ServerController.to.request(
              'POST_LIKE',
              {
                'postId': widget.postNo,
                'ownerId': widget.ownerNo,
                'likeValue': likeValue,
                'oldLikeValue': oldLikeValue
              },
              retFunc: (json) {},
            );
          });
        },
        child: Row(
          children: [
            Icon(likeValue == 1 ? Icons.thumb_up : Icons.thumb_up_outlined, size: 20),
            const SizedBox(width: 5),
            Text(likeCount == 0 ? "제일 먼저 추천을 누르세요." : "$likeCount 명이 추천합니다."),
          ],
        ));
  }

  _buildLikeUser() {
    return InkWell(
      onTap: () {
        //Navigator.push(context, MaterialPageRoute(builder: (context) => LikePostUserPage(postId: widget.postId)));
      },
      child: Row(
        children: const [
          // _buildLikeUserPhoto(0),
          // _buildLikeUserPhoto(1),
          // _buildLikeUserPhoto(2),
          Icon(Icons.chevron_right, size: 20),
        ],
      ),
    );
  }

  // _buildLikeUserPhoto(int index) {
  //   if (index >= likeUsers.length) return const SizedBox.shrink();

  //   return Padding(
  //     padding: const EdgeInsets.only(left: 2),
  //     child: CommonWidget.buildCircleAvatar(photoUrl: likeUsers[index].photoUrl, radius: 12),
  //   );
  // }

  _buildSoltMenu() {
    if (widget.indexNo != null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
      child: Row(children: [
        GestureDetector(
          onTap: () => setOrder('ASC'),
          child: Text('등록순', style: TextStyle(color: order == "ASC" ? Colors.black : Colors.grey)),
        ),
        const SizedBox(width: 15),
        GestureDetector(
          onTap: () => setOrder('DESC'),
          child: Text('최신순', style: TextStyle(color: order == "DESC" ? Colors.black : Colors.grey)),
        ),
      ]),
    );
  }

  setOrder(String order) {
    if (order == order) return;

    setState(() {
      order = order;

      requestReplys();
    });
  }

  _buildReplys() {
    if (replys.isEmpty) {
      return Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.65,
        child: const Text('등록된 댓글이 없습니다.\n댓글을 남겨주세요'),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: replys.length,
        itemBuilder: (context, index) {
          return ReplyListItem(
            reply: replys[index],
            postOwnerNo: widget.ownerNo,
            isShowMenu: widget.indexNo == null,
            isShowReplyWrite: widget.indexNo == null,
            isOnlyTime: true,
            isDivider: true,
            setReloadFunc: () {
              isNeedReloadPrePage = true;
              if (order == "ASC" && index == replys.length - 1) {
                isNeedScrollLast = true;
              } else if (order == "ASC") {
                isNeedScrollLittle = true;
              }
              requestReplys();
            },
          );
        },
      ),
    );
  }

  _buildBottom() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: replys.isEmpty ? "첫 댓글을 남겨보세요" : "댓글을 남겨보세요",
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
              width: 55,
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  isNeedReloadPrePage = true;
                  String replyId = const Uuid().v4();
                  ServerController.to.request(
                    'REPLY_CREATE',
                    {
                      'replyId': replyId,
                      'postId': widget.postNo,
                      'ownerId': widget.ownerNo,
                      'indexNo': widget.indexNo ?? 0,
                      'isSub': widget.indexNo == null ? 0 : 1,
                      'toUserName': widget.toUserName ?? '',
                      'content': _contentController.text,
                    },
                    retFunc: (json) {
                      if (widget.indexNo == null) {
                        if (order == "ASC") isNeedScrollLast = true;
                        requestReplys();
                      } else {
                        isNeedReloadPrePage = true;
                        Navigator.of(context).pop(isNeedReloadPrePage);
                      }
                    },
                  );
                  _contentController.clear();
                },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(0), backgroundColor: Colors.green),
                child: const Text('등록'),
              )),
        ],
      ),
    );
  }
}
