import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  static HubConnection? _hub;
  static final StreamController<Map<String, dynamic>> _ctrl =
      StreamController<Map<String, dynamic>>.broadcast();

  static Stream<Map<String, dynamic>> get stream => _ctrl.stream;

  static Future<void> connect() async {
    // Avoid reconnecting if already connected/connecting
    if (_hub != null &&
        (_hub!.state == HubConnectionState.Connected ||
            _hub!.state == HubConnectionState.Connecting)) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) {
      // No token, skip connection
      return;
    }

    _hub = HubConnectionBuilder()
        .withUrl(
          'https://api-user.kwikports.com/hubs/notification?access_token=$token',
          options: HttpConnectionOptions(
            skipNegotiation: false,
            transport: HttpTransportType.WebSockets,
          ),
        )
        .withAutomaticReconnect()
        .build();

    // Wire ReceiveNotification
    _hub!.on('ReceiveNotification', (args) {
      if (args != null && args.isNotEmpty && args.first is Map) {
        final Map data = args.first as Map;
        _ctrl.add({
          'title': data['Title'] ?? '',
          'message': data['Message'] ?? '',
          'type': data['Type'] ?? '',
          'sentAt': data['SentAt'] ?? '',
        });
        print('📩 Notification: $data');
      }
    });

    _hub!.onclose(({error}) => print('SignalR closed: $error'));
    _hub!.onreconnecting(({error}) => print('SignalR reconnecting: $error'));
    _hub!.onreconnected(({connectionId}) => print('SignalR reconnected: $connectionId'));

    await _hub!.start();
    print('✅ SignalR connected');
  }

  static Future<void> disconnect() async {
    await _hub?.stop();
  }

  static void dispose() {
    _ctrl.close();
    disconnect();
  }
}
