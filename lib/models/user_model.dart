class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final int fcMax;


  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fcMax
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'], 
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      fcMax: json['fcMax']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'fcMax': fcMax    
  };
}