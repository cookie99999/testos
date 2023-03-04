void main() {
  char* vram = (char*) 0xb8000;
  vram[0] = 0x0f;
  vram[1] = 'A';

  while (1)
    ;
}
