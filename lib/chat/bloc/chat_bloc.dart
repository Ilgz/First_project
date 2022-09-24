import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:second_project/helper.dart';
import 'package:second_project/model/model_message.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  List<List<Datum>>? chatList = [];
  ChatBloc() : super(ChatInitial()) {
    on<LoadChat>(_loadChat);
    on<LoadMessage>(_loadMessage);
    on<SendMessage>(_sendMessage);
    on<HasRead>(_hasRead);
  }
  Future<void> _hasRead(HasRead event, Emitter<ChatState> emit) async {
    try {
      final String parameters =
          "${myServer}api/mes?from=${event.from}&to=${event.to}&message=empty&product_id=${event.product_id}";
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${PersonalDataRepo.apiKey}',
      };
      final response =
          await http.post(Uri.parse(parameters), headers: requestHeaders);
      print(response.body);
      emit(HasReadSuccess());
    } catch (e) {
      print("error");
    }
  }

  Future<void> _sendMessage(SendMessage event, Emitter<ChatState> emit) async {
    try {
      emit(SendMessageLoading());
      final String parameters =
          "${myServer}api/mes?from=${event.from}&to=${event.to}&message=${event.message}&product_id=${event.product_id}";
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${PersonalDataRepo.apiKey}',
      };

      await http.post(Uri.parse(parameters), headers: requestHeaders);
      await addMessageToList(Datum(
          from: event.from,
          to: int.parse(event.to),
          message: event.message,
          has_read: "false",
          productId: int.parse(event.product_id),
          created_at: DateTime.now().toUtc().add(Duration(hours: 6))));
      emit(LoadChatSuccess(chatList));
    } catch (e) {
      print("error");
    }
  }

  Future<void> _loadMessage(LoadMessage event, Emitter<ChatState> emit) async {
    await addMessageToList(event.message);
    emit(LoadChatSuccess(chatList));
  }

  Future<void> _loadChat(LoadChat event, Emitter<ChatState> emit) async {
    try {
      final String parameters = "${myServer}api/mes";
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${PersonalDataRepo.apiKey}',
      };
      final response =
          await http.get(Uri.parse(parameters), headers: requestHeaders);

      final result = messageFromJson(response.body);
      for (int i = 0; i < result.data.length; i++) {
        if (chatList!.isNotEmpty) {
          await addMessageToList(result.data[i]);
        } else {
          await loadImage(result.data[i]);
          GetChatProduct _getChatProd =
              await loadProductDetails(result.data[i].productId);
          result.data[i].productName = _getChatProd.product;
          result.data[i].productPicture = _getChatProd.picture;
          List<Datum> zhoor = [result.data[i]];
          chatList!.add(zhoor);
        }
      }

      emit(LoadChatSuccess(chatList));
    } catch (e) {
      emit(LoadChatFail());
    }
  }

  Future<void> addMessageToList(
    Datum message,
  ) async {
    bool _isNew = true;
    for (int x = 0; x < chatList!.length; x++) {
      bool _isUserIdentical = false;
      String firstElement = message.from.toString();
      String secondElement = message.to.toString();
      String thirdElement = chatList![x].first.from.toString();
      String fourthElement = chatList![x].first.to.toString();
      if (firstElement + " " + secondElement ==
              thirdElement + " " + fourthElement ||
          firstElement + " " + secondElement ==
              fourthElement + " " + thirdElement) {
        _isUserIdentical = true;
      }
      if (message.productId == chatList![x].first.productId &&
          _isUserIdentical) {
        chatList![x].add(message);
        _isNew = false;
        break;
      }
    }
    if (_isNew) {
      GetChatProduct _getChatProd = await loadProductDetails(message.productId);
      // GetChatUser _getChatUser = await loadImage(message);
      // message.userName = _getChatUser.name;
      // message.userPicture = _getChatUser.picture;
      await loadImage(message);
      message.productName = _getChatProd.product;
      message.productPicture = _getChatProd.picture;
      List<Datum> zhoor = [message];
      chatList!.add(zhoor);
    }
  }

  Future<void> loadImage(message) async {
    late String userId;

    if (message.from.toString() == PersonalDataRepo.myProfile.id.toString()) {
      userId = message.to.toString();
    } else {
      userId = message.from.toString();
    }
    final response =
        await http.get(Uri.parse("${myServer}api/mes/${userId}?data=user"));
    final result = getChatUserFromJson(response.body);
    message.userName = result[0].name;
    message.userId = userId;
    if (result[0].picture == null) {
      message.userPicture = "";
    } else {
      message.userPicture = result[0].picture;
    }
  }

  Future<GetChatProduct> loadProductDetails(int productId) async {
    String link = "${myServer}api/mes/${productId}?data=product";
    final response = await http.get(Uri.parse(link));
    final result = getChatProductFromJson(response.body);
    return result[0];
  }
}
