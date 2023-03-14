name := "abc9-example"
version := "0.0.0"
scalaVersion := "2.13.10"

scalacOptions ++= Seq(
  "-feature",
  "-deprecation",
  "-language:reflectiveCalls",
  "-Xcheckinit",
  "-Xfatal-warnings",
  "-Ymacro-annotations"
)

libraryDependencies += "edu.berkeley.cs" %% "chisel3" % "3.5.5"
libraryDependencies += "edu.berkeley.cs" %% "chiseltest" % "0.5.5"

addCompilerPlugin(
  "edu.berkeley.cs" % "chisel3-plugin" % "3.5.5" cross CrossVersion.full
)
