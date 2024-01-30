class PaymentData {
  PaymentData({
    required this.id,
    required this.apartementId,
    required this.apartementPostionInBuildingId,
    this.ownerName = '',
    this.ownerPhoneNumber = '',
    this.apartementName = '',
    required this.paymentDate,
    required this.paymentAmount,
    required this.paymentNote,
  });

  final int id;
  final int apartementId;
  final String apartementName;
  final int apartementPostionInBuildingId;
  final String ownerName;
  final String ownerPhoneNumber;
  final DateTime paymentDate;
  final double paymentAmount;
  final String paymentNote;

  @override
  String toString() {
    return 'ID : $id  ApartementID : $apartementId  Apartement Link :$apartementPostionInBuildingId'
        ' Owner Name : $ownerName '
        'Phone Number Of Owner : $ownerPhoneNumber ApartementName : $apartementName'
        'Payment Date : ${paymentDate.toString()} Payment Amount : $paymentAmount'
        'Payment Note : $paymentNote';
  }
}
