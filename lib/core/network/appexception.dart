class appException implements Exception {
  final msg;


  appException(this.msg);

  String toString() {
    return '$msg';
  }
}

class fetchdataException extends appException {
  fetchdataException([String? _msg])
    : super( _msg);
}

class badrequestException extends appException {
  badrequestException([String? _msg]) : super( _msg);
}

class unauthorizeException extends appException {
  unauthorizeException([String? _msg]) : super(_msg);
}

class invalidinputException extends appException {
  invalidinputException([String? _msg]) : super(_msg);
}

class NoInternetException extends appException {
  NoInternetException([String? _msg]) : super("No Internet Connection");
}
