import 'package:easy_learners/view/utils/common_imports.dart';
import 'package:http/http.dart' as http;

class BottomNavController extends GetxController {
  static BottomNavController get to => Get.find<BottomNavController>();
  RxInt currentIndex = 0.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  RxString userLocation = ''.obs;

  StreamController<String> streamResponse =
      StreamController<String>.broadcast();
  RxBool isStreaming = false.obs;

  ScrollController scrollController = ScrollController();
  ChatHistory chatHistory = ChatHistory(aiChat: []);
  RxList<ChatHistory> totalChat = <ChatHistory>[].obs;
  Rx<TextEditingController> promtController = TextEditingController().obs;
  Rx<TextEditingController> userSearch = TextEditingController().obs;

  RxBool isChatLoading = false.obs;
  RxList<Users> userList = <Users>[].obs;

  RxList pages = [
    // HomeScreen(),
    ChatScreen(),
    AssistantScreen(),
    // MapsScreen(),
    // Search(),
    Profile(),
  ].obs;
  UserDetailsModel userDetails = UserDetailsModel();
  RxBool editMobile = false.obs;
  RxBool isProfileLoading = false.obs;

  @override
  void onInit() {
    if (auth.currentUser != null) {
      getUserList();
      getUserFcm();
    }
    super.onInit();
  }

  @override
  void onClose() {
    streamResponse.close();
    _debouncer?.cancel();
    super.onClose();
  }

  void changeIndex(int index) {
    currentIndex.value = index;
    if (index == pages.length - 1 && userDetails.id == null) {
      getUserData();
    }
  }

  getUserFcm() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();

