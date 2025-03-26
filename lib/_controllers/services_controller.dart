import 'package:dio/dio.dart' as dio;
import 'package:easy_learners/view/utils/common_imports.dart';

class ServiceController extends GetxService {
  static ServiceController to = Get.find<ServiceController>();
  late dio.Dio graphqlClient;

  @override
  void onInit() {
    graphqlClient = dio.Dio(dio.BaseOptions(
        baseUrl: AppUrls.baseUrl,
        contentType: 'application/json',
        responseType: dio.ResponseType.json,
        headers: {}));
    super.onInit();
  }

  Future getDataFunction(String query, final variable) async {
    dio.Response response = await graphqlClient.post('',
        data: {"query": query, "variables": variable},
        options: dio.Options(headers: {
          'Content-Type': "application/json",
          // 'Authorization': "Bearer ${GlobalServices.to.getToken()}"
          "x-hasura-admin-secret":
              "vL43Zwn4J2CXgoHoxbJ6OLV16nMpySz61W7seplatlwJCImJD0f9b0M96DgfDoRO"
        }));

    return response;
  }

  Future graphqlMutation(String mutationQuery, var variables) async {
    try {
      dio.Response r = await graphqlClient.post('',
          data: {"query": mutationQuery, "variables": variables},
          options: dio.Options(headers: {
            'Content-Type': "application/json",
            // 'Authorization': "Bearer ${GlobalService.to.getAccessToken()}"
            "x-hasura-admin-secret":
                "vL43Zwn4J2CXgoHoxbJ6OLV16nMpySz61W7seplatlwJCImJD0f9b0M96DgfDoRO"
          }));

      debugPrint('response data ${r.data.toString()}');
      var resp = r.data['data'];
      return resp;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
