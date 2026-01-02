class AddressModel {
  final String fullName;
  final String phoneNumber;
  final String detailAddress;

  AddressModel({
    required this.fullName,
    required this.phoneNumber,
    required this.detailAddress,
  });

  // Chuyển từ Map Firestore sang Model
  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      detailAddress: map['detailAddress'] ?? '',
    );
  }

  // Chuyển từ Model sang Map để lưu lên Firestore
  Map<String, dynamic> toMap() => {
    'fullName': fullName,
    'phoneNumber': phoneNumber,
    'detailAddress': detailAddress,
  };
}
