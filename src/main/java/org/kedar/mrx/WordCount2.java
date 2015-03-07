package org.kedar.mrx;

import org.apache.hadoop.fs.Path;
import org.apache.hadoop.mapred.FileInputFormat;
import org.apache.hadoop.mapred.FileOutputFormat;
import org.apache.hadoop.mapred.JobClient;
import org.apache.hadoop.mapred.JobConf;

/**
 * Reproduces the example by same name from Hadoop In Action. The idea is to use built-in
 * hadoop classes to find the frequency of words in a given (large) document.
 */
public class WordCount2 {
    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("Usage: Run the class with input file and output file as two arguments ...");
        }
        JobClient client = new JobClient();
        JobConf conf = new JobConf(WordCount2.class);
        FileInputFormat.addInputPath(conf, new Path(args[0]));
    }
}
