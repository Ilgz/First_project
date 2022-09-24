part of 'chat_bloc.dart';

abstract class ChatEvent {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadChat extends ChatEvent {}

class LoadMessage extends ChatEvent {
  Datum message;
  LoadMessage(this.message);
}

class SendMessage extends ChatEvent {
  int from;
  String to;
  String message;
  String product_id;
  SendMessage(this.from, this.to, this.message, this.product_id);
}

class HasRead extends ChatEvent {
  String from;
  String to;
  String product_id;
  HasRead(this.from, this.to, this.product_id);
}