    ServiceController.to.getDataFunction(Queries.getFcm, {
      "token": fcmToken,
    }).then((v) {
      v.data['data']['fcm_tokens'].isNotEmpty
          ? updateFcmToken(v.data['data']['fcm_tokens'][0]['id'])
          : updateFcmToken('');
    });
  }

  updateFcmToken(String id) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (id.isNotEmpty) {
      ServiceController.to
          .graphqlMutation(ConstantMutationQuaries.updateOne("fcm_tokens"), {
        "id": id,
        "object": {
          "token": fcmToken,
          "user_id": auth.currentUser!.uid,
        }
      });
    } else {
      ServiceController.to
          .graphqlMutation(ConstantMutationQuaries.insertOne("fcm_tokens"), {
        "object": {
          "token": fcmToken,
          "user_id": auth.currentUser!.uid,
        }
      });
    }
  }

  Future getUserData() async {
    isProfileLoading(true);
    await ServiceController.to.getDataFunction(
        Queries.getCurrentUser, {"f_Uid": auth.currentUser!.uid}).then((value) {
      if (value.data.isNotEmpty) {
        userDetails = UserDetailsModel.fromJson(value.data['data']['users'][0]);
        isProfileLoading(false);
      } else {}
    });
  }

  void sendMessage() async {
    String userMessage = promtController.value.text.trim();
    if (userMessage.isEmpty) return;

    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    chatHistory.sessionId ??= sessionId;
    chatHistory.aiChat?.add(AiChat(userRequest: userMessage, aiResponse: ""));

    promtController.value.clear();
    isStreaming(true);
    if (streamResponse.isClosed) {
      streamResponse = StreamController<String>.broadcast();
    }

    update();
    scrollToBottom();

    await getGeminiResponse(userMessage);
  }

  Future getGeminiResponse(String prompt) async {
    String geminiApiKey = "";
   await LocalStorage.readData("geminiApiKey").then((v){
   geminiApiKey = v.toString();
    
   });
    String url = "${AppUrls.chatApi}?key=$geminiApiKey";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        String aiResponseText =
            responseBody['candidates'][0]['content']['parts'][0]['text'];

        String streamedText = "";
        for (int i = 0; i < aiResponseText.length; i++) {
          await Future.delayed(Duration(milliseconds: 10));
          streamedText = aiResponseText.substring(0, i + 1);
          streamResponse.add(streamedText);

          if (i % 10 == 0) {
            scrollToBottom();
          }
        }

        if (chatHistory.aiChat != null && chatHistory.aiChat!.isNotEmpty) {
          int lastIndex = chatHistory.aiChat!.length - 1;
          chatHistory.aiChat![lastIndex] = AiChat(
              userRequest: chatHistory.aiChat![lastIndex].userRequest,
              aiResponse: streamedText);
          if (chatHistory.id == null) {
            insertUserChat().then((v) {
              chatHistory.id = v["object"]['id'];
            });
          } else {
            updateUserChat();
          }
        }
      } else {
        String errorMessage = "Sorry, I couldn't process that request.";
        streamResponse.add(errorMessage);

        if (chatHistory.aiChat != null && chatHistory.aiChat!.isNotEmpty) {
          int lastIndex = chatHistory.aiChat!.length - 1;
          chatHistory.aiChat![lastIndex] = AiChat(
              userRequest: chatHistory.aiChat![lastIndex].userRequest,
              aiResponse: errorMessage);
        }
      }
    } catch (e) {
      String errorMessage = "An error occurred. Please try again.";
      streamResponse.add(errorMessage);

      // if (chatList.aiChat != null && chatList.aiChat!.isNotEmpty) {
      //   int lastIndex = chatList.aiChat!.length - 1;
      //   chatList.aiChat![lastIndex] = AiChat(
      //       userRequest: chatList.aiChat![lastIndex].userRequest,
      //       aiResponse: errorMessage);
      // }
    } finally {
      isStreaming(false);
      scrollToBottom();
      update();
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  insertUserChat() {
    final chatListJson = chatHistory.aiChat
        ?.map((chat) =>
            {'userRequest': chat.userRequest, 'aiResponse': chat.aiResponse})
        .toList();
    final res = ServiceController.to
        .graphqlMutation(ConstantMutationQuaries.insertOne("assistant"), {
      "object": {
        "user_id": auth.currentUser!.uid,
        "session_id": chatHistory.sessionId,
        "messages": chatListJson,
      }
    });
    return res;
  }

  Future updateUserChat() async {
    final chatListJson = chatHistory.aiChat
        ?.map((chat) =>
            {'userRequest': chat.userRequest, 'aiResponse': chat.aiResponse})
        .toList();
    final res = ServiceController.to
        .graphqlMutation(ConstantMutationQuaries.updateOne("assistant"), {
      "id": chatHistory.id,
      "object": {
        "messages": chatListJson,
      }
    });
    return res;
  }

  Future getChatHistory() async {
    isChatLoading(true);
    ServiceController.to.getDataFunction(Queries.getChatHistory,
        {"user_id": auth.currentUser?.uid.toString()}).then((v) async {
      RxList data = [].obs;
      data(v.data['data']['assistant']);
      totalChat(data.map((e) => ChatHistory.fromJson(e)).toList());
      isChatLoading(false);
      await HiveStorage.saveData(
          boxName: HiveStorage.assistantBox,
          key: "chatHistory",
          value: v.data['data']['assistant']);
      update();
    });
  }

  void clearcurrentChat() {
    getChatHistory();
    chatHistory = ChatHistory(aiChat: []);
    update();
  }

  getUserList() async {
    ServiceController.to.getDataFunction(Queries.getUserList, {
      "user_id": auth.currentUser?.uid.toString(),
    }).then((v) {
      RxList data = [].obs;
      data(v.data['data']['users']);
      userList(data.map((e) => Users.fromJson(e)).toList());

      update();
    });
  }

  searchUser(String query) {
    ServiceController.to.getDataFunction(Queries.searchUsers, {
      "user_id": auth.currentUser?.uid.toString(),
      "name": "%$query%",
    }).then((v) {
      RxList data = [].obs;
      data(v.data['data']['users']);
      userList(data.map((e) => Users.fromJson(e)).toList());
      update();
    });
  }

  Timer? _debouncer;

  void debounce(VoidCallback callback,
      {Duration duration = const Duration(milliseconds: 800)}) {
    if (_debouncer?.isActive ?? false) _debouncer!.cancel();
    _debouncer = Timer(duration, callback);
  }
}
