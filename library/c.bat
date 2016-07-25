REM ---------------------------------------------------------------
REM
REM v05/29/2016: Processing 3.x compatible version
REM
REM ---------------------------------------------------------------

set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.6.0_45\bin
REM set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_20

set path=C:\Program Files (x86)\Java\jdk1.6.0_45\bin
REM set path=C:\Program Files (x86)\Java\jdk1.8.0_20\bin

REM set CP=zxingcore.jar;zxingjavase.jar;C:\processing-3.1.1-32\core\library\core.jar;C:\processing-3.1.1-32\lib\pde.jar
set CP=zxingcore.jar;zxingjavase.jar;C:\processing-2.2.1-32\core\library\core.jar;C:\processing-2.2.1-32\lib\pde.jar
REM set CP=core-3.2.1.jar;javase-3.2.1.jar;C:\processing-3.1.1-32\core\library\core.jar;C:\processing-3.1.1-32\lib\pde.jar

javac -cp %CP% -d . ../src/*.java

jar cvf zxing4p3.jar com\cage\zxing4p3\*.class
 
javadoc -classpath %CP% -d ../reference ../src/*.java