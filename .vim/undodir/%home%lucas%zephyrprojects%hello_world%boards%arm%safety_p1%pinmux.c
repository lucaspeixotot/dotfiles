Vim�UnDo� W�F�m��	�W��Cb0TC�	�7��k��   U   8    {STM32_PIN_PC6, STM32F4_PINMUX_FUNC_PG14_USART6_TX},                             \�b�    _�                           ����                                                                                                                                                                                                                                                                                                                                                             \�b�     �         U      7    {STM32_PIN_PC7, STM32F4_PINMUX_FUNC_PG9_USART6_RX},�         U    5�_�                       C    ����                                                                                                                                                                                                                                                                                                                                                             \�b�     �         U      f    {STM32_PIN_PC7, (STM32_PINMUX_ALT_FUNC_8 | STM32_PUPDR_NO_PULL)STM32F4_PINMUX_FUNC_PG9_USART6_RX},5�_�                           ����                                                                                                                                                                                                                                                                                                                                                             \�b�     �         U      8    {STM32_PIN_PC6, STM32F4_PINMUX_FUNC_PG14_USART6_TX},�         U    5�_�                        E    ����                                                                                                                                                                                                                                                                                                                                                             \�b�    �   T   V          ^SYS_INIT(pinmux_stm32_init, PRE_KERNEL_1, CONFIG_PINMUX_STM32_DEVICE_INITIALIZATION_PRIORITY);�   S   U           �   R   T          }�   Q   S              return 0;�   P   R           �   O   Q          3    stm32_setup_pins(pinconf, ARRAY_SIZE(pinconf));�   N   P           �   M   O              ARG_UNUSED(port);�   L   N          {�   K   M          1static int pinmux_stm32_init(struct device *port)�   J   L           �   I   K          };�   H   J           �   G   I          #endif /* CONFIGfCAN_1 */�   F   H          H    {STM32_PIN_PB13, (STM32_PINMUX_ALT_FUNC_9 | STM32_PUSHPULL_NOPULL)},�   E   G          F    {STM32_PIN_PB12, (STM32_PINMUX_ALT_FUNC_9 | STM32_PUPDR_PULL_UP)},�   D   F          #ifdef CONFIG_CAN_2�   C   E           �   B   D          #endif /* CONFIG_CAN_1 */�   A   C          H    {STM32_PIN_PA12, (STM32_PINMUX_ALT_FUNC_9 | STM32_PUSHPULL_NOPULL)},�   @   B          F    {STM32_PIN_PA11, (STM32_PINMUX_ALT_FUNC_9 | STM32_PUPDR_PULL_UP)},�   ?   A          #ifdef CONFIG_CAN_1�   >   @           �   =   ?          #endif�   <   >          7    {STM32_PIN_PA7, STM32F4_PINMUX_FUNC_PA7_SPI1_MOSI},�   ;   =          7    {STM32_PIN_PA6, STM32F4_PINMUX_FUNC_PA6_SPI1_MISO},�   :   <          6    {STM32_PIN_PA5, STM32F4_PINMUX_FUNC_PA5_SPI1_SCK},�   9   ;          :    /*{STM32_PIN_PA4, STM32F4_PINMUX_FUNC_PA4_SPI1_NSS},*/�   8   :          #ifdef CONFIG_SPI_1�   7   9           �   6   8          #endif /* CONFIG_SPI_1 */�   5   7           �   4   6          G    {STM32_PIN_PB5, (STM32_PINMUX_ALT_FUNC_6 | STM32_PUSHPULL_NOPULL)},�   3   5          G    {STM32_PIN_PB4, (STM32_PINMUX_ALT_FUNC_6 | STM32_PUSHPULL_NOPULL)},�   2   4          X     (STM32_PINMUX_ALT_FUNC_6 | STM32_PUSHPULL_NOPULL | STM32_OSPEEDR_VERY_HIGH_SPEED)},�   1   3              {STM32_PIN_PB3,�   0   2          :    // {STM32_PIN_PA15, STM32F4_PINMUX_FUNC_PA4_SPI1_NSS},�   /   1          #ifdef CONFIG_SPI_3�   .   0           �   -   /          	// #endif�   ,   .          6// 	{STM32_PIN_PB9, STM32F4_PINMUX_FUNC_PB9_I2C1_SDA},�   +   -          6// 	{STM32_PIN_PB8, STM32F4_PINMUX_FUNC_PB8_I2C1_SCL},�   *   ,          // #ifdef CONFIG_I2C_1�   )   +          #// #endif	/* CONFIG_USB_DC_STM32 */�   (   *          9// 	{STM32_PIN_PA12, STM32F4_PINMUX_FUNC_PA12_OTG_FS_DP},�   '   )          9// 	{STM32_PIN_PA11, STM32F4_PINMUX_FUNC_PA11_OTG_FS_DM},�   &   (          // #ifdef CONFIG_USB_DC_STM32�   %   '          "// #endif /* CONFIG_PWM_STM32_2 */�   $   &          6// 	{STM32_PIN_PA0, STM32F4_PINMUX_FUNC_PA0_PWM2_CH1},�   #   %          // #ifdef CONFIG_PWM_STM32_2�   "   $           �   !   #          d#endif                                                                    /* #ifdef CONFIG_UART_5 */�       "          O    {STM32_PIN_PC12, (STM32_PINMUX_ALT_FUNC_8 | STM32_PUSHPULL_NOPULL)},  // TX�      !          O    {STM32_PIN_PD2, (STM32_PINMUX_ALT_FUNC_8 | STM32_PUSHPULL_NOPULL)},   // RX�                 #ifdef CONFIG_UART_5�                 �                !#endif /* #ifdef CONFIG_UART_4 */�                G    {STM32_PIN_PA1, (STM32_PINMUX_ALT_FUNC_8 | STM32_PUSHPULL_NOPULL)},�                G    {STM32_PIN_PA0, (STM32_PINMUX_ALT_FUNC_8 | STM32_PUSHPULL_PULLUP)},�                #ifdef CONFIG_UART_4�                #endif /* CONFIG_UART_6 */�                E    {STM32_PIN_PC7, (STM32_PINMUX_ALT_FUNC_8 | STM32_PUPDR_NO_PULL)},�                G    {STM32_PIN_PC6, (STM32_PINMUX_ALT_FUNC_8 | STM32_PUSHPULL_NOPULL)},�                #ifdef CONFIG_UART_6�                 �                d#endif                                                                    /* #ifdef CONFIG_UART_3 */�                O    {STM32_PIN_PC11, (STM32_PINMUX_ALT_FUNC_7 | STM32_PUSHPULL_NOPULL)},  // TX�                O    {STM32_PIN_PC10, (STM32_PINMUX_ALT_FUNC_7 | STM32_PUSHPULL_PULLUP)},  // RX�                #ifdef CONFIG_UART_3�                 �                ,static const struct pin_config pinconf[] = {�                -/* pin assignments for NUCLEO-F413ZH board */�                 �                #include <sys_io.h>�   
             &#include <pinmux/stm32/pinmux_stm32.h>�   	             #include <pinmux.h>�      
          #include <kernel.h>�      	          #include <init.h>�                #include <device.h>�                 �                 */�                & * SPDX-License-Identifier: Apache-2.0�                 *�                / * Copyright (c) 2017 Florian Vaussard, HEIG-VD�                 /*�         U      i    {STM32_PIN_PC6, (STM32_PINMUX_ALT_FUNC_8 | STM32_PUSHPULL_NOPULL)STM32F4_PINMUX_FUNC_PG14_USART6_TX},5�_�                            ����                                                                                                                                                                                                                                                                                                                                                             \�b�     �         U    �         U       5��