# maven-assembly-plugin ignores the documented permission defaults.

Running the maven build different umasks affects the files generated by the maven-assembly-plugin IF the fileMode
and directoryMode have not been specified.

The run.sh script runs the same tiny project with several umask settings.
And with 2 assembly definitions: One which should get the default values, one which explicitly sets the default values.

The created files have the permissions that are to be expected:

    -rw-rw-r-- 1 nbasjes nbasjes    3100 feb 27 00:15 target-0002/assemblyumask-1.0-SNAPSHOT.jar
    -rw-rw-r-- 1 nbasjes nbasjes 2152173 feb 27 00:15 target-0002/assemblyumask-1.0-SNAPSHOT-udf-default.jar
    -rw-rw-r-- 1 nbasjes nbasjes 2152173 feb 27 00:15 target-0002/assemblyumask-1.0-SNAPSHOT-udf-mode.jar
    -rw-r--r-- 1 nbasjes nbasjes    3100 feb 27 00:15 target-0022/assemblyumask-1.0-SNAPSHOT.jar
    -rw-r--r-- 1 nbasjes nbasjes 2152173 feb 27 00:15 target-0022/assemblyumask-1.0-SNAPSHOT-udf-default.jar
    -rw-r--r-- 1 nbasjes nbasjes 2152173 feb 27 00:15 target-0022/assemblyumask-1.0-SNAPSHOT-udf-mode.jar
    -rw--w--w- 1 nbasjes nbasjes    3100 feb 27 00:15 target-0055/assemblyumask-1.0-SNAPSHOT.jar
    -rw--w--w- 1 nbasjes nbasjes 2152173 feb 27 00:15 target-0055/assemblyumask-1.0-SNAPSHOT-udf-default.jar
    -rw--w--w- 1 nbasjes nbasjes 2152173 feb 27 00:15 target-0055/assemblyumask-1.0-SNAPSHOT-udf-mode.jar

The base files are all the same 

    ec364137a2c7678ef0c8f495652efe36  target-0002/assemblyumask-1.0-SNAPSHOT.jar
    ec364137a2c7678ef0c8f495652efe36  target-0022/assemblyumask-1.0-SNAPSHOT.jar
    ec364137a2c7678ef0c8f495652efe36  target-0055/assemblyumask-1.0-SNAPSHOT.jar

The maven-assembly-plugin created files WITH fileMode and directoryMode are all the same

    ba12113ad2b95a4fc75d99aa5bfd4e4f  target-0002/assemblyumask-1.0-SNAPSHOT-udf-mode.jar
    ba12113ad2b95a4fc75d99aa5bfd4e4f  target-0022/assemblyumask-1.0-SNAPSHOT-udf-mode.jar
    ba12113ad2b95a4fc75d99aa5bfd4e4f  target-0055/assemblyumask-1.0-SNAPSHOT-udf-mode.jar

The maven-assembly-plugin created files WITHOUT fileMode and directoryMode are all different

    316e5d6b2e85b7d829e938a5797370d7  target-0022/assemblyumask-1.0-SNAPSHOT-udf-default.jar
    3375500189ef3087f8943d518209a5e6  target-0055/assemblyumask-1.0-SNAPSHOT-udf-default.jar
    c341cbbc9f21bb64b817b8bbdaae8608  target-0002/assemblyumask-1.0-SNAPSHOT-udf-default.jar

