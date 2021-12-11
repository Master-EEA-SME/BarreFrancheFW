#include "verin.h"
#include "io.h"
#define FREQUENCY_OFFSET    0
#define DUTY_OFFSET         4
#define BUTEE_GAUCHE_OFFSET 8
#define BUTEE_DROITE_OFFSET 12
#define CONTROL_OFFSET      16
#define ANGLE_BARRE_OFFSET  20
void verin_set_pwm_frequency(uint32_t base, int frequency)
{
    IOWR_32DIRECT(base, FREQUENCY_OFFSET, frequency);
}
int verin_get_pwm_frequency(uint32_t base)
{
    return IORD_32DIRECT(base, FREQUENCY_OFFSET);
}
void verin_set_pwm_duty(uint32_t base, int duty)
{
    IOWR_32DIRECT(base, DUTY_OFFSET, duty);
}
int verin_get_pwm_duty(uint32_t base)
{
    return IORD_32DIRECT(base, DUTY_OFFSET);
}
void verin_set_butee_gauche(uint32_t base, int butee)
{
    IOWR_32DIRECT(base, BUTEE_GAUCHE_OFFSET, butee);
}
int verin_get_butee_gauche(uint32_t base)
{
    return IORD_32DIRECT(base, BUTEE_GAUCHE_OFFSET);
}
void verin_set_butee_droite(uint32_t base, int butee)
{
    IOWR_32DIRECT(base, BUTEE_DROITE_OFFSET, butee);
}
int verin_get_butee_droite(uint32_t base)
{
    return IORD_32DIRECT(base, BUTEE_DROITE_OFFSET);
}
int verin_get_angle_barre(uint32_t base)
{
    return IORD_32DIRECT(base, ANGLE_BARRE_OFFSET);
}
void verin_pwm_enable(uint32_t base)
{
    IOWR_16DIRECT(base, CONTROL_OFFSET, 1);
}
void verin_pwm_disable(uint32_t base)
{
    IOWR_16DIRECT(base, CONTROL_OFFSET, 0);
}
void verin_set_sens(uint32_t base, int sens)
{
    IOWR_16DIRECT(base, CONTROL_OFFSET + 2, sens);
}
int verin_get_sens(uint32_t base)
{
    return IORD_16DIRECT(base, CONTROL_OFFSET + 2);
}
