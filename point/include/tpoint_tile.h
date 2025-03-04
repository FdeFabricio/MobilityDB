/*****************************************************************************
 *
 * This MobilityDB code is provided under The PostgreSQL License.
 *
 * Copyright (c) 2016-2021, Université libre de Bruxelles and MobilityDB
 * contributors
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without a written 
 * agreement is hereby granted, provided that the above copyright notice and
 * this paragraph and the following two paragraphs appear in all copies.
 *
 * IN NO EVENT SHALL UNIVERSITE LIBRE DE BRUXELLES BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING
 * LOST PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION,
 * EVEN IF UNIVERSITE LIBRE DE BRUXELLES HAS BEEN ADVISED OF THE POSSIBILITY 
 * OF SUCH DAMAGE.
 *
 * UNIVERSITE LIBRE DE BRUXELLES SPECIFICALLY DISCLAIMS ANY WARRANTIES, 
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS ON
 * AN "AS IS" BASIS, AND UNIVERSITE LIBRE DE BRUXELLES HAS NO OBLIGATIONS TO 
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS. 
 *
 *****************************************************************************/

/**
 * @file stbox.h
 * Functions for spatiotemporal bounding boxes.
 */

#ifndef __TPOINT_TILE_H__
#define __TPOINT_TILE_H__

#include "temporal.h"

/*****************************************************************************/

/**
 * Struct for storing the state that persists across multiple calls generating
 * a multidimensional grid
 */
typedef struct STboxGridState
{
  bool done;
  int i;
  double size;
  int64 tunits;
  STBOX box;
  Temporal *temp;
  double x;
  double y;
  double z;
  TimestampTz t;
} STboxGridState;

/*****************************************************************************/

extern Datum stbox_multidim_grid(PG_FUNCTION_ARGS);
extern Datum stbox_multidim_tile(PG_FUNCTION_ARGS);
extern Datum tpoint_space_split(PG_FUNCTION_ARGS);
extern Datum tpoint_space_time_split(PG_FUNCTION_ARGS);

/*****************************************************************************/

#endif
