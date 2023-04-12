class Auth {

  String kind;
  String idToken;
  String email;
  String refreshToken;
  String expiresIn;
  String localId;

  Auth({
    required this.kind,
    required this.idToken,
    required this.email,
    required this.refreshToken,
    required this.expiresIn,
    required this.localId,
  });

  factory Auth.fromMap(Map<String,dynamic> json) => Auth(
    kind: json['kind'], 
    idToken: json['idToken'], 
    email: json['email'], 
    refreshToken: json['refreshToken'], 
    expiresIn: json['expiresIn'], 
    localId: json['localId'],
  );


  Map<String, dynamic> toMap() => {
    "kind": kind,
    "idToken": idToken,
    "email": email,
    "refreshToken": refreshToken,
    "expiresIn": expiresIn,
    "localId": localId,
  };

}

class AuthLogin{

  String kind;
  String localId;
  String email;
  String displayName;
  String idToken;
  bool registered;

  AuthLogin({
    required this.kind,
    required this.localId,
    required this.email,
    required this.displayName,
    required this.idToken,
    required this.registered,
  });

  factory AuthLogin.fromMap(Map<String,dynamic> json) => AuthLogin(
      kind       : json ['kind'],
      localId    : json ['localId'],
      email      : json ['email'],
      displayName: json ['displayName'],
      idToken    : json ['idToken'], 
      registered : json ['registered']
  );

  Map<String,dynamic> topMap() => {
    "kind": kind,
    "localId": localId,
    "email": email,
    "displayName": displayName,
    "idToken": idToken,
    "registered": registered,
  };
  
}


class AuthError {

  int code;
  String message;
   AuthError({
    required this.code,
    required this.message,
   });
  
  factory AuthError.fromMap(Map<String,dynamic> json) => AuthError(
    code: json['code'], 
    message: json['message']
  );
}

class PermissionDenied {

  String error;
  PermissionDenied({
    required this.error,
  });

  factory PermissionDenied.fromMap(Map<String,dynamic> json) => PermissionDenied(
    error: json['error'],
  );

}