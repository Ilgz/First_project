part of 'chat_bloc.dart';

abstract class ChatState {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class LoadChatSuccess extends ChatState {
  final List<List<Datum>>? chatList;
  LoadChatSuccess(this.chatList);
}

class LoadChatFail extends ChatState {
  LoadChatFail();
}

class HasReadSuccess extends ChatState {}

class SendMessageSuccess extends ChatState {
  bool chatList;
  SendMessageSuccess(this.chatList);
}

class SendMessageLoading extends ChatState {}
