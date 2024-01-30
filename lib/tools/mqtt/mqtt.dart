import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:antam_monitoring/tools/apiHelper.dart';
// import 'package:mqtt_client/mqtt_browser_client.dart';
// import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';
import 'server.dart' if (dart.library.html) 'browser.dart' as mqttsetup;

class MyMqtt {
  var pongCount = 0; // Pong counter

  final client = mqttsetup.setup('ws://202.148.1.57',
      "antam${DateTime.now().millisecondsSinceEpoch.toString()}${ApiHelper.tokenMain}");
  Function(Map<String, dynamic> json, String topic) onUpdate;

  MyMqtt({required this.onUpdate}) {
    connect();
  }

  void disconnect() {
    client.onDisconnected = null;
    client.disconnect();
  }

  List<String> topics = [];

  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.atLeastOnce);

    topics.add(topic);
  }

  void publish(Map<String, dynamic> data, String topic) {
    final builder2 = MqttClientPayloadBuilder();
    builder2.addString(jsonEncode(data));
    // print('EXAMPLE:: <<<< PUBLISH 2 >>>>');
    client.publishMessage(topic, MqttQos.atLeastOnce, builder2.payload!);

    // if (kDebugMode) {
    print("topic: $topic, payload: ${jsonEncode(data)}");
    // }
  }

  Future<int> connect() async {
    /// A websocket URL must start with ws:// or wss:// or Dart will throw an exception, consult your websocket MQTT broker
    /// for details.
    /// To use websockets add the following lines -:
    // client.

    /// client.port = 80;  ( or whatever your WS port is)
    /// There is also an alternate websocket implementation for specialist use, see useAlternateWebSocketImplementation
    /// Note do not set the secure flag if you are using wss, the secure flags is for TCP sockets only.
    /// You can also supply your own websocket protocol list or disable this feature using the websocketProtocols
    /// setter, read the API docs for further details here, the vast majority of brokers will support the client default
    /// list so in most cases you can ignore this.
    ///

    client.port = 7008;

    client.websocketProtocols = MqttClientConstants.protocolsSingleDefault;

    /// Set logging on if needed, defaults to off
    client.logging(on: false);

    /// Set the correct MQTT protocol for mosquito
    client.setProtocolV311();

    /// If you intend to use a keep alive you must set it here otherwise keep alive will be disabled.
    client.keepAlivePeriod = 20;

    /// The connection timeout period can be set if needed, the default is 5 seconds.
    client.connectTimeoutPeriod = 10000; // milliseconds

    /// Add the unsolicited disconnection callback
    client.onDisconnected = onDisconnected;

    /// Add the successful connection callback
    client.onConnected = onConnected;

    /// Add a subscribed callback, there is also an unsubscribed callback if you need it.
    /// You can add these before connection or change them dynamically after connection if
    /// you wish. There is also an onSubscribeFail callback for failed subscriptions, these
    /// can fail either because you have tried to subscribe to an invalid topic or the broker
    /// rejects the subscribe request.
    client.onSubscribed = onSubscribed;

    /// Set a ping received callback if needed, called whenever a ping response(pong) is received
    /// from the broker.
    // client.pongCallback = pong;

    /// Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password and clean session,
    /// an example of a specific one below.
    final connMess = MqttConnectMessage()
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    // print('EXAMPLE::Mosquitto client connecting....');
    client.connectionMessage = connMess;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
    /// never send malformed messages.
    try {
      await client.connect("xirka", "xirka@30");
    } on NoConnectionException catch (e) {
      // Raised by the client when connection fails.
      if (kDebugMode) {
        print('EXAMPLE::client exception - $e');
      }

      client.disconnect();
    } on SocketException catch (e) {
      // Raised by the socket layer
      if (kDebugMode) {
        print('EXAMPLE::socket exception - $e');
      }
      client.disconnect();
    }

    /// Check we are connected
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      if (kDebugMode) {
        print('EXAMPLE::Mosquitto client connected');
      }
    } else {
      /// Use status here rather than state if you also want the broker return code.
      if (kDebugMode) {
        print(
            'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      }
      client.disconnect();
      exit(-1);
    }

    /// Ok, lets try a subscription
    if (kDebugMode) {
      print('EXAMPLE::Subscribing to the test/lol topic');
    }
    var topic = 'antam/device'; // Not a wildcard topic
    client.subscribe(topic, MqttQos.atLeastOnce);
    // client.subscribe('antam/device/node', MqttQos.atLeastOnce);
    client.subscribe('antam/status', MqttQos.atLeastOnce);
    client.subscribe('antam/statistic', MqttQos.atLeastOnce);
    client.subscribe('antam/statusnode', MqttQos.atLeastOnce);
    client.subscribe('antam/statusNode', MqttQos.atLeastOnce);

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      /// The above may seem a little convoluted for users only interested in the
      /// payload, some users however may be interested in the received publish message,
      /// lets not constrain ourselves yet until the package has been in the wild
      /// for a while.
      /// The payload is a byte buffer, this will be specific to the topic
      final json = jsonDecode(pt);

      if (kDebugMode) {
        print(json);
      }

      // if (json["tangkiData"] != null) {
      onUpdate(json, c[0].topic);
      // }
    });

    /// If needed you can listen for published messages that have completed the publishing
    /// handshake which is Qos dependant. Any message received on this stream has completed its
    /// publishing handshake with the broker.
    // client.published!.listen((MqttPublishMessage message) {
    //   print(
    //       'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
    // });

    /// Lets publish to our topic
    /// Use the payload builder rather than a raw buffer
    /// Our known topic to publish to

    // /// Ok, we will now sleep a while, in this gap you will see ping request/response
    // /// messages being exchanged by the keep alive mechanism.
    // print('EXAMPLE::Sleeping....');
    // await MqttUtilities.asyncSleep(60);

    // /// Finally, unsubscribe and exit gracefully
    // print('EXAMPLE::Unsubscribing');
    // client.unsubscribe(topic);

    // /// Wait for the unsubscribe message from the broker if you wish.
    // await MqttUtilities.asyncSleep(2);
    // print('EXAMPLE::Disconnecting');
    // client.disconnect();
    // print('EXAMPLE::Exiting normally');
    return 0;
  }

  void write(String msg, String topic) {
    try {
      final builder = MqttClientPayloadBuilder();
      builder.addString(msg);

      /// Subscribe to it
      // print('EXAMPLE::Subscribing to the Dart/Mqtt_client/testtopic topic');
      // client.subscribe(topic, MqttQos.exactlyOnce);

      /// Publish it
      // print('EXAMPLE::Publishing our topic');
      client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    // if(client.)
    // const pubTopic = 'Dart/Mqtt_client/testtopic';
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    if (kDebugMode) {
      print('EXAMPLE::Subscription confirmed for topic $topic');
    }
  }

  /// The unsolicited disconnect callback
  bool reconnecting = false;
  void onDisconnected() {
    // connect();

    Random rand = Random(200);

    // client.clientIdentifier = ApiHelper.user_id +
    //     DateTime.now().millisecondsSinceEpoch.toString() +
    //     rand.nextInt(10000000).toString();

    if (kDebugMode) {
      print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    }

    if (reconnecting) return;

    reconnecting = true;

    Future.delayed(Duration(seconds: 4), () async {
      try {
        await connect();

        topics.forEach((element) {
          client.subscribe(element, MqttQos.atLeastOnce);
        });

        reconnecting = false;
      } catch (e) {
        reconnecting = false;
      }
    });
    // if (client.connectionStatus!.disconnectionOrigin ==
    //     MqttDisconnectionOrigin.solicited) {
    //   print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    // } else {
    //   print(
    //       'EXAMPLE::OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
    //   exit(-1);
    // }
    // if (pongCount == 3) {
    //   print('EXAMPLE:: Pong count is correct');
    // } else {
    //   print('EXAMPLE:: Pong count is incorrect, expected 3. actual $pongCount');
    // }
  }

  /// The successful connect callback
  void onConnected() {
    if (kDebugMode) {
      print(
          'EXAMPLE::OnConnected client callback - Client connection was successful');
    }
  }
}
