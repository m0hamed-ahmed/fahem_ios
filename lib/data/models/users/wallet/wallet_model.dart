class WalletModel {
  final int walletId;
  final int userAccountId;
  final int? packageId;
  final int balance;
  final DateTime createdAt;

  WalletModel({
    required this.walletId,
    required this.userAccountId,
    this.packageId,
    required this.balance,
    required this.createdAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      walletId: int.parse(json['walletId'].toString()),
      userAccountId: int.parse(json['userAccountId'].toString()),
      packageId: json['packageId'] == null ? null : int.parse(json['packageId'].toString()),
      balance: int.parse(json['balance'].toString()),
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['createdAt'])),
    );
  }

  static Map<String, dynamic> toMap(WalletModel walletModel) {
    return {
      'walletId': walletModel.walletId,
      'userAccountId': walletModel.userAccountId,
      'packageId': walletModel.packageId,
      'balance': walletModel.balance,
      'createdAt': walletModel.createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  static List<WalletModel> fromJsonList (List<dynamic> list) => list.map<WalletModel>((item) => WalletModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<WalletModel> list) => list.map<Map<String, dynamic>>((item) => WalletModel.toMap(item)).toList();
}