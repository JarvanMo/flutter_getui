import 'package:flutter/material.dart';
import 'package:flutter_getui/flutter_getui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: '个推',
    theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity),
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String payloadInfo = 'default';
  String notificationState = 'default';
  String getClientId = '';
  String getDeviceToken = '';
  String getVoIpToken = '';
  String onReceivePayload = '';
  String onReceiveNotificationResponse = '';
  String onAppLinkPayLoad = '';
  String onReceiveVoIpPayLoad;

  @override
  void initState() {
    super.initState();

    ///初始化
    initGeTuiSdk(
        appId: 'cy0d7CICux7YKvteM5cy87',
        appKey: 'DGb52WTbzf8QX2Joji9bJ5',
        appSecret: 'ZpUhvjyrGv8d24tFCa4y95');
    initGeTuiSdk(
        appId: 'FnFp1rNm2Z5TSclnkeK9H9',
        appKey: 'FSqM3ZNYSO6QsWiaIJgXo4',
        appSecret: 'fDJ8QwfGTJ6wLgGQeoiHM5');
    WidgetsBinding.instance
        .addPostFrameCallback((Duration timeStamp) => initPlatformState());
  }

  Future<void> initPlatformState() async {
    addGeTuiEventHandler(
      onReceiveClientId: (String message) async {
        print('flutter onReceiveClientId: $message');
        getClientId = message;
        setState(() {});
      },
      onReceiveOnlineState: (bool state) {
        print('flutter onReceiveOnlineState: $state');
      },
      onReceiveMessageData: (Map<String, dynamic> msg) async {
        print('flutter onReceiveMessageData: $msg');
        payloadInfo = msg['payload'].toString();
        setState(() {});
      },
      onNotificationMessageArrived: (Map<String, dynamic> msg) async {
        print('flutter onNotificationMessageArrived');
        notificationState = 'Arrived';
        setState(() {});
      },
      onNotificationMessageClicked: (Map<String, dynamic> msg) async {
        print('flutter onNotificationMessageClicked');
        notificationState = 'Clicked';
        setState(() {});
      },
      onRegisterDeviceToken: (String message) {
        print('flutter onRegisterDeviceToken: $message');
        getDeviceToken = message;
        setState(() {});
      },
      onReceivePayload: (Map<String, dynamic> message) {
        print('flutter onReceivePayload: $message');
        onReceivePayload = message.toString();
        setState(() {});
      },
      onReceiveNotificationResponse: (Map<String, dynamic> message) {
        print('flutter onReceiveNotificationResponse: $message');
        onReceiveNotificationResponse = '$message';
        setState(() {});
      },
      onAppLinkPayload: (String message) {
        onAppLinkPayLoad = message;
        setState(() {});
      },
      onRegisterVoIpToken: (String message) {
        getVoIpToken = message;
        setState(() {});
      },
      onReceiveVoIpPayLoad: (Map<String, dynamic> message) {
        onReceiveVoIpPayLoad = message.toString();
        setState(() {});
      },
    );
  }

  Future<void> getLaunchNotification() async {
    final Map<dynamic, dynamic> info = await getGeTuiLaunchNotification;
    print(info);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('GeTui Example')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          Text('ClientId: $getClientId'),
          const Text('SDK Public Function',
              style: TextStyle(color: Colors.lightBlue, fontSize: 18.0)),
          Wrap(runSpacing: 10, spacing: 10, children: <Widget>[
            RaisedButton(
                onPressed: () async {
                  final String getClientId = await getGeTuiClientId;
                  print(getClientId);
                },
                child: const Text('getClientId')),
            RaisedButton(
                onPressed: () => startGeTuiPush,
                child: const Text('start push')),
            RaisedButton(
                onPressed: () => stopGeTuiPush, child: const Text('stop push')),
            RaisedButton(
                onPressed: () => bindGeTuiAlias('test', ''),
                child: const Text('bindAlias')),
            RaisedButton(
                onPressed: () => unbindGeTuiAlias('test', '', true),
                child: const Text('unbindAlias')),
            RaisedButton(
                onPressed: () {
                  final List<String> test = <String>[];
                  test.add('abc');
                  setGeTuiTag(test);
                },
                child: const Text('setTag')),
          ]),
          const Text('Android Public Function',
              style: TextStyle(color: Colors.lightBlue, fontSize: 18.0)),
          Text('payload: $payloadInfo'),
          Text('notification state: $notificationState'),
          const SizedBox(height: 20),
          const Text('ios Public Function',
              style: TextStyle(color: Colors.lightBlue, fontSize: 18.0)),
          Wrap(runSpacing: 10, spacing: 10, children: <Widget>[
            RaisedButton(
                onPressed: getLaunchNotification,
                child: const Text('getLaunchNotification')),
            RaisedButton(
                onPressed: () => setGeTuiBadge(5),
                child: const Text('setBadge')),
            RaisedButton(
                onPressed: () => resetGeTuiBadge,
                child: const Text('resetBadge')),
            RaisedButton(
                onPressed: () => setGeTuiLocalBadge(5),
                child: const Text('setLocalBadge(5)')),
            RaisedButton(
                onPressed: () => setGeTuiLocalBadge(0),
                child: const Text('setLocalBadge(0)'))
          ]),
          Text('DeviceToken: $getDeviceToken'),
          Text('VoIpToken: $getVoIpToken'),
          Text('payload: $onReceivePayload'),
          Text('onReceiveNotificationResponse: $onReceiveNotificationResponse'),
          Text('onAppLinkPayload: $onAppLinkPayLoad'),
          Text('onReceiveVoIpPayLoad: $onReceiveVoIpPayLoad'),
        ]),
      ));
}
