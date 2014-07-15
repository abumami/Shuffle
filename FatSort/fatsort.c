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
	This file contains the main function of fatsort.
*/

#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <string.h>
#include <unistd.h>
#include <stdarg.h>
#include <assert.h>
#include <errno.h>
#include <locale.h>
#include <time.h>

// project includes
#include "endianness.h"
#include "signal.h"
#include "FAT_fs.h"
#include "options.h"
#include "errors.h"
#include "sort.h"
#include "clusterchain.h"
#include "misc.h"
#include "platform.h"
#include "mallocv.h"


int fs(char *filename, char *incl) {

	// initialize rng
	srand(time(0));

	// use locale from environment
	if (setlocale(LC_ALL, "") == NULL) {
		myerror("Could not set locale!");
		return -1;
	}

	// initialize blocked signals
	init_signal_handling();

    if (set_options(incl) == -1) {
    	myerror("Failed to parse options!");
    	return -1;
    }

    if (sortFileSystem(filename) == -1) {
        myerror("Failed to sort file system!");
        return -1;
    }

    
	freeOptions();
	
	// report mallocv debugging information
	REPORT_MEMORY_LEAKS

	return 0;
}
