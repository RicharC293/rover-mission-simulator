import 'package:flutter/material.dart';
import 'package:rover/utils/mars_map.dart';
import 'package:rover/utils/movement_enum.dart';
import 'package:rover/widgets/huston_bubble.dart';

import '../utils/orientation_enum.dart';
import '../widgets/rover_bubble.dart';
import '../widgets/rover_bubble_orientation.dart';
import '../widgets/rover_bubble_start_point.dart';

class RoverNotifier extends ChangeNotifier {
  int _positionX = 0;
  int _positionY = 0;
  OrientationEnum _orientation = OrientationEnum.N;
  bool _isStartPointSet = false;
  bool _isOrientationSet = false;

  final ScrollController _scrollController = ScrollController();

  List<Widget> _roverCommunicationList = [];

  final _map = MarsMap.createRoversMap();

  int get positionX => _positionX;
  int get positionY => _positionY;
  OrientationEnum get orientation => _orientation;

  ScrollController get scrollController => _scrollController;

  bool get isStartPointSet => _isStartPointSet;
  bool get isOrientationSet => _isOrientationSet;

  bool get isAvailableToStart => _isStartPointSet && _isOrientationSet;

  List<Widget> get roverCommunicationList => _roverCommunicationList;

  set positionX(int value) {
    _positionX = value;
    notifyListeners();
  }

  set positionY(int value) {
    _positionY = value;
    notifyListeners();
  }

  Future<void> initMission() async {
    _roverCommunicationList = [
      const RoverBubble(
          message: 'Hello from the rover!, '
              'I now connected to the server... '
              'Waiting for your command 🖥️'),
    ];
    await Future.delayed(const Duration(milliseconds: 500));
    _roverCommunicationList = [
      ..._roverCommunicationList,
      const RoverBubbleStartPoint(),
    ];
    notifyListeners();
  }

  Future<void> setStartPoint() async {
    /// Check if point is available in map
    if (_map[_positionX][_positionX] == 1) {
      _roverCommunicationList = [
        ..._roverCommunicationList,
        const RoverBubble(
            message:
                'Sorry, this point is not available, please choose another one'),
      ];
      notifyListeners();
      _moveScrollToBottom();
      return;
    }
    _isStartPointSet = true;
    _roverCommunicationList = [
      ..._roverCommunicationList,
      const RoverBubbleOrientation(),
    ];
    notifyListeners();
    _moveScrollToBottom();
  }

  Future<void> setOrientation(String orientation) async {
    _orientation = OrientationEnum.values.firstWhere(
        (element) => element.value == orientation,
        orElse: () => OrientationEnum.N);
    _isOrientationSet = true;
    _roverCommunicationList = [
      ..._roverCommunicationList,
      RoverBubble(
          message:
              'Cool! The start point is ($positionX, $positionY) and your orientation is ${_orientation.description}'),
      const RoverBubble(
          message: 'Please insert the command: \n '
              'L: to set orientation to left\n'
              'R: to set orientation to right\n'
              'F: to move forward'),
    ];
    notifyListeners();
    _moveScrollToBottom();
  }

  Future<void> setCommand(String command) async {
    _roverCommunicationList = [
      ..._roverCommunicationList,
      HustonBubble(message: command)
    ];
    notifyListeners();
    _moveScrollToBottom();
    await setNewPosition(command);
  }

  Future<void> setNewPosition(String command) async {
    List<String> listOFCommands = command.toUpperCase().split('');
    for (var command in listOFCommands) {
      /// Simulate the delay of the rover
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!_setNewPosition(command)) break;
      _moveScrollToBottom();
    }
  }

  bool _setNewPosition(String command) {
    final movement = MovementEnum.values.firstWhere(
      (element) => element.name == command,
      orElse: () => MovementEnum.F,
    );
    bool success = true;
    switch (movement) {
      case MovementEnum.F:
        success = _moveForward();
        break;
      case MovementEnum.L:
        _moveLeft();
        break;
      case MovementEnum.R:
        _moveRight();
        break;
    }
    return success;
  }

  bool _moveForward() {
    bool success = false;

    /// Simulate the delay of the rover
    switch (_orientation) {
      case OrientationEnum.N:

        /// Check if point is available in map
        if (_positionY + 1 > 200) {
          _edgeLimit();
          break;
        } else if (_map[_positionX][_positionY + 1] == 1) {
          _obstacleDetected(_positionX, _positionY + 1);
          break;
        } else {
          _positionY++;
          _addNewPositionMessage();
          success = true;
        }
        break;
      case OrientationEnum.S:
        if (_positionY - 1 < 0) {
          _edgeLimit();
          break;
        } else if (_map[_positionX][_positionY - 1] == 1) {
          _obstacleDetected(_positionX, _positionY - 1);
          break;
        } else {
          _positionY--;
          _addNewPositionMessage();
          success = true;
        }
        break;
      case OrientationEnum.E:
        if (_positionX + 1 > 200) {
          _edgeLimit();
        } else if (_map[_positionX + 1][_positionY] == 1) {
          _obstacleDetected(_positionX + 1, _positionY);
        } else {
          _positionX++;
          _addNewPositionMessage();
          success = true;
        }
        break;
      case OrientationEnum.W:
        if (_positionX - 1 < 0) {
          _edgeLimit();
        } else if (_map[_positionX - 1][_positionY] == 1) {
          _obstacleDetected(_positionX - 1, _positionY);
        } else {
          _positionX--;
          _addNewPositionMessage();
          success = true;
        }
        break;
    }
    return success;
  }

  void _moveLeft() {
    switch (_orientation) {
      case OrientationEnum.N:
        _orientation = OrientationEnum.W;
        break;
      case OrientationEnum.S:
        _orientation = OrientationEnum.E;
        break;
      case OrientationEnum.E:
        _orientation = OrientationEnum.N;
        break;
      case OrientationEnum.W:
        _orientation = OrientationEnum.S;
        break;
    }
    _addNewPositionMessage();
  }

  void _moveRight() {
    switch (_orientation) {
      case OrientationEnum.N:
        _orientation = OrientationEnum.E;
        break;
      case OrientationEnum.S:
        _orientation = OrientationEnum.W;
        break;
      case OrientationEnum.E:
        _orientation = OrientationEnum.S;
        break;
      case OrientationEnum.W:
        _orientation = OrientationEnum.N;
        break;
    }
    _addNewPositionMessage();
  }

  void _addNewPositionMessage() {
    _roverCommunicationList = [
      ..._roverCommunicationList,
      RoverBubble(
          message:
              'The new position is: ($positionX, $positionY) and orientation is ${_orientation.description}'),
    ];
    notifyListeners();
    _moveScrollToBottom();
  }

  void _edgeLimit() {
    _roverCommunicationList = [
      ..._roverCommunicationList,
      RoverBubble(
          message: "Sorry, you reached the edge of the map, rover's"
              " position is ($positionX, $positionY) with orientation ${_orientation.description}"),
    ];
    notifyListeners();
    _moveScrollToBottom();
  }

  void _obstacleDetected(int obstacleX, int obstacleY) {
    _roverCommunicationList = [
      ..._roverCommunicationList,
      RoverBubble(
          message:
              "Sorry, you reached an obstacle in ($obstacleX, $obstacleY), rover's"
              " position is ($positionX, $positionY) with orientation ${_orientation.description}"),
    ];
    notifyListeners();
    _moveScrollToBottom();
  }

  void _moveScrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }
}
