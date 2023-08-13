class RealEstateData {
  RealEstateData(
      {required this.id,
      required this.apartementStatusId,
      required this.apartementPostionInFloorId,
      required this.apartementPostionInBuildingId,
      required this.apartementLink,
      required this.isApartementHasEnoughData,
      required this.apartementName,
      this.ownerName = '',
      this.ownerMail = '',
      this.ownerPassword = '',
      this.ownerPhoneNumber = '',
      this.ownerRole = ''}) {
    if (!isApartementHasEnoughData) {
      ownerName = 'None';
      ownerMail = 'None';
      ownerPassword = '12345678910';
      ownerPhoneNumber = '01020314813';
      ownerRole = 'None';
    }
  }
  int id;
  bool isApartementHasEnoughData;
  late String ownerName;
  late String ownerPhoneNumber;
  late String ownerRole;
  late String ownerMail;
  late String ownerPassword;
  String apartementLink;
  int apartementPostionInBuildingId;
  int apartementPostionInFloorId;
  int apartementStatusId;
  String apartementName;
}
