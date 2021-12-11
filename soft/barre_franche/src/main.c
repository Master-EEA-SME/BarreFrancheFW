#include <stdio.h>
#include "sys/alt_stdio.h"
#include <unistd.h>
#include "io.h"
#include "system.h"
#include "verin/verin.h"
#include "compass/compass.h"
#include "ihm/ihm.h"
#include "anemometre/anemometre.h"
void chennillard(void)
{
    for (int i = 0; i < 8; i++)
    {
        IOWR(LEDS_BASE, 0, 1 << i);
        usleep(100e3);
    }
    for (int i = 0; i < 8; i++)
    {
        IOWR(LEDS_BASE, 0, 0x80 >> i);
        usleep(100e3);
    }
}
void verin_va_et_vient()
{
    static int state = 0;
    switch (state)
    {
    case 0:
        if (verin_get_angle_barre(VERIN_BASE) < verin_get_butee_gauche(VERIN_BASE))
        {
            state = 1;
            verin_set_sens(VERIN_BASE, 1);
        }
        break;
    case 1:
        if (verin_get_angle_barre(VERIN_BASE) > verin_get_butee_droite(VERIN_BASE))
        {
            state = 0;
            verin_set_sens(VERIN_BASE, 0);
        }
        break;
    }
    
    
}
int main()
{
    alt_putstr("Hello from Nios II!\n");
    verin_set_butee_droite(VERIN_BASE, 2800);
    verin_set_butee_gauche(VERIN_BASE, 1400);
    printf("verin_butee_gauche = %d\n", verin_get_butee_gauche(VERIN_BASE));
    printf("verin_butee_droite = %d\n", verin_get_butee_droite(VERIN_BASE));
    verin_set_pwm_duty(VERIN_BASE, 32768);
    verin_set_pwm_frequency(VERIN_BASE, 132);
    verin_pwm_enable(VERIN_BASE);
    printf("verin_config_register = 0x%08X\n", IORD_32DIRECT(VERIN_BASE, 4));
    compass_set_continu(COMPASS_BASE, 1);
    anemometre_set_continu(ANEMOMETRE_BASE, 1);
    /* Event loop never exits. */
    while (1)
    {
        printf("anemometre_vitesse = %d\n", anemometre_get_vitesse(ANEMOMETRE_BASE));
        printf("compass_angle = %d\n", compass_get_angle(COMPASS_BASE));
        printf("verin_angle_barre = %d\n", verin_get_angle_barre(VERIN_BASE));
        printf("verin_get_sens = %d\n", verin_get_sens(VERIN_BASE));
        verin_va_et_vient();
        chennillard();
    }
    return 0;
}
