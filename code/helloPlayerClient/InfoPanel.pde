public class InfoPanel {
        private PFont myFont = null;
        private int fontSize = 16;
        
        
        public InfoPanel(){
                myFont = createFont("Georgia", fontSize);
                textFont(myFont);
        }

        
        public void showClientInfo(){
                //show client basic info: server_IP, server_osc_port, ID, frame_rate, player_width, player_height, player_x, player_y, video_path
                int startX = 10;
                int startY = 5+fontSize;

                fill(255);
                text("[ client ID ] " + ID, startX, startY);
                text("[ client OSC port ] " + clientOscPort, startX, startY+fontSize);
                text("[ server IP : port ] " + serverIP + " : " + serverOscPort, startX, startY+fontSize*2);
                text("[ frame rate ] " + frame_rate, startX, startY+fontSize*3);
                text("[ player resolution ] " + playerWidth + " x " + playerHeight, startX, startY+fontSize*4);
                text("[ player location ] " + playerX + " , " + playerY, startX, startY+fontSize*5);
                text("[ video path ] " + videoPath, startX, startY+fontSize*6, playerWidth-startX*2, 200);
        }
        
        public int getFontSize(){
                return fontSize;
        }
}
