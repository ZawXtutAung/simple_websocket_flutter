import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(channel: IOWebSocketChannel.connect("wss://ws.ifelse.io/")
          //channel: IOWebSocketChannel.connect("ws://echo.websocket.org")
          ),
    );
  }
}

class Home extends StatefulWidget {
  final WebSocketChannel? channel;

  const Home({Key? key, @required this.channel}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController controllers = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    widget.channel!.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web Sockets'),
      ),
      body: Column(
        children: [
          TextField(
            controller: controllers,
          ),
          ElevatedButton(
              onPressed: () {
                if (controllers.text.isNotEmpty) {
                  widget.channel!.sink.add(controllers.text);
                }
              },
              child: Text('Sent')),
          StreamBuilder(
              stream: widget.channel!.stream,
              builder: (context, snapshot) {
                return Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(snapshot.hasData ? snapshot.data.toString() : ''),
                );
              }),
        ],
      ),
    );
  }
}
