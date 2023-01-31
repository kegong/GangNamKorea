import 'package:flutter/material.dart';
import 'package:gang_nam_korea/src/viewmodel/common/server_controller.dart';

class ComplainPage extends StatefulWidget {
  const ComplainPage({
    Key? key,
    required this.otherUserNo,
    required this.postNo,
    required this.replyNo,
    required this.userName,
    required this.content,
  }) : super(key: key);

  final int otherUserNo;
  final int postNo;
  final int replyNo;
  final String userName;
  final String content;

  @override
  State<ComplainPage> createState() => _ComplainPageState();
}

class _ComplainPageState extends State<ComplainPage> {
  var radioVal = 0;

  final TextEditingController _cntentTextEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    _cntentTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('신고'),
        actions: [
          TextButton(
              onPressed: () {
                if (radioVal == 0) return;

                ServerController.to.request(
                  'COMPLAIN',
                  {
                    'otherUserNo': widget.otherUserNo,
                    'postNo': widget.postNo,
                    'replyNo': widget.replyNo,
                    'content': widget.content,
                    'kind': radioVal,
                  },
                  retFunc: (json) {
                    Navigator.pop(context);
                  },
                );
              },
              child: Text(
                '완료',
                style: TextStyle(fontSize: 18, color: radioVal == 0 ? Colors.grey : Colors.deepOrange),
              ))
        ],
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTop(),
          const Divider(),
          _buildRadio('음란/성인', 1),
          _buildRadio('불법정보(도박/사행성)', 2),
          _buildRadio('기타', 3),
          const Divider(),
          _buildContent(),
          const Divider(),
        ],
      ),
    );
  }

  _buildTop() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '작성자  -  ${widget.userName}',
            style: TextStyle(fontSize: 17, color: Colors.grey[600]),
          ),
          const SizedBox(height: 2),
          Text(
            '내    용  -  ${widget.content}',
            maxLines: 2,
            style: TextStyle(fontSize: 17, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      child: Expanded(
          child: TextField(
        controller: _cntentTextEditingController,
        maxLines: 4,
        maxLength: 300,
        decoration: const InputDecoration.collapsed(hintText: '상세 내용을 적으세요.', hintStyle: TextStyle(color: Colors.grey)),
      )),
    );
  }

  _buildRadio(String title, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18),
          ),
          Radio(
              value: value,
              groupValue: radioVal,
              onChanged: (int? value) {
                setState(() {
                  radioVal = value!;
                });
              })
        ],
      ),
    );
  }
}
