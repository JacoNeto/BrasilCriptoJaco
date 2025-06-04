import 'package:json_annotation/json_annotation.dart';

part 'coin_data_model.g.dart';

@JsonSerializable()
class CoinDataModel {
  final String id;
  final String symbol;
  final String name;

  @JsonKey(name: 'image')
  final CoinImage image;

  @JsonKey(name: 'description')
  final Map<String, dynamic> description;

  @JsonKey(name: 'market_data')
  final MarketData marketData;

  CoinDataModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.description,
    required this.marketData,
  });

  factory CoinDataModel.fromJson(Map<String, dynamic> json) =>
      _$CoinDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$CoinDataModelToJson(this);
}

@JsonSerializable()
class CoinImage {
  final String large;

  CoinImage({required this.large});

  factory CoinImage.fromJson(Map<String, dynamic> json) =>
      _$CoinImageFromJson(json);

  Map<String, dynamic> toJson() => _$CoinImageToJson(this);
}

@JsonSerializable()
class MarketData {
  @JsonKey(name: 'current_price')
  final Map<String, dynamic> currentPrice;

  @JsonKey(name: 'market_cap')
  final Map<String, dynamic> marketCap;

  @JsonKey(name: 'total_volume')
  final Map<String, dynamic> totalVolume;

  @JsonKey(name: 'price_change_percentage_24h')
  final double? priceChange24h;

  @JsonKey(name: 'sparkline_7d')
  final SparklineData sparkline7d;

  MarketData({
    required this.currentPrice,
    required this.marketCap,
    required this.totalVolume,
    required this.priceChange24h,
    required this.sparkline7d,
  });

  factory MarketData.fromJson(Map<String, dynamic> json) =>
      _$MarketDataFromJson(json);

  Map<String, dynamic> toJson() => _$MarketDataToJson(this);
}

@JsonSerializable()
class SparklineData {
  final List<double> price;

  SparklineData({required this.price});

  factory SparklineData.fromJson(Map<String, dynamic> json) =>
      _$SparklineDataFromJson(json);

  Map<String, dynamic> toJson() => _$SparklineDataToJson(this);
}