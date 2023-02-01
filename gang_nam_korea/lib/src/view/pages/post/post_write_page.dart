// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gang_nam_korea/src/env/theme_mng.dart';
import 'package:gang_nam_korea/src/model/category.dart';
import 'package:gang_nam_korea/src/view/common/common_widget.dart';
import 'package:gang_nam_korea/src/viewmodel/common/server_controller.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
// ignore: depend_on_referenced_packages
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../helper/log_print.dart';
import '../../../model/post_data.dart';
import '../../../viewmodel/common/category_controller.dart';

class PostWritePage extends StatefulWidget {
  const PostWritePage({Key? key, this.post}) : super(key: key);

  final PostData? post;

  @override
  State<PostWritePage> createState() => _PostWritePageState();
}

class _PostWritePageState extends State<PostWritePage> {
  bool uploading = false;
  bool isComposing = false;
  String? changedHtmlContent;

  bool tempVal = false;

  PostData? post;
  BoardData? boardData;
  late String postKey;

  List<String> uploadImageUrls = [];
  List<File> imageFiles = [];

  final HtmlEditorController _htmlEditorController = HtmlEditorController();
  final TextEditingController _subjectTextEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);

    if (CatetoryController.to.boardMap.containsKey(Get.arguments['boardKey'])) {
      boardData = CatetoryController.to.boardMap[Get.arguments['boardKey']];
    }

    post = Get.arguments['post'];

    if (post == null) {
      postKey = const Uuid().v4();
    } else {
      postKey = const Uuid().v4();
    }
  }

  @override
  void dispose() {
    super.dispose();

    _subjectTextEditingController.dispose();
    _focusNode.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      LogHelper.log('포커스 있음');
    } else {
      LogHelper.log('포커스 없음');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _htmlEditorController.clearFocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          backgroundColor: Colors.white,
          leading: GestureDetector(
            child: const Icon(
              Icons.arrow_back,
              color: AppColor.iconBlack,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: post != null
              ? Text(boardData == null ? '' : boardData!.name)
              : InkWell(
                  onTap: () {
                    _htmlEditorController.clearFocus();
                    showBoardSelectSheet();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 5),
                      Text(
                        boardData == null ? '게시판을 선택하세요' : boardData!.name,
                        style: const TextStyle(fontSize: 16, color: AppColor.textBlack),
                      ),
                      const SizedBox(width: 1),
                      const Icon(
                        Icons.expand_more,
                        color: AppColor.iconBlack,
                        size: 20,
                      )
                    ],
                  ),
                ),
          actions: [
            TextButton(
                onPressed: controlUploadAndSave,
                child: Text(
                  '저장',
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold, color: isComposing ? Colors.green : Colors.grey),
                ))
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  _buildBody() {
    double editorHeight = MediaQuery.of(context).size.height - 137;

    return SingleChildScrollView(
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: TextField(
              onChanged: (text) {
                updateIsComposing();
              },
              style: const TextStyle(color: Color(0xff203152), fontSize: 15.0),
              controller: _subjectTextEditingController,
              decoration: const InputDecoration(
                  hintText: '제목을 입력하세요.', hintStyle: TextStyle(color: Colors.grey), border: InputBorder.none),
              focusNode: _focusNode,
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8),
          //   child: Divider(height: 1, thickness: 0.5),
          // ),
          HtmlEditor(
            controller: _htmlEditorController,
            htmlEditorOptions: HtmlEditorOptions(
              hint: '내용을 입력하세요.',
              shouldEnsureVisible: true,
              initialText: post == null ? null : post!.content,
            ),
            htmlToolbarOptions: makeHtmlToolbarOptions(),
            otherOptions: OtherOptions(height: editorHeight, decoration: const BoxDecoration()),
            callbacks: htmlCallbacks(),
            plugins: [
              SummernoteAtMention(
                  getSuggestionsMobile: (String value) {
                    var mentions = <String>['test1', 'test2', 'test3'];
                    return mentions.where((element) => element.contains(value)).toList();
                  },
                  mentionsWeb: ['test1', 'test2', 'test3'],
                  onSelect: (String value) {
                    LogHelper.log(value);
                  }),
            ],
          ),
        ],
      ),
    );
  }

  HtmlToolbarOptions makeHtmlToolbarOptions() {
    return HtmlToolbarOptions(
      toolbarPosition: ToolbarPosition.aboveEditor, //by default
      toolbarType: ToolbarType.nativeScrollable, //by default
      defaultToolbarButtons: const [
        //StyleButtons(),
        FontSettingButtons(fontName: false, fontSizeUnit: false),
        FontButtons(
          clearAll: false,
          strikethrough: false,
          superscript: false,
          subscript: false,
        ),
        ColorButtons(),
        //ParagraphButtons(textDirection: false, lineHeight: false, caseConverter: false),
        InsertButtons(video: false, audio: false, table: false, hr: false, otherFile: false),
        ListButtons(listStyles: false),
      ],
      onButtonPressed: (ButtonType type, bool? status, Function? updateStatus) {
        LogHelper.log("button '${describeEnum(type)}' pressed, the current selected status is $status");
        _focusNode.unfocus();
        return true;
      },
      onDropdownChanged: (DropdownType type, dynamic changed, Function(dynamic)? updateSelectedItem) {
        LogHelper.log("dropdown '${describeEnum(type)}' changed to $changed");
        _focusNode.unfocus();
        return true;
      },
      mediaLinkInsertInterceptor: (String url, InsertFileType type) {
        LogHelper.log(url);
        return true;
      },
      mediaUploadInterceptor: (PlatformFile file, InsertFileType type) async {
        setState(() {
          uploading = true;
        });

        File? tempFile = File(file.path!);

        String imageKey = const Uuid().v4();

        await ServerController.to.request(
          "POST_IMAGE_UPLOAD",
          {'postKey': postKey, 'imageKey': imageKey},
          filePath: tempFile.path,
          retFunc: (json) {
            String imageUrl = json['imageUrl'];
            LogHelper.log(imageUrl);
            _htmlEditorController.insertNetworkImage(imageUrl, filename: imageKey);

            uploadImageUrls.add(imageUrl);
          },
          errorFunc: (error, {json}) {
            LogHelper.log('error');
          },
        );

        setState(() {
          uploading = false;
        });

        return false;
      },
    );
  }

  Callbacks htmlCallbacks() {
    return Callbacks(
      onBeforeCommand: (String? currentHtml) {
        LogHelper.log('html before change is $currentHtml');
      },
      onChangeContent: (String? changed) {
        LogHelper.log('content changed to $changed');
        changedHtmlContent = changed;
        updateIsComposing();
      },
      onChangeCodeview: (String? changed) {
        LogHelper.log('code changed to $changed');
      },
      onChangeSelection: (EditorSettings settings) {
        LogHelper.log('parent element is ${settings.parentElement}');
        LogHelper.log('font name is ${settings.fontName}');
      },
      onDialogShown: () {
        LogHelper.log('dialog shown');
      },
      onEnter: () {
        LogHelper.log('enter/return pressed');
      },
      onFocus: () {
        LogHelper.log('editor focused');
      },
      onBlur: () {
        LogHelper.log('editor unfocused');
      },
      onBlurCodeview: () {
        print('codeview either focused or unfocused');
      },
      onInit: () {
        print('init');
      },
      onImageUploadError: (FileUpload? file, String? base64Str, UploadError error) {
        LogHelper.log(describeEnum(error));
        LogHelper.log(base64Str ?? '');
        if (file != null) {
          LogHelper.log(file.name);
          LogHelper.log(file.size);
          LogHelper.log(file.type);
        }
      },
      onKeyDown: (int? keyCode) {
        LogHelper.log('$keyCode key downed');
      },
      onKeyUp: (int? keyCode) {
        LogHelper.log('$keyCode key released');
      },
      onMouseDown: () {
        LogHelper.log('mouse downed');
      },
      onMouseUp: () {
        LogHelper.log('mouse released');
      },
      onPaste: () {
        LogHelper.log('pasted into editor');
      },
      onScroll: () {
        LogHelper.log('editor scrolled');
      },
    );
  }

  showBoardSelectSheet() {
    final boards = CatetoryController.to.boards;
    final int cateCount = boards.length;
    double sheetHeight = MediaQuery.of(context).size.height * 0.9;
    if (cateCount * 57 + 60 < sheetHeight) {
      sheetHeight = cateCount * 57 + 60;
    }

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        builder: (context) {
          return SizedBox(
            height: sheetHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15, top: 20, bottom: 15),
                  child: Text(
                    '게시판을 선택하세요',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cateCount,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(boards[index].name),
                        trailing: Icon(
                            boards[index] == boardData ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                        onTap: () {
                          setState(() {
                            boardData = boards[index];
                            updateIsComposing();
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  updateIsComposing() {
    if (isComposing != checkIsComposing()) {
      setState(() {
        isComposing = !isComposing;
      });
    }
  }

  bool checkIsComposing({bool isShowErrorMsg = false}) {
    if (boardData == null) {
      if (isShowErrorMsg) CommonWidget.showNoticeDialog(context, content: "게시판을 선택하세요");
      return false;
    }

    if (_subjectTextEditingController.text.isEmpty) {
      if (isShowErrorMsg) CommonWidget.showNoticeDialog(context, content: "제목을 선택하세요");
      return false;
    }

    if (changedHtmlContent == null || changedHtmlContent!.isEmpty) {
      if (isShowErrorMsg) CommonWidget.showNoticeDialog(context, content: "내용을 선택하세요");
      return false;
    }

    return true;
  }

  void controlUploadAndSave() async {
    if (!checkIsComposing(isShowErrorMsg: true)) {
      return;
    }

    SystemChannels.textInput.invokeMethod('TextInput.hide');

    setState(() {
      uploading = true;
    });

    String subject = "";
    String content = "";
    //String thumbOriginUrl = "";
    String imageKey = "";

    subject = _subjectTextEditingController.text;
    content = await _htmlEditorController.getText();

    if (post == null) {
      if (uploadImageUrls.isNotEmpty) {
        //thumbOriginUrl = uploadImageUrls[0];
      }
    }

    if (post == null) {
      // categoryKey, menuKey, subMenuKey, subject, content, thumbOriginUrl, imageKey
      ServerController.to.request(
        'POST_WRITE',
        {
          'categoryKey': boardData!.categoryKey,
          'menuKey': boardData!.menuKey,
          'subMenuKey': boardData!.subMenukey,
          'subject': subject,
          'content': content,
          //'thumbOriginUrl': thumbOriginUrl,
          'imageKey': imageKey,
        },
        retFunc: (json) {
          CommonWidget.showNoticeDialog(
            context,
            content: '글쓰기를 완료했습니다.',
            onPressed: () => Get.back(),
            onPressedBackground: () => Get.back(),
          );
        },
        errorFunc: (error, {json}) {
          setState(() {
            uploading = false;
          });
        },
      );
    }
  }
}
