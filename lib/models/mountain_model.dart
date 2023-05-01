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
  Service? service;
  String? status;
  Record? record;
  Page? page;
  Result? result;

  Response({this.service, this.status, this.record, this.page, this.result});

  Response.fromJson(Map<String, dynamic> json) {
    service =
        json['service'] != null ? Service.fromJson(json['service']) : null;
    status = json['status'];
    record = json['record'] != null ? Record.fromJson(json['record']) : null;
    page = json['page'] != null ? Page.fromJson(json['page']) : null;
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (service != null) {
      data['service'] = service!.toJson();
    }
    data['status'] = status;
    if (record != null) {
      data['record'] = record!.toJson();
    }
    if (page != null) {
      data['page'] = page!.toJson();
    }
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Service {
  String? name;
  String? version;
  String? operation;
  String? time;

  Service({this.name, this.version, this.operation, this.time});

  Service.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    version = json['version'];
    operation = json['operation'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['version'] = version;
    data['operation'] = operation;
    data['time'] = time;
    return data;
  }
}

class Record {
  String? total;
  String? current;

  Record({this.total, this.current});

  Record.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    current = json['current'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['current'] = current;
    return data;
  }
}

class Page {
  String? total;
  String? current;
  String? size;

  Page({this.total, this.current, this.size});

  Page.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    current = json['current'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['current'] = current;
    data['size'] = size;
    return data;
  }
}

class Result {
  FeatureCollection? featureCollection;

  Result({this.featureCollection});

  Result.fromJson(Map<String, dynamic> json) {
    featureCollection = json['featureCollection'] != null
        ? FeatureCollection.fromJson(json['featureCollection'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (featureCollection != null) {
      data['featureCollection'] = featureCollection!.toJson();
    }
    return data;
  }
}

class FeatureCollection {
  String? type;
  List<int>? bbox;
  List<Features>? features;

  FeatureCollection({this.type, this.bbox, this.features});

  FeatureCollection.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    bbox = json['bbox'].cast<int>();
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(Features.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['bbox'] = bbox;
    if (features != null) {
      data['features'] = features!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Features {
  String? type;
  Properties? properties;
  String? id;

  Features({this.type, this.properties, this.id});

  Features.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'])
        : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (properties != null) {
      data['properties'] = properties!.toJson();
    }
    data['id'] = id;
    return data;
  }
}

class Properties {
  String? upMin;
  String? downMin;
  String? catNam;
  String? secLen;
  String? mntnNm;

  Properties({this.upMin, this.downMin, this.catNam, this.secLen, this.mntnNm});

  Properties.fromJson(Map<String, dynamic> json) {
    upMin = json['up_min'];
    downMin = json['down_min'];
    catNam = json['cat_nam'];
    secLen = json['sec_len'];
    mntnNm = json['mntn_nm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['up_min'] = upMin;
    data['down_min'] = downMin;
    data['cat_nam'] = catNam;
    data['sec_len'] = secLen;
    data['mntn_nm'] = mntnNm;
    return data;
  }
}
