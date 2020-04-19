{"version":"NotebookV1","origId":17383863,"name":"Stream-Generator","language":"sql","commands":[{"version":"CommandV1","origId":17383864,"guid":"aca7b9da-c2a4-46f4-b138-917970d4034a","subtype":"command","commandType":"auto","position":1.0,"command":"\n%python\nclass DummyDataGenerator:\n  streamDirectory = \"dbfs:/tmp/{}/new-flights\".format(username)\n\nNone # suppress output","commandVersion":0,"state":"finished","results":null,"errorSummary":null,"error":null,"workflows":[],"startTime":0,"submitTime":0,"finishTime":0,"collapsed":false,"bindings":{},"inputWidgets":{},"displayType":"table","width":"auto","height":"auto","xColumns":null,"yColumns":null,"pivotColumns":null,"pivotAggregation":null,"useConsistentColors":false,"customPlotOptions":{},"commentThread":[],"commentsVisible":false,"parentHierarchy":[],"diffInserts":[],"diffDeletes":[],"globalVars":{},"latestUser":"","latestUserId":"100006","commandTitle":"","showCommandTitle":false,"hideCommandCode":false,"hideCommandResult":false,"isLockedInExamMode":false,"iPythonMetadata":null,"streamStates":{},"datasetPreviewNameToCmdIdMap":{},"nuid":"6ea64842-de6c-486e-9198-39cd7e5dd326"},{"version":"CommandV1","origId":17383865,"guid":"fbc80946-3bda-415c-abb5-8f1b8b84df1d","subtype":"command","commandType":"auto","position":2.0,"command":"%scala\n\nimport scala.util.Random\nimport java.io._\nimport java.time._\n\n// Notebook #2 has to set this to 8, we are setting\n// it to 200 to \"restore\" the default behavior.\nspark.conf.set(\"spark.sql.shuffle.partitions\", 200)\n\n// Make the username available to all other languages.\n// \"WARNING: use of the \"current\" username is unpredictable\n// when multiple users are collaborating and should be replaced\n// with the notebook ID instead.\nval username = com.databricks.logging.AttributionContext.current.tags(com.databricks.logging.BaseTagDefinitions.TAG_USER);\nspark.conf.set(\"com.databricks.training.username\", username)\n\nobject DummyDataGenerator extends Runnable {\n  var runner : Thread = null;\n  val className = getClass().getName()\n  val streamDirectory = s\"dbfs:/tmp/$username/new-flights\"\n  val airlines = Array( (\"American\", 0.15), (\"Delta\", 0.17), (\"Frontier\", 0.19), (\"Hawaiian\", 0.21), (\"JetBlue\", 0.25), (\"United\", 0.30) )\n\n  val rand = new Random(System.currentTimeMillis())\n  var maxDuration = 3 * 60 * 1000 // default to a couple of minutes\n\n  def clean() {\n    System.out.println(\"Removing old files for dummy data generator.\")\n    dbutils.fs.rm(streamDirectory, true)\n    if (dbutils.fs.mkdirs(streamDirectory) == false) {\n      throw new RuntimeException(\"Unable to create temp directory.\")\n    }\n  }\n\n  def run() {\n    val date = LocalDate.now()\n    val start = System.currentTimeMillis()\n\n    while (System.currentTimeMillis() - start < maxDuration) {\n      try {\n        val dir = s\"/dbfs/tmp/$username/new-flights\"\n        val tempFile = File.createTempFile(\"flights-\", \"\", new File(dir)).getAbsolutePath()+\".csv\"\n        val writer = new PrintWriter(tempFile)\n\n        for (airline <- airlines) {\n          val flightNumber = rand.nextInt(1000)+1000\n          val departureTime = LocalDateTime.now().plusHours(-7)\n          val (name, odds) = airline\n          val test = rand.nextDouble()\n\n          val delay = if (test < odds)\n            rand.nextInt(60)+(30*odds)\n            else rand.nextInt(10)-5\n\n          println(s\"- Flight #$flightNumber by $name at $departureTime delayed $delay minutes\")\n          writer.println(s\"\"\" \"$flightNumber\",\"$departureTime\",\"$delay\",\"$name\" \"\"\".trim)\n        }\n        writer.close()\n\n        // wait a couple of seconds\n        Thread.sleep(rand.nextInt(5000))\n\n      } catch {\n        case e: Exception => {\n          printf(\"* Processing failure: %s%n\", e.getMessage())\n          return;\n        }\n      }\n    }\n    println(\"No more flights!\")\n  }\n\n  def start(minutes:Int = 5) {\n    maxDuration = minutes * 60 * 1000\n\n    if (runner != null) {\n      println(\"Stopping dummy data generator.\")\n      runner.interrupt();\n      runner.join();\n    }\n    println(s\"Running dummy data generator for $minutes minutes.\")\n    runner = new Thread(this);\n    runner.start();\n  }\n\n  def stop() {\n    start(0)\n  }\n}\n\nDummyDataGenerator.clean()\n\ndisplayHTML(\"Imported streaming logic...\") // suppress output\n","commandVersion":0,"state":"finished","results":null,"errorSummary":null,"error":null,"workflows":[],"startTime":0,"submitTime":0,"finishTime":0,"collapsed":false,"bindings":{},"inputWidgets":{},"displayType":"table","width":"auto","height":"auto","xColumns":null,"yColumns":null,"pivotColumns":null,"pivotAggregation":null,"useConsistentColors":false,"customPlotOptions":{},"commentThread":[],"commentsVisible":false,"parentHierarchy":[],"diffInserts":[],"diffDeletes":[],"globalVars":{},"latestUser":"","latestUserId":"100006","commandTitle":"","showCommandTitle":false,"hideCommandCode":false,"hideCommandResult":false,"isLockedInExamMode":false,"iPythonMetadata":null,"streamStates":{},"datasetPreviewNameToCmdIdMap":{},"nuid":"d6d4d283-0edb-4c09-9948-265b5f12fd91"}],"dashboards":[],"guid":"7ee1bbab-7c9a-495a-8100-198638a812ea","globalVars":{},"iPythonMetadata":null,"inputWidgets":{}}