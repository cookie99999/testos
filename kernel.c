void main() {
  char* vram = (char*) 0xb8000;
  vram[0] = 'A';
  vram[1] = 0x0f;

  while (1)
    ;
}
