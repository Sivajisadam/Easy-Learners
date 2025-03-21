import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final policies = Policies(fetch: FetchPolicy.noCache);

class GraphInit extends Hook<GraphQLClient> {
  const GraphInit();

  @override
  GraphInitState createState() => GraphInitState();
}

class GraphInitState extends HookState<GraphQLClient, GraphInit> {
  HttpLink? httpLink;
  AuthLink? authLink;
  WebSocketLink? webSocketLink;
  Link? link;
  GraphQLClient? client;

  @override
  void initHook() {
    authLink = AuthLink(
        getToken: () async =>
            'Bearer vL43Zwn4J2CXgoHoxbJ6OLV16nMpySz61W7seplatlwJCImJD0f9b0M96DgfDoRO');
    webSocketLink = WebSocketLink('wss://easy-learners.hasura.app/v1/graphql',
        config: SocketClientConfig(
            autoReconnect: true,
            inactivityTimeout: const Duration(seconds: 30),
            initialPayload: () async {
              return {
                'headers': {
                  // 'Authorization': 'Bearer ${globalServices.getToken()}'
                  "x-hasura-admin-secret":
                      "vL43Zwn4J2CXgoHoxbJ6OLV16nMpySz61W7seplatlwJCImJD0f9b0M96DgfDoRO"
                }
              };
            }));

    link = authLink!.concat(webSocketLink!);
    client =
        GraphQLClient(link: link!, cache: GraphQLCache(store: InMemoryStore()));
    super.initHook();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  GraphQLClient build(BuildContext context) {
    return client!;
  }
}

GraphQLClient useClient(BuildContext context) {
  return use(const GraphInit());
}
