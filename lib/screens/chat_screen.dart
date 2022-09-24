import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_project/helper.dart';
import 'package:second_project/model/model_message.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../chat/bloc/chat_bloc.dart';

class ChatScreen extends StatefulWidget {
  final List<Datum> list;
  final String userPicture;
  final String userName;
  final String userId;
  final String productId;

  const ChatScreen(
      {super.key,
      required this.list,
      required this.userPicture,
      required this.userName,
      required this.userId,
      required this.productId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ScrollController _scrollController = new ScrollController();
  var messageController = new TextEditingController();
  String messageControllerText = "";
  @override
  void initState() {
    super.initState();
    PusherService.callback = (stroka) {
      //setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  radius: 20.0,
                  child: widget.userPicture == ""
                      ? SvgPicture.asset(
                          "assets/images/user.svg",
                          height: 20,
                          width: 20,
                        )
                      : null,
                  backgroundImage: widget.userPicture != ""
                      ? Image(
                              image: CachedNetworkImageProvider(
                                  widget.userPicture.toString()))
                          .image
                      : null,
                  backgroundColor: Colors.grey[300],
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.userName,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      // Text(
                      //   "",
                      //   style: TextStyle(
                      //       color: Colors.grey.shade600, fontSize: 13),
                      // ),
                    ],
                  ),
                ),
                Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: ((context, state) {
          if (state is SendMessageLoading) {}
        }),
        builder: (context, state) {
          if (state is SendMessageLoading) {
            return buildChatScreen(
                context,
                List.from(widget.list)
                  ..addAll([
                    Datum(
                        from: PersonalDataRepo.myProfile.id,
                        to: int.parse(widget.userId),
                        message: messageControllerText,
                        productId: int.parse(
                          widget.productId,
                        ),
                        has_read: "false",
                        created_at: DateTime.now().toUtc())
                  ]));
          }
          return buildChatScreen(context, widget.list);
        },
      ),
    );
  }

  Column buildChatScreen(BuildContext context, List<Datum> list) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: list.length,
            reverse: true,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            itemBuilder: (context, index) {
              index = (index + 1 - list.length).abs();
              return Column(
                children: [
                  if ((index != 0 &&
                          DateFormat("yyyy:MM:dd")
                                  .format(list[index]
                                      .created_at
                                      .add(Duration(hours: 6)))
                                  .toString() !=
                              DateFormat("yyyy:MM:dd")
                                  .format(list[index - 1]
                                      .created_at
                                      .add(Duration(hours: 6)))
                                  .toString()) ||
                      index == 0) ...[
                    Padding(
                      padding: exceptBottom(20),
                      child: Text(
                        DateFormat(DateFormat.MONTH_DAY, "ru")
                            .format(
                                list[index].created_at.add(Duration(hours: 6)))
                            .toString(),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  ],
                  Container(
                    padding: list[index].from != PersonalDataRepo.myProfile.id
                        ? EdgeInsets.only(
                            left: 14, right: 50, top: 10, bottom: 10)
                        : EdgeInsets.only(
                            left: 50, right: 14, top: 10, bottom: 10),
                    child: Align(
                      alignment:
                          (list[index].from != PersonalDataRepo.myProfile.id
                              ? Alignment.topLeft
                              : Alignment.topRight),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color:
                              (list[index].from != PersonalDataRepo.myProfile.id
                                  ? Colors.grey.shade200
                                  : Colors.blue[200]),
                        ),
                        padding:
                            list[index].from != PersonalDataRepo.myProfile.id
                                ? EdgeInsets.only(
                                    left: 8, right: 10, top: 10, bottom: 5)
                                : EdgeInsets.only(
                                    left: 10, right: 8, top: 10, bottom: 5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SelectableText(
                              list[index].message,
                              style: TextStyle(fontSize: 15),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                      DateFormat('HH:mm')
                                          .format(list[index]
                                              .created_at
                                              .add(Duration(hours: 6)))
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.blueGrey)),
                                ),
                                BlocBuilder<ChatBloc, ChatState>(
                                  builder: (context, state) {
                                    if (state is SendMessageLoading) {
                                      if (index == (list.length - 1)) {
                                        return Icon(
                                          Icons.watch_later_outlined,
                                          color: Colors.blueGrey,
                                          size: 14,
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }
                                    return Container();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
            height: 60,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                        hintText: "Write message...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                FloatingActionButton(
                  onPressed: () {
                    messageControllerText = messageController.text;
                    messageController.clear();
                    BlocProvider.of<ChatBloc>(context)
                      ..add(SendMessage(
                          PersonalDataRepo.myProfile.id,
                          widget.userId,
                          messageControllerText,
                          widget.productId));
                  },
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 18,
                  ),
                  backgroundColor: Colors.black87,
                  elevation: 0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
