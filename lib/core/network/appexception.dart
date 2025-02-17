
class appException implements Exception{
  final msg;
  final prefix;

  appException([this.msg,this.prefix]);

  String toString(){
    return '$prefix,$msg';
  }
}

class fetchdataException extends appException{
  fetchdataException ([String? _msg]) : super(_msg,"Error during communication");
}

class badrequestException extends appException{
  badrequestException ([String? _msg]) : super(_msg,"Invalid Request");
}

class unauthorizeException extends appException{
  unauthorizeException ([String? _msg]) : super(_msg,"Unauthorize requests");
}

class invalidinputException extends appException{
  invalidinputException ([String? _msg]) : super(_msg,"Invalid Input");
}
