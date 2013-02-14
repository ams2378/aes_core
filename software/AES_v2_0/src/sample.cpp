#include “EfAes.h”
#include <fcntl.h>
#include <io.h>
#include <stdio.h>
#include <stdlib.h>
int main(int argc , char * argv[])
{
unsigned char key[16]={
0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88,
0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88
};
unsigned char vector[16]={
0x1f,0x32,0x43,0x51,0x56,0x98,0xaf,0xed,
0xab,0xc8,0x21,0x45,0x63,0x72,0xac,0xfc
};
unsigned char buff[4096];
int rd_fd,wr_fd, rdsz;
AesCtx context;
AesSetKey( &context , AES_KEY_128BIT,BLOCKMODE_CRT, key , vector );
rd_fd = open(“test.dat”, O_RDONLY);
14
wr_fd = open(“test.encoded”,O_WRONLY | O_CREAT);
setmode(rd_fd,O_BINARY);
setmode(wr_fd,O_BINARY);
while( (rdsz = read(rd_fd, buff ,4096)) > 0 )
{
// before last block , the block size should always be the multiply of 16
// the last block should be handled if the size is not a multiply of 16
AesEncryptCRT(&context , buff, buff, rdsz );
rdsz = AesRoundSize( rdsz, 16);
write( wr_fd , buff , rdsz );
}
close(rd_fd);
close(wr_fd);
}
