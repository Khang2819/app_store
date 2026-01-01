class AddressModel {
  final String fullName;
  final String phoneNumber;
  final String detailAddress;

  AddressModel({
    required this.fullName,
    required this.phoneNumber,
    required this.detailAddress,
  });

  Map<String, dynamic> toMap() => {
    'fullName': fullName,
    'phoneNumber': phoneNumber,
    'detailAddress': detailAddress,
  };
}
