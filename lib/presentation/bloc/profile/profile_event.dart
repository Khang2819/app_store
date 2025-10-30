import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String name;
  UpdateProfile({required this.name});
}

class UploadAvatar extends ProfileEvent {
  final XFile imageFile;
  UploadAvatar({required this.imageFile});
}
