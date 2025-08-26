class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String birthDate;
  final double weight;
  final double height;
  final int fcMax;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.birthDate,
    required this.weight,
    required this.height,
    required this.fcMax
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'], 
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      birthDate: json['birthDate'],      
      weight: json['weight'],
      height: json['height'],
      fcMax: json['fcMax']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'phoneNumber': phoneNumber,
    'birthDate': birthDate,
    'weight': weight,
    'height': height,
    'fcMax': fcMax    
  };
}