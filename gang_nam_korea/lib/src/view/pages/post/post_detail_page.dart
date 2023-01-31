// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gang_nam_korea/src/view/pages/post/post_write_page.dart';
import 'package:gang_nam_korea/src/viewmodel/common/app_controller.dart';
import 'package:gang_nam_korea/src/viewmodel/common/category_controller.dart';
import 'package:gang_nam_korea/src/viewmodel/common/server_controller.dart';
import 'package:intl/intl.dart';

import '../../../model/category.dart';
import '../../../model/post_data.dart';
import '../../../model/reply_data.dart';
import '../../../util/extention.dart';
import '../../common/common_widget.dart';
import 'complain_page.dart';
import 'post_list_item.dart';
import 'reply_list_item.dart';
import 'reply_list_page.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({Key? key, required this.postNo}) : super(key: key);

  final int postNo;

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  String strError = "";
  bool isLoading = true;

  PostData? post;
  List<ReplyData>? replys;
  List<PostData>? categoryPosts;
  int likeValue = 0;

  @override
  void initState() {
    super.initState();
    requestPostDetail();
  }

  requestPostDetail() {
    ServerController.to.request(
      'POST_DETAIL',
      {
        'postNo': widget.postNo,
        'isNewRead': !PostData.mapReadPostIds.containsKey(widget.postNo),
      },
      retFunc: (json) {
        PostData post = PostData.fromJson(json['post']);
        List<ReplyData> replys = ReplyData.parseReplys(json['replys']);
        List<PostData> categoryPosts = PostData.parsePosts(json['categoryPosts']);
        int likeValue = Parser.toInt(json['likeValue']);

        setState(() {
          post = post;
          replys = replys;
          categoryPosts = categoryPosts;
          likeValue = likeValue;
          isLoading = false;
        });

        if (!PostData.mapReadPostIds.containsKey(widget.postNo)) {
          PostData.mapReadPostIds[widget.postNo] = widget.postNo;
        }
      },
      errorFunc: (error, {json}) {
        setState(() {
          strError = error;
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('boardId'),
        titleSpacing: 0,
        actions: [
          IconButton(
              onPressed: () {
                shareKakaoTalk();
              },
              icon: const Icon(Icons.share, size: 20)),
          _buildPopupMenu(),
        ],
      ),
      body: _buildBody(),
    );
  }

  _buildPopupMenu() {
    List listFilters = [
      {'title': '게시글 신고'},
      {'title': '작성자 차단'},
    ];

    if (post != null && post!.userNo == AppController.to.userData.userNo) {
      listFilters = [
        {'title': '수정'},
        {'title': '삭제'},
      ];
    }

    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) {
        return listFilters.map((menu) {
          return PopupMenuItem(
            value: menu['title'],
            child: Row(
              children: [
                Text(menu['title']),
              ],
            ),
          );
        }).toList();
      },
      onSelected: (title) async {
        if (title == "작성자 차단") {
          showBlockUser();
        } else if (title == "게시글 신고") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return ComplainPage(
              otherUserNo: post!.userNo,
              postNo: post!.postNo,
              replyNo: 0,
              content: post!.subject.isNotEmpty ? post!.subject : post!.content,
              userName: post!.nickName,
            );
          }));
        } else if (title == "수정") {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return PostWritePage(post: post);
              },
            ),
          );

          requestPostDetail();
        } else if (title == "삭제") {
          CommonWidget.showConfirmDialog(
            context,
            content: '정말 게시글을 삭제하시겠습니까?',
            onPressed2: () {
              ServerController.to.request(
                'POST_DELETE',
                {'postNo': post!.postNo},
                retFunc: (json) {
                  Navigator.pop(context);
                  // HomePage.refreshBoards();
                },
              );
            },
          );
        }
      },
    );
  }

  _buildBody() {
    if (strError.isNotEmpty) return Center(child: Text(strError));

    if (isLoading) return Container(); //CommonWidget.buildCircularProgress();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategory(),
                _buildSubject(),
                _buildUser(),
                _buildTopDivider(),
                _buildContent(),
                const SizedBox(height: 40),
                const Divider(height: 1),
                _buildReply(),
                _buildAdmab(),
                _buildCategoryList(),
                //_buildThickDivider(),
                _buildPopuralList(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
        _buildButtomMenu(),
      ],
    );
  }

  _buildCategory() {
    CategoryData? category = CatetoryController.to.getCategoryByBoardKey('');
    if (category == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 13),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          //MainPageSet.state!.selectCategory(category);
        },
        child: Text(
          "${category.name} >",
          style: const TextStyle(color: Colors.green),
        ),
      ),
    );
  }

  _buildSubject() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 13, right: 13),
      child: Text(
        post!.subject,
        style: const TextStyle(fontSize: 23),
      ),
    );
  }

  _buildUser() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 13, right: 13),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ProfilePage(curUserId: post!.userId),
              //   ),
              // );
            },
            child: CommonWidget.buildCircleAvatar(photoUrl: '', radius: 20),
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
                    //     builder: (context) => ProfilePage(curUserId: post!.userId),
                    //   ),
                    // );
                  },
                  child: Text(post!.nickName)),
              Text(
                '${DateFormat('yyyy.MM.dd. hh:mm').format(post!.wdate!)} 조회 ${Parser.toCommaString(post!.readCnt)}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildTopDivider() {
    return const Padding(
      padding: EdgeInsets.only(top: 15, left: 13, right: 13),
      child: Divider(height: 1),
    );
  }

  _buildContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 13, right: 13),
      child: HtmlWidget(post!.content),
    );
  }

  _buildReply() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: moveReplyListPage,
            child: Text('댓글 ${post!.replyCnt} >'),
          ),
          const SizedBox(height: 10),
          ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: replys!.length,
              itemBuilder: (context, index) {
                bool isDivider = true;
                if (index + 1 < replys!.length && replys![index + 1].isSub) {
                  isDivider = false;
                }

                return ReplyListItem(
                  reply: replys![index],
                  postOwnerNo: post!.userNo,
                  isShowMenu: false,
                  isShowReplyWrite: true,
                  isOnlyTime: false,
                  isDivider: isDivider,
                  setReloadFunc: () {
                    requestPostDetail();
                  },
                );
              }),
          replys!.length < 10
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    GestureDetector(
                      onTap: () => moveReplyListPage(),
                      child: const Text('댓글 더보기'),
                    ),
                    GestureDetector(
                      onTap: () => moveReplyListPage(isNeedScrollLast: true),
                      child: const Text('마지막 댓글로'),
                    ),
                  ]),
                ),
          replys!.length < 10 ? const SizedBox.shrink() : const Divider(height: 1),
          InkWell(
            onTap: moveReplyListPage,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(children: [
                CommonWidget.buildCircleAvatar(photoUrl: '', radius: 15),
                const SizedBox(width: 10),
                Text(replys!.isEmpty ? '첫 댓글을 남겨보세요' : '댓글을 남겨보세요', style: const TextStyle(color: Colors.grey)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  _buildAdmab() {
    // return Padding(
    //   padding: EdgeInsets.only(top: 15, left: 13, right: 13),
    //   child: Text('광고'),
    // );

    return const SizedBox.shrink();
  }

  _buildCategoryList() {
    if (categoryPosts == null || categoryPosts!.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        const Divider(height: 20, thickness: 8),
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '전체글 보기',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text('더보기', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ),
        ListView.separated(
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              return PostListItem(post: categoryPosts![index]);
            },
            separatorBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(height: 8),
              );
            },
            itemCount: categoryPosts!.length)
      ],
    );
  }

  _buildPopuralList() {
    // return Padding(
    //   padding: EdgeInsets.only(top: 15, left: 13, right: 13),
    //   child: Text('인기항목'),
    // );

    return const SizedBox.shrink();
  }

  _buildButtomMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName("/"));
            },
            child: Row(children: const [
              Icon(Icons.menu),
              SizedBox(width: 5),
              Text("목록으로"),
            ]),
          ),
          const Expanded(child: SizedBox.shrink()),
          _buildButtonCount(
              icon: likeValue > 0 ? Icons.thumb_up : Icons.thumb_up_outlined,
              count: post!.likeCnt,
              onTap: () => setLikeValue(1)),
          const SizedBox(width: 20),
          _buildButtonCount(
            icon: likeValue < 0 ? Icons.thumb_down : Icons.thumb_down_outlined,
            count: post!.dislikeCnt,
            onTap: () => setLikeValue(-1),
          ),
          const SizedBox(width: 20),
          _buildButtonCount(icon: Icons.textsms_outlined, count: post!.replyCnt, onTap: moveReplyListPage),
        ],
      ),
    );
  }

  _buildButtonCount({required IconData icon, required int count, Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 5),
          Text(Parser.toCommaString(count)),
        ],
      ),
    );
  }

  setLikeValue(int value) {
    int oldLikeValue = likeValue;

    setState(() {
      // 추천 누를시
      if (value == 1) {
        if (likeValue == 1) // 기존에 추천이었을 경우
        {
          // 추천 삭제
          likeValue = 0;
          if (post!.likeCnt > 0) post!.likeCnt--;
        } else // 기존에 추천이 아니었을 경우
        {
          // 비추천이었으면 비추천 삭제
          if (likeValue == -1 && post!.dislikeCnt > 0) post!.dislikeCnt--;

          // 추천으로 변경
          likeValue = 1;
          post!.likeCnt++;
        }
      }
      // 비추천 누를시
      else {
        if (likeValue == -1) // 기존에 비추천이었을 경우
        {
          // 비추천 삭제
          likeValue = 0;
          if (post!.dislikeCnt > 0) post!.dislikeCnt--;
        } else // 기존에 비추천이 아니었을 경우
        {
          // 추천이었으면 추천 삭제
          if (likeValue == 1 && post!.likeCnt > 0) post!.likeCnt--;

          // 비추천으로 변경
          likeValue = -1;
          post!.dislikeCnt++;
        }
      }

      ServerController.to.request(
        'POST_LIKE',
        {
          'postNo': post!.postNo,
          'ownerNo': post!.userNo,
          'likeValue': likeValue,
          'oldLikeValue': oldLikeValue,
        },
        retFunc: (json) {
          print(json['RET2']);
        },
      );
    });
  }

  moveReplyListPage({bool? isNeedScrollLast}) async {
    final isNeedReload = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ReplyListPage(
            postNo: post!.postNo,
            ownerNo: post!.userNo,
            likeValue: likeValue,
            likeCount: post!.likeCnt,
            isNeedScrollLast: isNeedScrollLast,
          );
        },
      ),
    );

    if (isNeedReload != null && isNeedReload) {
      requestPostDetail();
    }
  }

  showBlockUser() {
    CommonWidget.showConfirmDialog(
      context,
      title: '작성자 차단',
      content: '이 회원을 차단하고 쓴 글과 댓글을 보지 않겠습니까?',
      onPressed2: () {
        ServerController.to.request('USER_BLOCK', {'blockUserNo': post!.userNo}, retFunc: (json) {
          Map<int, int> blockUsers = {};
          blockUsers.addAll(AppController.to.);
          blockUsers[post!.userNo] = post!.userNo;
          FriendPage.isNeedLoad = true;
          ChatPage.isNeedLoad = true;

          setState(() {
            gBlockUsers = blockUsers;
            Navigator.pop(context);
            HomePage.refreshBoards();
          });
        });
      },
    );
  }

  shareKakaoTalk() async {
    String description = post!.subject;
    if (post!.postType == PostType.gallery) {
      description = post!.boardId;
    }

    const title = '오늘의 댕댕이';
    final imageUrl = post!.imgUrl;
    final url = "http://bbiby2.godohosting.com/odenggel/page/post_view.php?postId=${post!.postNo}";

    final FeedTemplate defaultFeed = FeedTemplate(
      content: Content(
        title: title,
        description: description,
        imageUrl: Uri.parse(imageUrl),
        link: Link(webUrl: Uri.parse(url), mobileWebUrl: Uri.parse(url)),
      ),
      buttons: [
        Button(
          title: '웹으로 보기',
          link: Link(
            webUrl: Uri.parse(url),
            mobileWebUrl: Uri.parse(url),
          ),
        ),
        Button(
          title: '앱으로보기',
          link: Link(
            androidExecutionParams: {'key1': 'value1', 'key2': 'value2'},
            iosExecutionParams: {'key1': 'value1', 'key2': 'value2'},
          ),
        ),
      ],
    );

    bool result = await LinkClient.instance.isKakaoLinkAvailable();
    if (result) {
      try {
        Uri uri = await LinkClient.instance.defaultTemplate(template: defaultFeed);
        await LinkClient.instance.launchKakaoTalk(uri);
        print('카카오톡 공유 성공');
      } catch (e) {
        print('카카오톡 공유 실패 $e');
      }
    } else {
      try {
        Uri shareUrl = await WebSharerClient.instance.defaultTemplateUri(template: defaultFeed);
        await launchBrowserTab(shareUrl);
        print('카카오톡 공유 성공');
      } catch (e) {
        print('카카오톡 공유 실패 $e');
      }
    }
  }
}
