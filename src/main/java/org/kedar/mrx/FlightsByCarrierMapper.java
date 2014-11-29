package org.kedar.mrx;

import au.com.bytecode.opencsv.CSVParser;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

public class FlightsByCarrierMapper extends
        Mapper<LongWritable, Text, Text, IntWritable> {
    @Override
    protected void map(LongWritable key, Text value, Context context)
            throws IOException, InterruptedException {
        if (key.get() > 0) {
            String[] lines = new
                    CSVParser().parseLine(value.toString());
            context.write(new Text(lines[8]), new IntWritable(1)); //the 8th index is that for the name of airline carrier
        }
    }
}