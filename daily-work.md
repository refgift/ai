# Daily development of the license software. The 10:00 job takes the first open item.
# An item is `- [ ] FILE: the development step`. The job checks the box after it lands.
# A customer gits this project at their site and runs sapience in an isolated room.
# This job develops that software. 
# When the list is empty, the job still develops one of sapience, prn.c, pcn.c, ai.fst, fai.fst, or daily.sh.

- [ ] prn.c: One development step on the recognition perceptron. recognition.h may change with it, including its weights. 
- [ ] pcn.c: One development step on the calculation perceptron. calculation.h may change with it, including its weights. 
- [ ] ai.fst: One development step on the testing AI a customer tests in situ. fai.fst may change with it. 
- [ ] sapience: One development step on the test harness. 
- [ ] daily.sh: One development step on this job so the next day develops the software more safely. 
- [ ] README.md: One development step on the operator documentation. A customer gits this project at their site, uses an isolated computer room, and runs sapience to test their AI in situ. 
     Say that, and how to build the programs.
     
The development work measures the result with "quality filename" like quality ai.fst Before and after will measure the quantity of change made in the development. The quality utillity result should
be recorded in the path.log each day.
