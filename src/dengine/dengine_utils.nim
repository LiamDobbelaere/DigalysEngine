proc toBytes*(num: float32): array[4, uint8] =
  result = cast[array[4, uint8]](num)

proc toFloat32*(bytes: array[4, uint8]): float32 =
  result = cast[float32](bytes)

proc toBytes*(num: int32): array[4, uint8] =
  result = cast[array[4, uint8]](num)

proc toInt32*(bytes: array[4, uint8]): int32 =
  result = cast[int32](bytes)
