import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rover/notifier/rover_notifier.dart';
import 'package:rover/widgets/orientation_button.dart';

class RoverBubbleOrientation extends StatefulWidget {
  const RoverBubbleOrientation({super.key});

  @override
  State<RoverBubbleOrientation> createState() => _RoverBubbleOrientationState();
}

class _RoverBubbleOrientationState extends State<RoverBubbleOrientation> {
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

  void _setOrientation(String orientation) {
    context.read<RoverNotifier>().setOrientation(orientation);
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
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Before start mission, please set the orientation of the rover:',
                    style: TextStyle(color: Colors.white),
                  ),
                  Consumer<RoverNotifier>(builder: (context, notifier, _) {
                    if (notifier.isOrientationSet) {
                      return Text(
                        'Orientation set! ${notifier.orientation}',
                        style: const TextStyle(color: Colors.white),
                      );
                    }
                    return Row(
                      children: [
                        OrientationButton(
                          orientation: 'N',
                          onTap: _setOrientation,
                        ),
                        OrientationButton(
                          orientation: 'S',
                          onTap: _setOrientation,
                        ),
                        OrientationButton(
                          orientation: 'E',
                          onTap: _setOrientation,
                        ),
                        OrientationButton(
                          orientation: 'W',
                          onTap: _setOrientation,
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
