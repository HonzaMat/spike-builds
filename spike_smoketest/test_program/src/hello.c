// SPDX-FileCopyrightText: 2026 Jan Matyas <info@janmatyas.net>
// SPDX-License-Identifier: CC0-1.0

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

/// Decode a string using the trivial ROT13 cipher
void decode_rot13(const char* in_buf, char* out_buf)
{
    const char *in = in_buf;
    char *out = out_buf;

    while (*in != '\0')
    {
        if (*in >= 'A' && *in <= 'Z')
        {
            *out = 'A' + (*in - 'A' + 13) % 26;
        }
        else if (*in >= 'a' && *in <= 'z')
        {
            *out = 'a' + (*in - 'a' + 13) % 26;
        }
        else
        {
            *out = *in;
        }

        in++;
        out++;
    }

    *out = '\0';
}

const char* ciphertext = "Rirel vafgehpgvba frg jnagf gb or serr!";

int main(int argc, char *argv[])
{
    print_text("The ciphertext is: ");
    print_text(ciphertext);
    print_text("\n");

    char plaintext[strlen(ciphertext) + 1];
    decode_rot13(ciphertext, plaintext);

    print_text("The decoded text is: ");
    print_text(plaintext);
    print_text("\n");

    // Shut down spike
    htif_system_reset(0, 0);

    return 0;
}
