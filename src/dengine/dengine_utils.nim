# TODO: test
proc toBytes*(num: float32): array[4, uint8] =
  result = cast[array[4, uint8]](num)

# TODO: test
proc toFloat32*(bytes: array[4, uint8]): float32 =
  result = cast[float32](bytes)
