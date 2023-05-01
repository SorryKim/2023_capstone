class Mountain {
  Response? response;

  Mountain({this.response});

  Mountain.fromJson(Map<String, dynamic> json) {
    response =
        json['response'] != null ? Response.fromJson(json['response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (response != null) {
      data['response'] = response!.toJson();
    }
    return data;
  }
}

class Response {
  Header? header;
  Body? body;

  Response({this.header, this.body});

  Response.fromJson(Map<String, dynamic> json) {
    header = json['header'] != null ? Header.fromJson(json['header']) : null;
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (header != null) {
      data['header'] = header!.toJson();
    }
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class Header {
  String? resultCode;
  String? resultMsg;

  Header({this.resultCode, this.resultMsg});

  Header.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    resultMsg = json['resultMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resultCode'] = resultCode;
    data['resultMsg'] = resultMsg;
    return data;
  }
}

class Body {
  Items? items;
  int? numOfRows;
  int? pageNo;
  int? totalCount;

  Body({this.items, this.numOfRows, this.pageNo, this.totalCount});

  Body.fromJson(Map<String, dynamic> json) {
    items = json['items'] != null ? Items.fromJson(json['items']) : null;
    numOfRows = json['numOfRows'];
    pageNo = json['pageNo'];
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.toJson();
    }
    data['numOfRows'] = numOfRows;
    data['pageNo'] = pageNo;
    data['totalCount'] = totalCount;
    return data;
  }
}

class Items {
  List<Item>? item;

  Items({this.item});

  Items.fromJson(Map<String, dynamic> json) {
    if (json['item'] != null) {
      item = <Item>[];
      json['item'].forEach((v) {
        item!.add(Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (item != null) {
      data['item'] = item!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Item {
  String? frtrlId;
  String? placeNm;
  double? lot;
  String? orgnPlaceTpeCd;
  String? crtrDt;
  double? aslAltide;
  String? dscrtCn;
  String? orgnPlaceTpeNm;
  String? poiId;
  String? frtrlNm;
  double? lat;

  Item({
    this.frtrlId,
    this.placeNm,
    this.lot,
    this.orgnPlaceTpeCd,
    this.crtrDt,
    this.aslAltide,
    this.dscrtCn,
    this.orgnPlaceTpeNm,
    this.poiId,
    this.frtrlNm,
    this.lat,
  });

  Item.fromJson(Map<String, dynamic> json) {
    frtrlId = json['frtrlId'];
    placeNm = json['placeNm'];
    lot = json['lot'];
    orgnPlaceTpeCd = json['orgnPlaceTpeCd'];
    crtrDt = json['crtrDt'];
    aslAltide = json['aslAltide'];
    dscrtCn = json['dscrtCn'];
    orgnPlaceTpeNm = json['orgnPlaceTpeNm'];
    poiId = json['poiId'];
    frtrlNm = json['frtrlNm'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['frtrlId'] = frtrlId;
    data['placeNm'] = placeNm;
    data['lot'] = lot;
    data['orgnPlaceTpeCd'] = orgnPlaceTpeCd;
    data['crtrDt'] = crtrDt;
    data['aslAltide'] = aslAltide;
    data['dscrtCn'] = dscrtCn;
    data['orgnPlaceTpeNm'] = orgnPlaceTpeNm;
    data['poiId'] = poiId;
    data['frtrlNm'] = frtrlNm;
    data['lat'] = lat;
    return data;
  }
}

class Mountain2 {
  String? name;
  String? image;
  String? explanation;
  String? location;
  String? height;

  Mountain2({
    required this.name,
    required this.image,
    required this.explanation,
    required this.location,
    required this.height,
  });
}
