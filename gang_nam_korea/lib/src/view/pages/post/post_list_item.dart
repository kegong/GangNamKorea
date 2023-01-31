import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../model/post_data.dart';
import '../../common/common_widget.dart';
import 'post_detail_page.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({super.key, required this.post});

  final PostData post;

  @override
  Widget build(BuildContext context) {
    // if (gBlockUsers.containsKey(post.userId)) {
    //   return Padding(
    //     padding: EdgeInsets.only(left: 19),
    //     child: Text(
    //       '차단된 사용자 입니다.',
    //       style: TextStyle(color: Colors.grey),
    //     ),
    //   );
    // }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PostDetailPage(
                postNo: post.postNo,
              );
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 10),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonWidget.buildIsNew(post.wdate),
              _buildContent(),
              _buildImg(),
            ],
          ),
        ),
      ),
    );
  }

  _buildContent() {
    return Flexible(
      fit: FlexFit.tight,
      flex: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post.subject,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 3,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 3),
          Text(post.getNameTimeReadCount(), style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }

  _buildImg() {
    if (post.thumbUrl.isEmpty) return const SizedBox(width: 40);

    return Stack(children: [
      Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(5.0),
              image: DecorationImage(fit: BoxFit.cover, image: CachedNetworkImageProvider(post.thumbUrl))))
    ]);
  }
}
