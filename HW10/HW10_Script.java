import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;

public class HW10_Script {
    public static void main (String[] args){
        try {
            writeToFile();
        }
        catch(IOException e) {
            throw new RuntimeException("No file found", e);
        }
    }
    public static void writeToFile() throws IOException {
        int sqlLength = 10000;
        int min = 12000;
        int max = 150000;
        while (sqlLength <= 1000000) {
            FileWriter fileWriter = new FileWriter("hw10-data-" + sqlLength + ".sql");
            PrintWriter pw = new PrintWriter(fileWriter);
            pw.print("INSERT INTO Employee VALUES\n");
            for (int i = 0; i < sqlLength; i+=4) {
                pw.println("(" + (i+1) + ", " + (new Random().nextInt((max - min) + 1) + min) + ", \"engineer\"),");
                pw.println("(" + (i+2) + ", " + (new Random().nextInt((max - min) + 1) + min) + ", \"manager\"),");
                pw.println("(" + (i+3) + ", " + (new Random().nextInt((max - min) + 1) + min) + ", \"salesperson\"),");
                pw.println("(" + (i+4) + ", " + (new Random().nextInt((max - min) + 1) + min) + ", \"administrator\"),");
            }
            sqlLength *= 10;
            fileWriter.close();
            pw.close();
        }
    }
}
