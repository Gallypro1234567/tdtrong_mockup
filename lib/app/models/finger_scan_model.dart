class Finger {
  String? code;
  String? message;
  String? dni;
  String? fingerCode;
  String? wspBase64;
  String? transactionId;
  String? imagePath;
  Finger({
    this.code,
    this.message,
    this.dni,
    this.fingerCode,
    this.wspBase64,
    this.transactionId,
    this.imagePath,
  });
  Finger.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    dni = json['dni'];
    fingerCode = json['finger_code'];
    wspBase64 = json['wsq_base64'];
    transactionId = json['transaction_id'];
    imagePath = json['image_path'];
  }
}
