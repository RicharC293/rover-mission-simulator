class MarsMap {
  // Create rovers map 200x200 free spaces are represented by 0 and obstacles by 1
  static List<List<int>> createRoversMap() {
    List<List<int>> roversMap = List.generate(
        200, (index) => List.generate(200, (index) => 0));
    // Add obstacles
    roversMap[0][5] = 1;
    roversMap[1][1] = 1;
    return roversMap;
  }

}