The permissions IN the files are the difference:

    $ diffoscope target-0055/assemblyumask-1.0-SNAPSHOT-udf-mode.jar target-0055/assemblyumask-1.0-SNAPSHOT-udf-default.jar
    --- target-0055/assemblyumask-1.0-SNAPSHOT-udf-mode.jar
    +++ target-0055/assemblyumask-1.0-SNAPSHOT-udf-default.jar
    │┄ Archive contents identical but files differ, possibly due to different compression levels. Falling back to binary comparison.
    ├── zipinfo {}
    │ @@ -1,13 +1,13 @@
    │  Zip file size: 2152173 bytes, number of entries: 1515
    │  drwxr-xr-x  2.0 unx        0 b- stor 03-Mar-03 03:03 META-INF/
    │  -rw-r--r--  2.0 unx       79 b- defN 03-Mar-03 03:03 META-INF/MANIFEST.MF
    │ -drwxr-xr-x  2.0 unx        0 b- stor 03-Mar-03 03:03 nl/
    │ -drwxr-xr-x  2.0 unx        0 b- stor 03-Mar-03 03:03 nl/basjes/
    │ -drwxr-xr-x  2.0 unx        0 b- stor 03-Mar-03 03:03 nl/basjes/bugreports/
    │ +drwx-w--w-  2.0 unx        0 b- stor 03-Mar-03 03:03 nl/
    │ +drwx-w--w-  2.0 unx        0 b- stor 03-Mar-03 03:03 nl/basjes/
    │ +drwx-w--w-  2.0 unx        0 b- stor 03-Mar-03 03:03 nl/basjes/bugreports/
    │  drwxr-xr-x  2.0 unx        0 b- stor 03-Mar-03 03:03 META-INF/org/
    │  drwxr-xr-x  2.0 unx        0 b- stor 03-Mar-03 03:03 META-INF/org/apache/
    │  drwxr-xr-x  2.0 unx        0 b- stor 03-Mar-03 03:03 META-INF/org/apache/logging/
    │  drwxr-xr-x  2.0 unx        0 b- stor 03-Mar-03 03:03 META-INF/org/apache/logging/log4j/
    │  drwxr-xr-x  2.0 unx        0 b- stor 03-Mar-03 03:03 META-INF/org/apache/logging/log4j/core/
    │  drwxr-xr-x  2.0 unx        0 b- stor 03-Mar-03 03:03 META-INF/org/apache/logging/log4j/core/config/
    │  drwxr-xr-x  2.0 unx        0 b- stor 03-Mar-03 03:03 META-INF/org/apache/logging/log4j/core/config/plugins/
    │ @@ -1508,10 +1508,10 @@
    │  -rw-r--r--  2.0 unx      223 b- defN 03-Mar-03 03:03 org/apache/logging/log4j/util/Unbox$1.class
    │  -rw-r--r--  2.0 unx     1135 b- defN 03-Mar-03 03:03 org/apache/logging/log4j/util/Unbox$State.class
    │  -rw-r--r--  2.0 unx     1779 b- defN 03-Mar-03 03:03 org/apache/logging/log4j/util/Unbox$WebSafeState.class
    │  -rw-r--r--  2.0 unx     4595 b- defN 03-Mar-03 03:03 org/apache/logging/log4j/util/Unbox.class
    │  -rw-r--r--  2.0 unx      135 b- defN 03-Mar-03 03:03 org/apache/logging/log4j/util/package-info.class
    │  -rw-r--r--  2.0 unx     6283 b- defN 03-Mar-03 03:03 META-INF/maven/org.apache.logging.log4j/log4j-api/pom.xml
    │  -rw-r--r--  2.0 unx       69 b- defN 03-Mar-03 03:03 META-INF/maven/org.apache.logging.log4j/log4j-api/pom.properties
    │ --rw-r--r--  2.0 unx      494 b- defN 03-Mar-03 03:03 log4j2.xml
    │ --rw-r--r--  2.0 unx      605 b- defN 03-Mar-03 03:03 nl/basjes/bugreports/App.class
    │ +-rw-rw-r--  2.0 unx      494 b- defN 03-Mar-03 03:03 log4j2.xml
    │ +-rw--w--w-  2.0 unx      605 b- defN 03-Mar-03 03:03 nl/basjes/bugreports/App.class
    │  1515 files, 4853233 bytes uncompressed, 1839331 bytes compressed:  62.1%

