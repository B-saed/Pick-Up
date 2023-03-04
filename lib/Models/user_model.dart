class PickUpUser {
  final String uId;
  final String userName;
  final String userEmail;
  final bool isEmailVerified;
  final String? password;
  final String sha512;

  PickUpUser({
    required this.uId,
    required this.userName,
    required this.userEmail,
    required this.isEmailVerified,
    this.password,
    required this.sha512,
  });

  factory PickUpUser.fromJson(Map<String, dynamic> json) {
    return PickUpUser(
      uId: json['uId'],
      userName: json['userName'],
      userEmail: json['userEmail'],
      isEmailVerified: json['isEmailVerified'],
      sha512: json['sha512'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userEmail': userEmail,
      'isEmailVerified': isEmailVerified,
      'sha512': sha512,
      'uId': uId,
    };
  }
}

// class PickUpUser {
//   late String uId;
//   late String userName;
//   late String userPhoneNumber;
//   late String userEmail;
//   late bool isEmailVerified;
//   late bool isPhoneNumberVerified;
//   late String password;
//   late String sha512;
//
//   PickUpUser({
//
//     required this.uId,
//     required this.userName,
//     required this.userPhoneNumber,
//     required this.userEmail,
//     required this.isEmailVerified,
//     required this.isPhoneNumberVerified,
//     required this.password,
//     required this.sha512,
//   });
//
//   PickUpUser.fromJson(Map<String, dynamic> json) {
//     uId = json['uId'];
//     userName = json['userName'];
//     userPhoneNumber = json['userPhoneNumber'];
//     userEmail = json['userEmail'];
//     isEmailVerified = json['isEmailVerified'];
//     isPhoneNumberVerified = json['isPhoneNumberVerified'];
//     sha512 = json['sha512'];
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'userName': userName,
//       'userPhoneNumber': userPhoneNumber,
//       'userEmail': userEmail,
//       'isEmailVerified': isEmailVerified,
//       'sha512': sha512,
//       'uId':uId,
//     };
//   }
// }
