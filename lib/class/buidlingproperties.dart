class Building {
  Building({required this.buildingName, required this.id});
  int id;
  String buildingName;
  @override
  String toString() {
    String buildingData = 'Building No. $id ||'
        'Building Name : $buildingName';
    return buildingData;
  }
}

class Floor {
  Floor({required this.floorName, required this.id});
  int id;
  String floorName;
  @override
  String toString() {
    String floorData = 'Floor No. $id ||'
        'State : $floorName';
    return floorData;
  }
}

class ApartementStatus {
  ApartementStatus({required this.state, required this.id});
  int id;
  String state;
  @override
  String toString() {
    String statusData = 'State No. $id ||'
        'State : $override';
    return statusData;
  }
}
