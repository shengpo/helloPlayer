public class SettingManager {


        public SettingManager() {
        }


        public void load(String filePath) {
                String line = null;
                BufferedReader reader = createReader(filePath); 

                while (true) {
                        try {
                                line = reader.readLine();
                        }catch(IOException e) {
                                e.printStackTrace();
                                line = null;
                                break;
                        }

                        if (line != null) {
                                if (line.length() > 0) {
                                        String[] pieces = split(line, " ");

                                        if (pieces[0].equals("player_size:")) {
                                                playerWidth = int(pieces[1]);
                                                playerHeight = int(pieces[2]);
                                        }
                                        if (pieces[0].equals("player_location:")) {
                                                playerX = int(pieces[1]);
                                                playerY = int(pieces[2]);
                                        }
                                        if (pieces[0].equals("server_IP:")) {
                                               serverIP = pieces[1];
                                        }
                                        if (pieces[0].equals("server_osc_port:")) {
                                                serverOscPort = int(pieces[1]);
                                        }
                                        if (pieces[0].equals("client_osc_port:")) {
                                                clientOscPort = int(pieces[1]);
                                        }
                                        if (pieces[0].equals("frame_rate:")) {
                                                frame_rate = int(pieces[1]);
                                        }
                                        if (pieces[0].equals("client_ID:")) {
                                                ID = int(pieces[1]);
                                        }
                                        if (pieces[0].equals("video_path:")) {
                                                videoPath = pieces[1];
                                        }
                                }
                        }else {
                                //error occured or file is empty
                                break;
                        }
                }
        }
}

