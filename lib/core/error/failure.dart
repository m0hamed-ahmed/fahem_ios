abstract class Failure {
  final String messageAr;
  final String messageEn;

  Failure({required this.messageAr, required this.messageEn});
}

class ServerFailure extends Failure {
  ServerFailure({required super.messageAr, required super.messageEn});
}

class LocalFailure extends Failure {
  LocalFailure({required super.messageAr, required super.messageEn});
}