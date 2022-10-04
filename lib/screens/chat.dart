import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:second_project/chat/bloc/chat_bloc.dart';
import 'package:second_project/helper.dart';
import 'package:second_project/screens/chat_screen.dart';

class Chat extends StatefulWidget {
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String text = "Click me";
  late PusherService pusherServicce;

  @override
  void initState() {
    pusherServicce = PusherService(
      (message) {
        BlocProvider.of<ChatBloc>(context)..add(LoadMessage(message));
      },
      (message) {
        //ChatRepo.chatList
        // setState(() {
        // BlocProvider.of<ChatBloc>(context)..add(LoadMessage(message));
        //});
      },
    );
    pusherServicce.initPusher("IlkaPaaananen", "ucontv.com.kg", 6001, "mt1");
    BlocProvider.of<ChatBloc>(context)..add(LoadChat());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: BlocConsumer<ChatBloc, ChatState>(
      buildWhen: (context, state) {
        return state is LoadChatSuccess;
      },
      listener: (context, state) {
        if (state is SendMessageSuccess) {
          setState(() {});
        }

        if (state is LoadChatSuccess) {
          print("LoadedChat");
          state.chatList!.sort((b, a) {
            var adate = a.last.created_at; //before -> var adate = a.expiry;
            var bdate = b.last.created_at; //before -> var bdate = b.expiry;
            return adate.compareTo(bdate);
            //to get the order other way just switch `adate & bdate`
          });
          ChatRepo.chatList = state.chatList;
        }
      },
      builder: (context, state) {
        if (state is LoadChatFail) {
          print("FailChat");

        }
        if (state is LoadChatSuccess) {
          if (state.chatList!.isEmpty) {
            return Stack(
              children: [
                Container(
                  height: AppBar().preferredSize.height,
                  color: Colors.transparent,
                  width: double.infinity,
                  child: IntrinsicHeight(
                    child: Stack(children: [
                      Align(
                          child: Text(
                        'Сообщения',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                    ]),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Нет сообщений",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                        textAlign: TextAlign.center,
                        "Договаривайтесь о покупке или продаже товаров в сообщениях"),
                  ],
                ),
              ],
            );
          } else {
            return buildChatScreen(context);
          }
        }

        return Container();
      },
    )));
  }

  Column buildChatScreen(BuildContext context) {
    return Column(
      children: [
        Container(
          height: AppBar().preferredSize.height,
          color: Colors.transparent,
          width: double.infinity,
          child: IntrinsicHeight(
            child: Stack(children: [
              Align(
                  child: Text(
                'Сообщения',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
            ]),
          ),
        ),
        Expanded(
            child: ListView(
                children: ListTile.divideTiles(
                    color: Colors.black87,
                    tiles: ChatRepo.chatList!.map((item) => ListTile(
                          onTap: () {
                            if (item.last.to == PersonalDataRepo.myProfile.id &&
                                item.last.has_read == "false") {
                              BlocProvider.of<ChatBloc>(context)
                                ..add(HasRead(
                                    item.first.userId!.toString(),
                                    PersonalDataRepo.myProfile.id.toString(),
                                    item.first.productId.toString()));
                            }

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                        list: item,
                                        userPicture: item.first.userPicture!,
                                        userName: item.first.userName!,
                                        userId: item.first.userId!,
                                        productId:
                                            item.first.productId.toString())));
                            item.last.has_read = "true";
                            setState(() {});
                          },
                          leading: pictureUser(item.first),

                          title: Text(
                            item.first.productName!,
                            style: TextStyle(fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            item.last.message,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (item.last.to ==
                                      PersonalDataRepo.myProfile.id &&
                                  item.last.has_read == "false") ...[
                                Icon(Icons.fiber_manual_record,
                                    color: Colors.green, size: 12),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                              CachedNetworkImage(
                                imageUrl:
                                    item.first.productPicture!.split(" ")[0],
                                imageBuilder: (context, imageProvider) =>
                                    ClipRRect(
                                  borderRadius: BorderRadius.circular(4.0),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                        // colorFilter: ColorFilter.mode(
                                        //     Colors.red, BlendMode.colorBurn)
                                      ),
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Container(
                                    height: 10, width: 10, child: null),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ],
                          ),
                          // trailing: ClipRRect(
                          //   borderRadius: BorderRadius.circular(4.0),
                          //   child: Image.network(
                          //       fit: BoxFit.cover,
                          //       width: 60,
                          //       height: 60,
                          //       item.first.productPicture!.split(" ")[0]),
                          // ),
                        ))).toList())),
      ],
    );
  }

  Widget pictureUser(message) {
    return CircleAvatar(
      radius: 20.0,
      child: message.userPicture == ""
          ? SvgPicture.asset(
              "assets/images/user.svg",
              height: 20,
              width: 20,
            )
          : null,
      backgroundImage: message.userPicture != ""
          ? Image(
                  image: CachedNetworkImageProvider(
                      message.userPicture.toString()))
              .image
          : null,
      backgroundColor: Colors.grey[300],
    );
  }
}
