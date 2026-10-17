// SPDX-FileCopyrightText: 2026 Jan Matyas <info@janmatyas.net>
// SPDX-License-Identifier: MIT

#include "htif.h"
#include "stddef.h"
#include "string.h"

/// Print a string to the Spike's stdout via the HTIF (Host-taget interface)
void print_text(const char* txt)
{
    for (size_t i = 0; i < strlen(txt); i++)
    {
        htif_putc(txt[i]);
    }
}

int main(int argc, char *argv[])
{
    print_text("infinite_loop: The program has started up and will spin indefinitely.\n");
    while (1);

    return 0;
}
