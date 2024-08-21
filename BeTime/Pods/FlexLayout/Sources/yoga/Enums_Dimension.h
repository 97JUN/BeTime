/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

// @generated by enums.py
// clang-format off
#pragma once

#include <cstdint>
#include "YGEnums.h"
#include "Enums_YogaEnums.h"

namespace facebook::yoga {

enum class Dimension : uint8_t {
  Width = YGDimensionWidth,
  Height = YGDimensionHeight,
};

template <>
constexpr int32_t ordinalCount<Dimension>() {
  return 2;
}

constexpr Dimension scopedEnum(YGDimension unscoped) {
  return static_cast<Dimension>(unscoped);
}

constexpr YGDimension unscopedEnum(Dimension scoped) {
  return static_cast<YGDimension>(scoped);
}

inline const char* toString(Dimension e) {
  return YGDimensionToString(unscopedEnum(e));
}

} // namespace facebook::yoga
