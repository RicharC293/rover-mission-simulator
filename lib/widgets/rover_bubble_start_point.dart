import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rover/notifier/rover_notifier.dart';

class RoverBubbleStartPoint extends StatefulWidget {
  const RoverBubbleStartPoint({super.key});

  @override
  State<RoverBubbleStartPoint> createState() => _RoverBubbleStartPointState();
}

class _RoverBubbleStartPointState extends State<RoverBubbleStartPoint> {
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
                children: [
                  const Text(
                    'Before start mission, please set the start point of the rover:',
                    style: TextStyle(color: Colors.white),
                  ),
                  Selector<RoverNotifier, (int, bool)>(
                      selector: (context, rover) =>
                          (rover.positionX, rover.isStartPointSet),
                      builder: (context, data, _) {
                        final positionX = data.$1;
                        final isStartPointSet = data.$2;
                        return Row(
                          children: [
                            const Text('X: ',
                                style: TextStyle(color: Colors.white)),
                            Slider(
                              value: positionX.toDouble(),
                              min: 0,
                              max: 200,
                              onChanged: isStartPointSet
                                  ? null
                                  : (value) {
                                      context.read<RoverNotifier>().positionX =
                                          value.toInt();
                                    },
                            ),
                            Text(
                              '$positionX',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        );
                      }),
                  Selector<RoverNotifier, (int, bool)>(
                      selector: (context, rover) =>
                          (rover.positionY, rover.isStartPointSet),
                      builder: (context, data, _) {
                        final positionY = data.$1;
                        final isStartPointSet = data.$2;
                        return Row(
                          children: [
                            const Text('Y: ',
                                style: TextStyle(color: Colors.white)),
                            Slider(
                              value: positionY.toDouble(),
                              min: 0,
                              max: 200,
                              onChanged: isStartPointSet
                                  ? null
                                  : (value) {
                                      context.read<RoverNotifier>().positionY =
                                          value.toInt();
                                    },
                            ),
                            Text('$positionY',
                                style: const TextStyle(color: Colors.white)),
                          ],
                        );
                      }),
                  Selector<RoverNotifier, bool>(
                      selector: (context, rover) => rover.isStartPointSet,
                      builder: (context, isStartPointSet, _) {
                        if (isStartPointSet) {
                          return const Offstage();
                        }
                        return TextButton(
                          onPressed: () {
                            context.read<RoverNotifier>().setStartPoint();
                          },
                          child: const Text(
                            'Set start point',
                            style: TextStyle(color: Colors.white),
                          ),
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
