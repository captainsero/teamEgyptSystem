// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_items.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CheckoutItemsAdapter extends TypeAdapter<CheckoutItems> {
  @override
  final int typeId = 0;

  @override
  CheckoutItems read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CheckoutItems(
      name: fields[0] as String,
      price: fields[1] as double,
      quantity: fields[2] as int,
      category: fields[3] as String,
      mainQuantity: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CheckoutItems obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.mainQuantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckoutItemsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
