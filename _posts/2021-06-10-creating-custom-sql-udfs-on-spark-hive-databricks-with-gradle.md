---
layout: post
title: Creating custom SQL UDFs on Spark (Hive) and Databricks with Gradle and Java
author: Tadas Šubonis
date: '2021-06-10'
tags:
 - spark
 - sql
 - gradle
 - databricks
 - spark sql
 - hive
---


# Intro
Recently, I was looking to find a good working example on how to create a custom Spark SQL 
User-Defined-Function (UDF) on Java on build that using a modern tool like Gradle.

Usually, my go-to choice for UDFs is Python but only using SQL-based functions 

I didn't manage to find a quick started quickly on Google so I'll share one here.



# Gradle config
Testing with Gradle version 6.8 .


```groovy

plugins {
    // to bundle a jar with all dependencies we will be using shadow plugin
    id 'com.github.johnrengelman.shadow' version '6.1.0'
    id 'java'
}

group 'com.tasubo.dev'
version '1.1-SNAPSHOT'

repositories {
    mavenCentral()
}

dependencies {
    // these dependencies are (or should be) available on the cluster itself so no
    // need to bundle these
    compileOnly 'org.apache.hadoop:hadoop-client:3.3.0'
    compileOnly 'org.apache.hive:hive-exec:3.1.2'

    // some external lib that we need to include in the JAR
    implementation group: 'com.neovisionaries', name: 'nv-i18n', version: '1.28' 

    testImplementation 'org.junit.jupiter:junit-jupiter-api:5.7.0'
    
    // hive-exec is needed to make the tests run
    testImplementation 'org.apache.hive:hive-exec:3.1.2'
    testRuntimeOnly 'org.junit.jupiter:junit-jupiter-engine:5.7.0'
}

test {
    useJUnitPlatform()
}
```

# Java UDF
Specific (simple) UDF example that can work with one data type.

```java
package com.tasubo.dev;

import com.neovisionaries.i18n.CountryCode;
import org.apache.hadoop.hive.ql.exec.UDF;

public class StarterUdf extends UDF {
    public String evaluate(String code) {
        return CountryCode.getByAlpha2Code(code).getAlpha3();
    }
}
```

# Java Generic UDF
 Using GenericUDF it's possible
to make the UDF handle multiple different types, process complex (nested) types and etc.

Showing the full example is outside of the scope, but here is a copy-pastable example of the Generic-version UDF.

```java
public class StarterGenericUdf extends GenericUDF {
    public String evaluate(String code) {
        return CountryCode.getByAlpha2Code(code).getAlpha3();
    }

    @Override
    public ObjectInspector initialize(ObjectInspector[] arguments) throws UDFArgumentException {
        return null;
    }

    @Override
    public Object evaluate(DeferredObject[] arguments) throws HiveException {
        return CountryCode.getByAlpha2Code(arguments[0].get().toString()).getAlpha3();
    }

    @Override
    public String getDisplayString(String[] children) {
        return null;
    }
}
```

# Tests
A few simple tests should be in order too

```java
import com.tasubo.dev.StarterUdf;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class SampleTest {
    StarterUdf fun = new StarterUdf();

    @Test
    public void two_letter_code_should_be_converted_to_iso_code() {
        String outcome = fun.evaluate("CA");
        assertEquals("CAN", outcome);
    }

}
```


# Using in SQL

To build a final JAR we will be using [Shadow](https://imperceptiblethoughts.com/shadow/) plugin:
```
gradlew shadowJar
ls build\libs
spark-sql-udfs-starter-1.2-SNAPSHOT-all.jar
```




Finally, we can upload the JAR to the FileStore (on [DBFS](https://docs.databricks.com/data/databricks-file-system.html)) 
and
use the following on Spark SQL (Databricks):

```sql
%sql 
CREATE OR REPLACE FUNCTION convert_country_code AS 'com.tasubo.dev.StarterUdf'
    USING JAR 'dbfs:/FileStore/spark_sql_udf_starter_1_5_SNAPSHOT_all.jar';
--REFRESH  FUNCTION convert_country_code;

select convert_country_code("CA") as iso;
```


# Code
The example here can be found on GitHub [here](https://github.com/tadas-subonis/spark-sql-udfs-starter)




