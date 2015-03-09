package org.kedar.mrx;

import org.apache.hadoop.fs.Path;
import org.apache.hadoop.mapred.FileInputFormat;
import org.apache.hadoop.mapred.FileOutputFormat;
import org.apache.hadoop.mapred.JobClient;
import org.apache.hadoop.mapred.JobConf;
import org.apache.hadoop.mapred.lib.LongSumReducer;
import org.apache.hadoop.mapred.lib.TokenCountMapper;

import java.io.IOException;

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
        FileOutputFormat.setOutputPath(conf, new Path(args[1]));
        //mapper that tokenizes a line in the input on a word boundary and outputs the word and a 1
        //as soon as it sees a word
        conf.setMapperClass(TokenCountMapper.class);
        //reducer that sums up the counts of words used as keys.
        conf.setReducerClass(LongSumReducer.class);
        //combiner is the local reducer that is called before sending the output to reducer
        //here, we combine all the same keys and reduce them locally to improve performance
        conf.setCombinerClass(LongSumReducer.class); //typically, same as the reducer
        client.setConf(conf);
        try {
            JobClient.runJob(conf);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
