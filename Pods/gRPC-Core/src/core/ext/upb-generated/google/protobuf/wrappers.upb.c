/* This file was generated by upbc (the upb compiler) from the input
 * file:
 *
 *     google/protobuf/wrappers.proto
 *
 * Do not edit -- your changes will be discarded when the file is
 * regenerated. */

#include <stddef.h>
#include "upb/msg_internal.h"
#include "google/protobuf/wrappers.upb.h"

#include "upb/port_def.inc"

static const upb_msglayout_field google_protobuf_DoubleValue__fields[1] = {
  {1, UPB_SIZE(0, 0), 0, 0, 1, _UPB_MODE_SCALAR | (_UPB_REP_8BYTE << _UPB_REP_SHIFT)},
};

const upb_msglayout google_protobuf_DoubleValue_msginit = {
  NULL,
  &google_protobuf_DoubleValue__fields[0],
  UPB_SIZE(8, 8), 1, _UPB_MSGEXT_NONE, 1, 255,
};

static const upb_msglayout_field google_protobuf_FloatValue__fields[1] = {
  {1, UPB_SIZE(0, 0), 0, 0, 2, _UPB_MODE_SCALAR | (_UPB_REP_4BYTE << _UPB_REP_SHIFT)},
};

const upb_msglayout google_protobuf_FloatValue_msginit = {
  NULL,
  &google_protobuf_FloatValue__fields[0],
  UPB_SIZE(8, 8), 1, _UPB_MSGEXT_NONE, 1, 255,
};

static const upb_msglayout_field google_protobuf_Int64Value__fields[1] = {
  {1, UPB_SIZE(0, 0), 0, 0, 3, _UPB_MODE_SCALAR | (_UPB_REP_8BYTE << _UPB_REP_SHIFT)},
};

const upb_msglayout google_protobuf_Int64Value_msginit = {
  NULL,
  &google_protobuf_Int64Value__fields[0],
  UPB_SIZE(8, 8), 1, _UPB_MSGEXT_NONE, 1, 255,
};

static const upb_msglayout_field google_protobuf_UInt64Value__fields[1] = {
  {1, UPB_SIZE(0, 0), 0, 0, 4, _UPB_MODE_SCALAR | (_UPB_REP_8BYTE << _UPB_REP_SHIFT)},
};

const upb_msglayout google_protobuf_UInt64Value_msginit = {
  NULL,
  &google_protobuf_UInt64Value__fields[0],
  UPB_SIZE(8, 8), 1, _UPB_MSGEXT_NONE, 1, 255,
};

static const upb_msglayout_field google_protobuf_Int32Value__fields[1] = {
  {1, UPB_SIZE(0, 0), 0, 0, 5, _UPB_MODE_SCALAR | (_UPB_REP_4BYTE << _UPB_REP_SHIFT)},
};

const upb_msglayout google_protobuf_Int32Value_msginit = {
  NULL,
  &google_protobuf_Int32Value__fields[0],
  UPB_SIZE(8, 8), 1, _UPB_MSGEXT_NONE, 1, 255,
};

static const upb_msglayout_field google_protobuf_UInt32Value__fields[1] = {
  {1, UPB_SIZE(0, 0), 0, 0, 13, _UPB_MODE_SCALAR | (_UPB_REP_4BYTE << _UPB_REP_SHIFT)},
};

const upb_msglayout google_protobuf_UInt32Value_msginit = {
  NULL,
  &google_protobuf_UInt32Value__fields[0],
  UPB_SIZE(8, 8), 1, _UPB_MSGEXT_NONE, 1, 255,
};

static const upb_msglayout_field google_protobuf_BoolValue__fields[1] = {
  {1, UPB_SIZE(0, 0), 0, 0, 8, _UPB_MODE_SCALAR | (_UPB_REP_1BYTE << _UPB_REP_SHIFT)},
};

const upb_msglayout google_protobuf_BoolValue_msginit = {
  NULL,
  &google_protobuf_BoolValue__fields[0],
  UPB_SIZE(8, 8), 1, _UPB_MSGEXT_NONE, 1, 255,
};

static const upb_msglayout_field google_protobuf_StringValue__fields[1] = {
  {1, UPB_SIZE(0, 0), 0, 0, 9, _UPB_MODE_SCALAR | (_UPB_REP_STRVIEW << _UPB_REP_SHIFT)},
};

const upb_msglayout google_protobuf_StringValue_msginit = {
  NULL,
  &google_protobuf_StringValue__fields[0],
  UPB_SIZE(8, 16), 1, _UPB_MSGEXT_NONE, 1, 255,
};

static const upb_msglayout_field google_protobuf_BytesValue__fields[1] = {
  {1, UPB_SIZE(0, 0), 0, 0, 12, _UPB_MODE_SCALAR | (_UPB_REP_STRVIEW << _UPB_REP_SHIFT)},
};

const upb_msglayout google_protobuf_BytesValue_msginit = {
  NULL,
  &google_protobuf_BytesValue__fields[0],
  UPB_SIZE(8, 16), 1, _UPB_MSGEXT_NONE, 1, 255,
};

static const upb_msglayout *messages_layout[9] = {
  &google_protobuf_DoubleValue_msginit,
  &google_protobuf_FloatValue_msginit,
  &google_protobuf_Int64Value_msginit,
  &google_protobuf_UInt64Value_msginit,
  &google_protobuf_Int32Value_msginit,
  &google_protobuf_UInt32Value_msginit,
  &google_protobuf_BoolValue_msginit,
  &google_protobuf_StringValue_msginit,
  &google_protobuf_BytesValue_msginit,
};

const upb_msglayout_file google_protobuf_wrappers_proto_upb_file_layout = {
  messages_layout,
  NULL,
  9,
  0,
};

#include "upb/port_undef.inc"

