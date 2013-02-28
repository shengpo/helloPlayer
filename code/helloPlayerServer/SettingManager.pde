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

                                        if (pieces[0].equals("server_size:")) {
                                                serverWidth = int(pieces[1]);
                                                serverHeight = int(pieces[2]);
                                        }
                                        if (pieces[0].equals("server_location:")) {
                                                serverX = int(pieces[1]);
                                                serverY = int(pieces[2]);
                                        }
                                        if (pieces[0].equals("osc_port:")) {
                                                oscPort = int(pieces[1]);
                                        }
                                        if (pieces[0].equals("frame_rate:")) {
                                                frame_rate = int(pieces[1]);
                                        }
                                        if (pieces[0].equals("client_amount:")) {
                                                totalClientCount = int(pieces[1]);
                                        }
                                }
                        }else {
                                //error occured or file is empty
                                break;
                        }
                }
        }
}

