String getKey(){
  String ma = "MBSD.";
  String time = DateTime.now().microsecondsSinceEpoch.toString();
  return "$ma${randomStr()}${time.substring(0,4)}.${randomStr()}${time.substring(4,8)}.${randomStr()}${time.substring(time.length-4)}";
}


String randomStr(){
  List<String> lstText = ['A','B','C','D','E','F','G','L','I','J','M','N','T','K','P','W','X','Y','Z'];
  return (lstText..shuffle()).first;
}