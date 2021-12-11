#include "ihm.h"
#include "io.h"
int ihm_get_code_fonction(uint32_t base)
{
    return IORD_32DIRECT(base, 0);
}