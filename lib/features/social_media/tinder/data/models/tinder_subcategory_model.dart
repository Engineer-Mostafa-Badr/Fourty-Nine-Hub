class TinderSubCategoryModel {
  bool? _status;
  List<SubCategoryData>? _data;

  TinderSubCategoryModel({bool? status, List<SubCategoryData>? data}) {
    if (status != null) {
      _status = status;
    }
    if (data != null) {
      _data = data;
    }
  }

  bool? get status => _status;
  set status(bool? status) => _status = status;
  List<SubCategoryData>? get data => _data;
  set data(List<SubCategoryData>? data) => _data = data;

  TinderSubCategoryModel.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    if (json['data'] != null) {
      _data = <SubCategoryData>[];
      json['data'].forEach((v) {
        _data!.add(SubCategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    if (_data != null) {
      data['data'] = _data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategoryData {
  int? _overHeadFactor;
  String? _sId;
  bool? _isHidden;
  String? _parent;
  int? _dailyPrice;
  int? _portion;
  int? _providerPortion;
  int? _paymentFactor;
  int? _grossMoney;
  String? _picture;
  int? _index;
  String? _createdAt;
  String? _updatedAt;
  bool? _hasAuction;
  String? _nameAr;
  String? _nameEn;
  String? _nameCode;
  String? _enableChatAndCallButton;
  String? _paymentMethods;

  SubCategoryData(
      {int? overHeadFactor,
      String? sId,
      bool? isHidden,
      String? parent,
      int? dailyPrice,
      int? portion,
      int? providerPortion,
      int? paymentFactor,
      int? grossMoney,
      String? picture,
      int? index,
      String? createdAt,
      String? updatedAt,
      bool? hasAuction,
      String? nameAr,
      String? nameEn,
      String? nameCode,
      String? enableChatAndCallButton,
      String? paymentMethods}) {
    if (overHeadFactor != null) {
      _overHeadFactor = overHeadFactor;
    }
    if (sId != null) {
      _sId = sId;
    }
    if (isHidden != null) {
      _isHidden = isHidden;
    }
    if (parent != null) {
      _parent = parent;
    }
    if (dailyPrice != null) {
      _dailyPrice = dailyPrice;
    }
    if (portion != null) {
      _portion = portion;
    }
    if (providerPortion != null) {
      _providerPortion = providerPortion;
    }
    if (paymentFactor != null) {
      _paymentFactor = paymentFactor;
    }
    if (grossMoney != null) {
      _grossMoney = grossMoney;
    }
    if (picture != null) {
      _picture = picture;
    }
    if (index != null) {
      _index = index;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
    if (hasAuction != null) {
      _hasAuction = hasAuction;
    }
    if (nameAr != null) {
      _nameAr = nameAr;
    }
    if (nameEn != null) {
      _nameEn = nameEn;
    }
    if (nameCode != null) {
      _nameCode = nameCode;
    }
    if (enableChatAndCallButton != null) {
      _enableChatAndCallButton = enableChatAndCallButton;
    }
    if (paymentMethods != null) {
      _paymentMethods = paymentMethods;
    }
  }

  int? get overHeadFactor => _overHeadFactor;
  set overHeadFactor(int? overHeadFactor) => _overHeadFactor = overHeadFactor;
  String? get sId => _sId;
  set sId(String? sId) => _sId = sId;
  bool? get isHidden => _isHidden;
  set isHidden(bool? isHidden) => _isHidden = isHidden;
  String? get parent => _parent;
  set parent(String? parent) => _parent = parent;
  int? get dailyPrice => _dailyPrice;
  set dailyPrice(int? dailyPrice) => _dailyPrice = dailyPrice;
  int? get portion => _portion;
  set portion(int? portion) => _portion = portion;
  int? get providerPortion => _providerPortion;
  set providerPortion(int? providerPortion) =>
      _providerPortion = providerPortion;
  int? get paymentFactor => _paymentFactor;
  set paymentFactor(int? paymentFactor) => _paymentFactor = paymentFactor;
  int? get grossMoney => _grossMoney;
  set grossMoney(int? grossMoney) => _grossMoney = grossMoney;
  String? get picture => _picture;
  set picture(String? picture) => _picture = picture;
  int? get index => _index;
  set index(int? index) => _index = index;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  bool? get hasAuction => _hasAuction;
  set hasAuction(bool? hasAuction) => _hasAuction = hasAuction;
  String? get nameAr => _nameAr;
  set nameAr(String? nameAr) => _nameAr = nameAr;
  String? get nameEn => _nameEn;
  set nameEn(String? nameEn) => _nameEn = nameEn;
  String? get nameCode => _nameCode;
  set nameCode(String? nameCode) => _nameCode = nameCode;
  String? get enableChatAndCallButton => _enableChatAndCallButton;
  set enableChatAndCallButton(String? enableChatAndCallButton) =>
      _enableChatAndCallButton = enableChatAndCallButton;
  String? get paymentMethods => _paymentMethods;
  set paymentMethods(String? paymentMethods) =>
      _paymentMethods = paymentMethods;

  SubCategoryData.fromJson(Map<String, dynamic> json) {
    _overHeadFactor = json['over_head_factor'];
    _sId = json['_id'];
    _isHidden = json['is_hidden'];
    _parent = json['parent'];
    _dailyPrice = json['daily_price'];
    _portion = json['portion'];
    _providerPortion = json['provider_portion'];
    _paymentFactor = json['payment_factor'];
    _grossMoney = json['gross_money'];
    _picture = json['picture'];
    _index = json['index'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _hasAuction = json['has_auction'];
    _nameAr = json['nameAr'];
    _nameEn = json['nameEn'];
    _nameCode = json['nameCode'];
    _enableChatAndCallButton = json['enableChatAndCallButton'];
    _paymentMethods = json['paymentMethods'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['over_head_factor'] = _overHeadFactor;
    data['_id'] = _sId;
    data['is_hidden'] = _isHidden;
    data['parent'] = _parent;
    data['daily_price'] = _dailyPrice;
    data['portion'] = _portion;
    data['provider_portion'] = _providerPortion;
    data['payment_factor'] = _paymentFactor;
    data['gross_money'] = _grossMoney;
    data['picture'] = _picture;
    data['index'] = _index;
    data['createdAt'] = _createdAt;
    data['updatedAt'] = _updatedAt;
    data['has_auction'] = _hasAuction;
    data['nameAr'] = _nameAr;
    data['nameEn'] = _nameEn;
    data['nameCode'] = _nameCode;
    data['enableChatAndCallButton'] = _enableChatAndCallButton;
    data['paymentMethods'] = _paymentMethods;
    return data;
  }
}
