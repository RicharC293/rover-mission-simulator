import 'package:flutter/material.dart';

class RoverBubble extends StatefulWidget {
  const RoverBubble({super.key, required this.message});

  final String message;

  @override
  State<RoverBubble> createState() => _RoverBubbleState();
}

class _RoverBubbleState extends State<RoverBubble> {
  late double _opacity;
  @override
  void initState() {
    super.initState();
    _opacity = 0;
    Future.microtask(() {
      setState(() {
        _opacity = 1;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: _opacity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.red,
            backgroundImage: AssetImage('assets/images/rover.png'),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                widget.message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
