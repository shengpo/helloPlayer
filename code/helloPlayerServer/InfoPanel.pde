public class InfoPanel {
        private PFont myFont = null;
        private int fontSize = 16;
        
        
        public InfoPanel(){
                myFont = createFont("Georgia", fontSize);
                textFont(myFont);
        }

        
        public void showServerInfo(){
                //show server basic info: osc_port, frame_rate, client_amount,  server_width, server_height, server_x, server_y, play_audio?
                int startX = 10;
                int startY = 5+fontSize;

                fill(255);
                text("[ server ]", startX, startY);
                text("[ osc port ] " + oscPort, startX, startY+fontSize);
                text("[ frame rate ] " + frame_rate, startX, startY+fontSize*2);
                text("[ server resolution ] " + serverWidth + " x " + serverHeight, startX, startY+fontSize*3);
                text("[ server location ] " + serverX + " , " + serverY, startX, startY+fontSize*4);
                text("[ total clients ] " + totalClientCount, startX, startY+fontSize*5);
                text("[ audio ] ?" , startX, startY+fontSize*6);
        }
        
        public int getFontSize(){
                return fontSize;
        }
}
