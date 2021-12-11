#ifndef IHM_H
#define IHM_H
#include <stdint.h>
#include <sys/cdefs.h>
__BEGIN_DECLS
void compass_set_start_stop(uint32_t base, int start_stop);
void compass_set_continu(uint32_t base, int continu);
int compass_get_angle(uint32_t base);
__END_DECLS
#endif // IHM_H