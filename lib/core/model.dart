import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';

part 'model.g.dart';

enum TransactionState {
  @JsonValue('verified')
  verified,
  @JsonValue('unverified')
  unverified,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('pending')
  pending,
  @JsonValue('unknown')
  unknown,
}

@freezed
class Transaction with _$Transaction {
  factory Transaction({
    @Default(TransactionState.unknown) final TransactionState state,
    @Default('') final String message,
    @Default('') final String description,
    @Default(0) final int transactionId,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}
