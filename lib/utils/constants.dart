class Constants {
  static const defaultPageSize = 10;
  static const defaultReadingPageSize = 100;
  static List<String> charactersToRemoveList = ['`','~','!','@','#','%','^','&','*','(',')','=','+','[',']','{','}','|',':',';','"','\'','<','>',',','.','?','/'];
  static RegExp charactersToRemove = RegExp('[${charactersToRemoveList.map((e) => '\\$e').join('')}]');
}
