/*
 * Compatibility shim for jxrlib consumers that compile with NO_WINDOWS.
 * Upstream wmspecstring.h expects this file in that mode, but the 1.4.4
 * source archive does not provide it. Re-enter the regular SAL definitions
 * with NO_WINDOWS temporarily unset; they are portable annotation macros.
 */
#ifndef JXRLIB_WMSPECSTRINGCE_H
#define JXRLIB_WMSPECSTRINGCE_H

#ifdef NO_WINDOWS
#define JXRLIB_RESTORE_NO_WINDOWS
#undef NO_WINDOWS
#undef _WMSPECSTRING_H_
#include "wmspecstring.h"
#ifdef JXRLIB_RESTORE_NO_WINDOWS
#define NO_WINDOWS 1
#undef JXRLIB_RESTORE_NO_WINDOWS
#endif
#endif

#endif
