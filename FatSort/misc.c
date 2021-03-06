/*
	FATSort, utility for sorting FAT directory structures
	Copyright (C) 2004 Boris Leidner <fatsort(at)formenos.de>

	This program is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License
	as published by the Free Software Foundation; either version 2
	of the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

/*
	This file contains/describes miscellaneous functions.
*/

#include "misc.h"

#include <stdarg.h>
#include <stdio.h>
#include "options.h"
#include "mallocv.h"

void infomsg(char *str, ...) {
/*
	info messages that can be muted with a command line option
*/
	va_list argptr;

	if (!OPT_QUIET) {
		va_start(argptr,str);
		vprintf(str,argptr);
		va_end(argptr);
	}

}
