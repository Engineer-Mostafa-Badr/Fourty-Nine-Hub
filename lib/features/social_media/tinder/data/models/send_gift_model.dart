class SendGiftModel {
  bool? success;
  SendGiftErrorData? error;

  SendGiftModel({this.success, this.error});

  SendGiftModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'] != null
        ? SendGiftErrorData.fromJson(json['error'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (error != null) {
      data['error'] = error!.toJson();
    }
    return data;
  }
}

class SendGiftErrorData {
  String? name;
  int? httpCode;
  String? message;
  InnerSendGiftData? data;
  bool? isOperational;
  String? stack;
  String? domain;

  SendGiftErrorData(
      {this.name,
      this.httpCode,
      this.message,
      this.data,
      this.isOperational,
      this.stack,
      this.domain});

  SendGiftErrorData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    httpCode = json['httpCode'];
    message = json['message'];
    data =
        json['data'] != null ? InnerSendGiftData.fromJson(json['data']) : null;
    isOperational = json['isOperational'];
    stack = json['stack'];
    domain = json['domain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['httpCode'] = httpCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['isOperational'] = isOperational;
    data['stack'] = stack;
    data['domain'] = domain;
    return data;
  }
}

class InnerSendGiftData {
  InnerSendGiftData();

  InnerSendGiftData.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}
