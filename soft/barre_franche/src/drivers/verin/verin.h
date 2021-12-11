#ifndef VERIN_H
#define VERIN_H
#include <stdint.h>
#include <sys/cdefs.h>
__BEGIN_DECLS
void verin_set_pwm_frequency(uint32_t base, int frequency);
int verin_get_pwm_frequency(uint32_t base);
void verin_set_pwm_duty(uint32_t base, int duty);
int verin_get_pwm_duty(uint32_t base);
void verin_set_butee_gauche(uint32_t base, int butee);
int verin_get_butee_gauche(uint32_t base);
void verin_set_butee_droite(uint32_t base, int butee);
int verin_get_butee_droite(uint32_t base);
int verin_get_angle_barre(uint32_t base);
void verin_pwm_enable(uint32_t base);
void verin_pwm_disable(uint32_t base);
void verin_set_sens(uint32_t base, int sens);
int verin_get_sens(uint32_t base);
__END_DECLS
#endif // VERIN_H