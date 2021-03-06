#ifndef __PARSERS_H
#define __PARSERS_H

#include <stdint.h>
#include <stdbool.h>

#define ADDRESS (parse_number64, NULL)
#define ADDRESS32 (parse_number32, NULL)
#define DATA (parse_number64, NULL)
#define DATA32 (parse_number32, NULL)
#define DEFAULT_DATA(default) (parse_number64, default)
#define GPR (parse_gpr, NULL)
#define SPR (parse_spr, NULL)

uint64_t *parse_number64(const char *argv);
uint32_t *parse_number32(const char *argv);
int *parse_gpr(const char *argv);
int *parse_spr(const char *argv);
bool *parse_flag_noarg(const char *argv);

#endif
