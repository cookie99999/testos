#ifndef PIT_H
#define PIT_H

#define PIT_CHAN_0_DATA 0x40
#define PIT_CHAN_1_DATA 0x41
#define PIT_CHAN_2_DATA 0x42
#define PIT_COMMAND 0x43

#define PIT_CMD_READ_BACK 0xC0
#define PIT_READ_BACK_CHAN_0 0x02
#define PIT_READ_BACK_CHAN_1 0x04
#define PIT_READ_BACK_CHAN_2 0x08
#define PIT_READ_BACK_DONT_LATCH_COUNT 0x20
#define PIT_READ_BACK_DONT_LATCH_STATUS 0x10

#define PIT_CMD_CHAN_0 0x00
#define PIT_CMD_CHAN_1 0x40
#define PIT_CMD_CHAN_2 0x80

#define PIT_CMD_OPMODE_0 0x00       /***********************/
#define PIT_CMD_OPMODE_1 0x02
#define PIT_CMD_OPMODE_2 0x04        //these are shared between writing commands
#define PIT_CMD_OPMODE_3 0x06        //and the readback status byte
#define PIT_CMD_OPMODE_4 0x08
#define PIT_CMD_OPMODE_5 0x0a

#define PIT_CMD_ACC_MODE_LOBYTE 0x10
#define PIT_CMD_ACC_MODE_HIBYTE 0x20
#define PIT_CMD_ACC_MODE_LOHI 0x30

#define PIT_CMD_BCD 0x01            /***********************/
#define PIT_STAT_OUTPUT 0x80
#define PIT_STAT_NULL_COUNT 0x40

uint8_t pit_read_status(int channel);
uint16_t pit_read_count(int channel);
void pit_set_reload(int channel, uint16_t c);
void pit_set_mode(uint8_t mode);
#endif
