class ServerException implements Exception {
  final String messageAr;
  final String messageEn;

  ServerException({required this.messageAr, required this.messageEn});
}

class LocalException implements Exception {
  final String messageAr;
  final String messageEn;

  LocalException({required this.messageAr, required this.messageEn});
}