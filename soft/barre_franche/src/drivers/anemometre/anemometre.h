#ifndef ANEMOMETRE_H
#define ANEMOMETRE_H
#include <stdint.h>
#include <sys/cdefs.h>
__BEGIN_DECLS
void anemometre_set_start_stop(uint32_t base, int start_stop);
void anemometre_set_continu(uint32_t base, int continu);
int anemometre_get_vitesse(uint32_t base);
__END_DECLS
#endif // ANEMOMETRE_H