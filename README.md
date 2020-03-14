# gravityPiano
V2-1

//需要安装Processing 3 运行 processing.org
//还需要准备自己的MIDI乐器

String midiOut = "Nord"; //<---这个改成你的MIDI乐器
float dampLow = 0.65; //球掉到低音时的反弹力，范围是0～1
float dampHigh = 0.9; //球掉到高音时的反弹力，范围是0～1
float wallDamp = 0.99; //球撞到墙的反弹力，范围是0～1

int[][] chord =  {{0, 2, 3, 7, 14, 15 }, {3, 5, 7, 10, 15, 19 },{0, 2, 4, 6, 8, 10 }};
//和弦设置，按空格转换
