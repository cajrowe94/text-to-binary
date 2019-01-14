import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;
import java.io.*;

//servo pins
int serv1 = 6;
int serv2 = 7;
int serv3 = 8;
int serv4 = 9;
int serv5 = 10;
int serv6 = 11;
int serv7 = 12;
int serv8 = 13;
//array to hold all words spoken
String [] spokenWords = new String[0];
int prevWordLength;
int newWordLength;
//array for the letters of split up words
ArrayList<Character> letters = new ArrayList<Character>(0);
int prevLetLength = 0;
int newLetLength;
//array to hold binary values of letters
ArrayList<String> binaryVals = new ArrayList<String>(0);
int prevBinLength = 0;
int newBinLength;

int[] pins = {6, 7, 8, 9, 10, 11, 12, 13};

//make arduino object
Arduino arduino;

void setup(){
  //read notepad file
  readData("C:/Users/cajrowe/Desktop/School Files/NMAT-W305/Servo Binary Converter/speechtoTextArduino.txt");
  prevWordLength = 0;  //intial array length
  
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(serv1, Arduino.SERVO);
  arduino.pinMode(serv2, Arduino.SERVO);
  arduino.pinMode(serv3, Arduino.SERVO);
  arduino.pinMode(serv4, Arduino.SERVO);
  arduino.pinMode(serv5, Arduino.SERVO);
  arduino.pinMode(serv6, Arduino.SERVO);
  arduino.pinMode(serv7, Arduino.SERVO);
  arduino.pinMode(serv8, Arduino.SERVO);

}

void draw() {
   //read text file
   readData("C:/Users/cajrowe/Desktop/School Files/NMAT-W305/Servo Binary Converter/speechtoTextArduino.txt");
   newWordLength = spokenWords.length; //update length of array to compare to old length

   //check if another word has been added
   if (prevWordLength != newWordLength){
     //split up each word into separate letters
     for (int i = prevWordLength; i < newWordLength; i++){
       splitWord(spokenWords[i]);
     }
     
     newLetLength = letters.size();
     //convert each letter to binary
     for (int i = prevLetLength; i < newLetLength; i++){
       binaryVals.add(lettertoBinary(letters.get(i)));
     }
     
     newBinLength = binaryVals.size();
   }
   
   if (prevBinLength != newBinLength){
     
     for (int i = prevBinLength; i < newBinLength; i++){
       delay(1000);
       turnOff();
       print(binaryVals.get(i) + "(" + letters.get(i) + ") ");
       onOrOff(binaryVals.get(i));
     }
   }
   //update all array lengths  
   prevBinLength = newBinLength;
   prevLetLength = newLetLength;
   prevWordLength = newWordLength;
 
}

void onOrOff(String binaryString){
  for (int i = 0; i < binaryString.length(); i++){
    if (binaryString.charAt(i) == '1'){
      arduino.servoWrite(pins[i], 180);
    } else arduino.servoWrite(pins[i], 5);
  }
  delay(1000);
  turnOff();
}

//splits up word into separate letters, puts them into an array
void splitWord(String word){
    for (int i = 0; i < word.length(); i++){    //loop across length of the word
      char nextLetter = word.charAt(i); //each loop, take the next letter and add to array
      letters.add(nextLetter);
    }
}

void turnOff(){
  arduino.servoWrite(serv1, 5);
  arduino.servoWrite(serv2, 5);
  arduino.servoWrite(serv3, 5);
  arduino.servoWrite(serv4, 5);
  arduino.servoWrite(serv5, 5);
  arduino.servoWrite(serv6, 5);
  arduino.servoWrite(serv7, 5);
  arduino.servoWrite(serv8, 5);
}

//long freaking function that converts a letter to it's binary value, returns the binary
String lettertoBinary(char letter){
  switch(letter){
    case 'A':
    case 'a':
      return "01100001";
    case 'B':
    case 'b':
      return "01100010";
    case 'C':
    case 'c':
      return "01100011";
    case 'D':
    case 'd':
      return "01100100";
    case 'E':
    case 'e':
      return "01100101";
    case 'F':
    case 'f':
      return "01100110";
    case 'G':
    case 'g':
      return "01100111";
    case 'H':
    case 'h':
      return "01101000";
    case 'I':
    case 'i':
      return "01101001";
    case 'J':
    case 'j':
      return "01101010";
    case 'K':
    case 'k':
      return "01101011";
    case 'L':
    case 'l':
      return "01101100";
    case 'M':
    case 'm':
      return "01101101";
    case 'N':
    case 'n':
      return "01101110";
    case 'O':
    case 'o':
      return "01101111";
    case 'P':
    case 'p':
      return "01110000";
    case 'Q':
    case 'q':
      return "01110001";
    case 'R':
    case 'r':
      return "01110010";
    case 'S':
    case 's':
      return "01110011";
    case 'T':
    case 't':
      return "01110100";
    case 'U':
    case 'u':
      return "01110101";
    case 'V':
    case 'v':
      return "01110110";
    case 'W':
    case 'w':
      return "01110111";
    case 'X':
    case 'x':
      return "01111000";
    case 'Y':
    case 'y':
      return "01111001";
    case 'Z':
    case 'z':
      return "01111010";
    default:
      return "00000000";
  }
}

//reads data from a text file
void readData(String myFileName){
 
 File file = new File(myFileName);
 BufferedReader br = null;
 
 try {
   br = new BufferedReader(new FileReader(file));
   String text = null;
 
     /* keep reading each line until you get to the end of the file */
     while ((text = br.readLine()) != null){
       /* Spilt each line up into bits and pieces using a comma as a separator */
       spokenWords = splitTokens(text, " ");
     }
 } catch (FileNotFoundException e){
     e.printStackTrace();
 } catch (IOException e){
     e.printStackTrace();
 } finally {
 try {
   if (br != null){
     br.close();
   }
 } catch (IOException e) {
     e.printStackTrace();
   }
 }
}