class RealEstateData {
  RealEstateData(
      {required this.id,
      required this.apartementStatusId,
      required this.apartementPostionInFloorId,
      required this.apartementPostionInBuildingId,
      required this.apartementLink,
      required this.isApartementHasEnoughData,
      required this.apartementName,
      this.responsibleName = '',
      this.responsiblePhone = '',
      this.ownerName = '',
      this.ownerMail = '',
      this.ownerPassword = '',
      this.ownerPhoneNumber = '',
      this.ownerRole = 0}) {
    if (!isApartementHasEnoughData) {
      responsibleName = 'None';
      responsiblePhone = 'None';
      ownerName = 'None';
      ownerMail = 'None';
      ownerPassword = '12345678910';
      ownerPhoneNumber = '01020314813';
      ownerRole = 0;
    }
  }
  int id;
  bool isApartementHasEnoughData;
  late String ownerName;
  late String ownerPhoneNumber;
  late int ownerRole;
  late String ownerMail;
  late String ownerPassword;
  late String responsibleName;
  late String responsiblePhone;
  String apartementLink;
  int apartementPostionInBuildingId;
  int apartementPostionInFloorId;
  int apartementStatusId;
  String apartementName;
  @override
  String toString() {
    return 'ID : $id || OwnerName : $ownerName || OwnerPhone : $ownerPhoneNumber || ownerMail $ownerMail'
        'ownerRole : $ownerRole || ownerPassword : $ownerPassword || apartementLink : $apartementLink'
        'Building Id : $apartementPostionInBuildingId || Floor Id : $apartementPostionInFloorId '
        'Apartement Name : $apartementName';
  }
}
