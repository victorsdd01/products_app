

class NewUser{

  String email;
  String password;

  NewUser({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() => {
    "email": email,
    "password": password,
    "returnSecureToken" : true,
  };
  
}


class User{
  String email;
  String password;

  User({
    required this.email,
    required this.password,
  });

  Map<String,dynamic> toMap() => {
    "email":email,
    "password":password,
    "returnSecureToken" : true,
  };
}