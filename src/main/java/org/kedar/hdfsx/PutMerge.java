package org.kedar.hdfsx;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.*;

import java.io.IOException;

/**
 * Created by kedar on 12/17/14.
 * Example from Hadoop In Action demonstrating the programmatic access to HDFS.
 * This (access to HDFS directly) is not typical. Typically, Hadoop works well with large files, files that
 * other file systems might be overwhelmed with. So, this class "concatenates" given files. Refer to a
 * shell script in this project, putmerge.sh, that uses this class.
 */
public class PutMerge {
    public static void main(String[] args) throws IOException {
        Configuration conf = new Configuration(); //thread-unsafe, this reference escapes during construction of Configuration!
        FileSystem hdfs = FileSystem.get(conf);
        FileSystem local = FileSystem.getLocal(conf);
        Path inputDir = new Path(args[0]);
        Path hdfsFile = new Path(args[1]);
        FSDataInputStream in = null;
        FSDataOutputStream out = null;
        try {
            FileStatus[] inputFiles = local.listStatus(inputDir);
            out = hdfs.create(hdfsFile);
            for (int i = 0; i < inputFiles.length; i++) {
                in = local.open(inputFiles[i].getPath());
                byte[] buffer = new byte[1024];
                int bytesRead = 0;
                while ((bytesRead = in.read(buffer)) > 0) {
                    out.write(buffer, 0, bytesRead);
                }
                System.out.println("Done with: " + inputFiles[i].getPath().getName());
                in.close();
            }
        } finally {
            if (in != null)
                in.close();
            if (out != null)
                out.close();
        }
    }
}
