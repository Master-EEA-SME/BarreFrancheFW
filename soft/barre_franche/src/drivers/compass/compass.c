#include "compass.h"
#include "io.h"
void compass_set_start_stop(uint32_t base, int start_stop)
{
    IOWR_32DIRECT(base, 0, start_stop ? 1 : 0);
}
void compass_set_continu(uint32_t base, int continu)
{
    IOWR_32DIRECT(base, 0, continu ? 2 : 0);
}
int compass_get_angle(uint32_t base)
{
    return IORD_32DIRECT(base, 0) & 0x1FF;
}