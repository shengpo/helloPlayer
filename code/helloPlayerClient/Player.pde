public class Player {
        private PApplet papplet = null;

//        private Movie movie = null;
        public Movie movie = null;
        private boolean isPlay = false;


        public Player(PApplet papplet, String filePath) {
                this.papplet = papplet;

                movie = new Movie(papplet, filePath);
                movie.frameRate(frame_rate);

                // Pausing the video at the first frame. 
                movie.play();
                movie.jump(0);
                movie.pause();
        }


        public void play() {
                //開始單次播放
                if(!isPlay){
                        movie.play();
                        isPlay = true;
                }
                
                //讀取影像
//                if (movie.available() == true) {
//                        movie.read();
//                }
                image(movie, 0, 0, playerWidth, playerHeight);
                               
                //判斷是否播放完畢, 若播放完畢則從頭開始
                if(movie.time() >= movie.duration()){
                        movie.stop();
                        movie.jump(0);
                        movie.pause();
                        isPlay = false;
                        isGoNextFrame = false;
                }
        }
}

