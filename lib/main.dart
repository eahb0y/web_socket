import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

void main() => runApp(const SocketTest());

class SocketTest extends StatefulWidget {
  const SocketTest({super.key});

  @override
  State<SocketTest> createState() => _SocketTestState();
}

class _SocketTestState extends State<SocketTest> {
  final TextEditingController controller = TextEditingController();
  List receiverMassages = [];
  final channel = IOWebSocketChannel.connect(
      'wss://free.blr2.piesocket.com/v3/1?api_key=IqrJcDLsW8xOCLuIPPmkmcuRoVBYGN7MBbutyPOC&notify_self=1');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: StreamBuilder(
            builder: (context, massage) {
              if (true != receiverMassages.contains(massage.data) &&
                  massage.hasData) receiverMassages.add(massage.data);
              return massage.data == null
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: ListView.separated(
                        reverse: true,
                        itemBuilder: (_, index) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: Ink(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(receiverMassages[index] ?? "",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 15),
                        itemCount: receiverMassages.length,
                      ),
                  );
            },
            stream: channel.stream,
          ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      channel.sink.add(controller.text);
                      controller.clear();
                    },
                    icon: const Icon(Icons.send_rounded,
                        color: Colors.blueAccent),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  )),
            ),
          )),
    );
  }
}
