hadoop-mrx
==========

A working example of Java MapReduce client for Hadoop-2

Details
=======
The Hadoop for Dummies has got this example to explain how to write the Java MapReduce client. The code provided works, but there's no citation for a working maven based project that's ready to run. This project fills that void. Just clone the repo and build it with Maven 3. 

Commands:

1. mvn install
2. Download the flight data from [stat-computing](http://stat-computing.org/dataexpo/2009/the-data.html).
3. Import it into hdfs after extracting/uncompressing. For instance, for 2008 data:
  1. hdfs dfs -put 2008.csv (this puts the datafile in hadoop as say: /user/kedar/2008.csv)
  2. hdfs dfs -ls  -h -R
4. Save the jar from the project build (target folder) as say flight-carriers.jar
5. hadoop jar flight-carriers.jar org.kedar.mrx.FlightsByCarrier /user/kedar/2008.csv /user/kedar/output/flightscount 
