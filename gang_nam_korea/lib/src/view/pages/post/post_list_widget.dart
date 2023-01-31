// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gang_nam_korea/src/env/theme_mng.dart';
import 'package:gang_nam_korea/src/viewmodel/common/server_controller.dart';

import '../../../model/post_data.dart';
import '../../common/common_widget.dart';
import 'post_list_item.dart';

class PostListWidget extends StatefulWidget {
  const PostListWidget({Key? key}) : super(key: key);

  @override
  PostListWidgetState createState() => PostListWidgetState();
}

class PostListWidgetState extends State<PostListWidget> with AutomaticKeepAliveClientMixin<PostListWidget> {
  @override
  bool get wantKeepAlive => true;

  ScrollController? _scrollController;

  bool loading = false;

  int pageNo = 0;
  int startPostNo = 0;
  int limitPostCount = 20;
  int limitPostIncrement = 20;
  bool isFirstRequest = true;

  List<PostData> posts = [];

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController!.addListener(_scrollListener);

    refreshPostList();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();

    if (_scrollController != null) _scrollController!.dispose();
  }

  _scrollListener() async {
    if (posts.isEmpty || loading) return;

    if (_scrollController!.offset + 200 >= _scrollController!.position.maxScrollExtent &&
        !_scrollController!.position.outOfRange) {
      if (posts.length >= (pageNo + 1) * limitPostIncrement) {
        pageNo++;
        requestPostList();
      }
    }
  }

  refreshPostList() async {
    pageNo = 0;
    startPostNo = 0;
    setState(() {
      posts = [];
    });
    await requestPostList();
  }

  requestPostList() async {
    isFirstRequest = false;
    setState(() {
      loading = true;
    });

    print("POST_LIST 요청");

    await ServerController.to.request(
      "POST_LIST",
      {'pageNo': pageNo, 'startPostNo': startPostNo},
      retFunc: (json) {
        List<PostData> temp = PostData.parsePosts(json['posts'], oldPosts: posts);

        setState(() {
          loading = false;
          posts = temp;
        });
      },
      errorFunc: (error, {json}) {
        setState(() {
          loading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      color: AppColor.backgroundWhite,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(top: 8, bottom: 15),
      child: RefreshIndicator(
        onRefresh: () => refreshPostList(),
        child: Stack(children: [
          posts.isEmpty && !loading
              ? const Center(
                  child: Text("데이터가 없습니다."),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(top: 10),
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return PostListItem(post: posts[index]);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      height: 1,
                      color: Colors.grey[100],
                    );
                  },
                ),
          loading ? CommonWidget.buildCircularProgress() : const SizedBox.shrink()
        ]),
      ),
    );
  }
}
