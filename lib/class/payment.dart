class PaymentData {
  PaymentData({
    required this.id,
    required this.apartementId,
    this.ownerName = '',
    this.ownerPhoneNumber = '',
    this.responsibleName = '',
    required this.paymentDate,
    required this.paymentAmount,
    required this.paymentNote,
  });

  final int id;
  final int apartementId;
  final String ownerName;
  final String ownerPhoneNumber;
  final String responsibleName;
  final DateTime paymentDate;
  final double paymentAmount;
  final String paymentNote;

  @override
  String toString() {
    return 'ID : $id  ApartementID : $apartementId  Owner Name : $ownerName '
        'Phone Number Of Owner : $ownerPhoneNumber Responsible Name : $responsibleName'
        'Payment Date : ${paymentDate.toString()} Payment Amount : $paymentAmount'
        'Payment Note : $paymentNote';
  }
}
