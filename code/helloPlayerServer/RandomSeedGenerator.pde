public class RandomSeedGenerator {
        private int randomseed = 10;        //server會設定一個大於0的seed供client使用


        public RandomSeedGenerator() {
                randomseed = (int)random(100);
                println("[server INFO] universal random seed is : " + randomseed);
        }


        public int getRandomSeed(){
                return randomseed;
        }
        
        
        public void getNewRandomSeed(){
                randomseed = (int)random(100);
                println("[server INFO] universal random seed is re-generated as : " + randomseed);
        }
}

