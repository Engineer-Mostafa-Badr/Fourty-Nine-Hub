class TinderSubCategoryModel {
  bool? _status;
  List<SubCategoryData>? _data;

  TinderSubCategoryModel({bool? status, List<SubCategoryData>? data}) {
    if (status != null) {
      this._status = status;
    }
    if (data != null) {
      this._data = data;
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
        _data!.add(new SubCategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    if (this._data != null) {
      data['data'] = this._data!.map((v) => v.toJson()).toList();
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
      this._overHeadFactor = overHeadFactor;
    }
    if (sId != null) {
      this._sId = sId;
    }
    if (isHidden != null) {
      this._isHidden = isHidden;
    }
    if (parent != null) {
      this._parent = parent;
    }
    if (dailyPrice != null) {
      this._dailyPrice = dailyPrice;
    }
    if (portion != null) {
      this._portion = portion;
    }
    if (providerPortion != null) {
      this._providerPortion = providerPortion;
    }
    if (paymentFactor != null) {
      this._paymentFactor = paymentFactor;
    }
    if (grossMoney != null) {
      this._grossMoney = grossMoney;
    }
    if (picture != null) {
      this._picture = picture;
    }
    if (index != null) {
      this._index = index;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
    if (hasAuction != null) {
      this._hasAuction = hasAuction;
    }
    if (nameAr != null) {
      this._nameAr = nameAr;
    }
    if (nameEn != null) {
      this._nameEn = nameEn;
    }
    if (nameCode != null) {
      this._nameCode = nameCode;
    }
    if (enableChatAndCallButton != null) {
      this._enableChatAndCallButton = enableChatAndCallButton;
    }
    if (paymentMethods != null) {
      this._paymentMethods = paymentMethods;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['over_head_factor'] = this._overHeadFactor;
    data['_id'] = this._sId;
    data['is_hidden'] = this._isHidden;
    data['parent'] = this._parent;
    data['daily_price'] = this._dailyPrice;
    data['portion'] = this._portion;
    data['provider_portion'] = this._providerPortion;
    data['payment_factor'] = this._paymentFactor;
    data['gross_money'] = this._grossMoney;
    data['picture'] = this._picture;
    data['index'] = this._index;
    data['createdAt'] = this._createdAt;
    data['updatedAt'] = this._updatedAt;
    data['has_auction'] = this._hasAuction;
    data['nameAr'] = this._nameAr;
    data['nameEn'] = this._nameEn;
    data['nameCode'] = this._nameCode;
    data['enableChatAndCallButton'] = this._enableChatAndCallButton;
    data['paymentMethods'] = this._paymentMethods;
    return data;
  }
}
