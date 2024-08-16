import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rover/notifier/rover_notifier.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _textEditingController;

  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    context.read<RoverNotifier>().initMission();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _sendInstruction() async {
    if (_textEditingController.text.isEmpty) {
      return;
    }
    _isLoading.value = true;
    await context.read<RoverNotifier>().setCommand(_textEditingController.text);
    _textEditingController.clear();
    _isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rover Mission'),
      ),
      body: Selector<RoverNotifier, List<Widget>>(
        selector: (context, rover) => rover.roverCommunicationList,
        builder: (context, roverCommunicationList, _) {
          return ListView(
            controller: context.read<RoverNotifier>().scrollController,
            padding: const EdgeInsets.all(16),
            children: roverCommunicationList,
          );
        },
      ),
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Selector<RoverNotifier, bool>(
          selector: (context, rover) => rover.isAvailableToStart,
          builder: (context, isAvailableToStart, _) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () {
                    if (!isAvailableToStart) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Please set the start point of the rover first!'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).clearSnackBars();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ValueListenableBuilder(
                        valueListenable: _isLoading,
                        builder: (context, isLoading, _) {
                          return Focus(
                            onFocusChange: (hasFocus) {
                              if (hasFocus) {
                                Future.delayed(
                                  const Duration(milliseconds: 275),
                                      () {
                                    context
                                        .read<RoverNotifier>()
                                        .scrollController
                                        .animateTo(
                                      context
                                          .read<RoverNotifier>()
                                          .scrollController
                                          .position
                                          .maxScrollExtent,
                                      duration: const Duration(
                                          milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                );
                              }
                            },
                            child: TextField(
                              enabled: isAvailableToStart && !isLoading,
                              controller: _textEditingController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: 'Enter your command here (L, R, F)',
                                suffixIcon: IconButton(
                                    onPressed:
                                    isLoading ? null : _sendInstruction,
                                    icon: const Icon(Icons.send)),
                              ),
                              onSubmitted: (_) => _sendInstruction(),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[LlRrFf]')),
                              ],
                            ),
                          );
                        }),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
