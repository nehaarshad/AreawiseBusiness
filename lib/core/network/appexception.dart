class appException implements Exception {
  final msg;
  final prefix;

  appException([this.msg, this.prefix]);

  String toString() {
    return '$prefix,$msg';
  }
}

class fetchdataException extends appException {
  fetchdataException([String? _msg])
    : super( "Try Later!");
}

class badrequestException extends appException {
  badrequestException([String? _msg]) : super( "Invalid Request");
}

class unauthorizeException extends appException {
  unauthorizeException([String? _msg]) : super( "UnAuthorize requests");
}

class invalidinputException extends appException {
  invalidinputException([String? _msg]) : super("Invalid Input");
}
