CPATH='.;../lib/hamcrest-core-1.3.jar;../lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

expectedfile="student-submission/$2"

files=`find student-submission`
FLAG=1

for file in $files
do
    if [[ -f $file && $file == $expectedfile ]]
    then
        echo "Correct file found"
        FLAG=0
        cp -r ./student-submission/*.java ./grading-area
        cp -r ./*.java ./grading-area
        cd ./grading-area
        javac -cp $CPATH *.java
        if [[ $? -ne 0 ]]
        then
            echo "compilation failed idiot"
            exit
        fi
        java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > output.txt
        grep -i -o "[0-9]*" output.txt > gr1.txt
        grep "[0-9]*" gr1.txt | tail -2 > gr2.txt
        TESTSRUN=`grep -m 1 "[0-9]*" gr2.txt`
        TESTSFAIL=`grep "[0-9]*" gr2.txt | tail -1`
        TESTSRUN=$(($TESTSRUN))
        TESTSFAIL=$(($TESTSFAIL))
        TESTSPASS=$(($TESTSRUN-$TESTSFAIL))
        echo "Score: $(($TESTSPASS/$TESTSRUN))"
    fi
done

if [[ $FLAG -eq 1 ]]
then
    echo "File not found"
fi

