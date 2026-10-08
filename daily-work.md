# Daily development of the license software. The 10:00 job takes the first open item.
# An item is `- [ ] FILE: the development step`. The job checks the box after it lands.
# A customer gits this project at their site and runs sapience in an isolated room.
# This job develops that software. It does not run sapience, prn, or pcn.
# When the list is empty, the job still develops one of sapience, prn.c, pcn.c, ai.fst, fai.fst, or daily.sh.

- [ ] prn.c: One development step on the recognition perceptron. recognition.h may change with it, including its weights. Do not run prn.
- [ ] pcn.c: One development step on the calculation perceptron. calculation.h may change with it, including its weights. Do not run pcn.
- [ ] ai.fst: One development step on the testing AI a customer tests in situ. fai.fst may change with it. Do not run it.
- [ ] sapience: One development step on the test harness. Do not start a probe run.
- [ ] daily.sh: One development step on this job so the next day develops the software more safely. Do not run the customer test.
- [ ] README.md: One development step on the operator documentation. A customer gits this project at their site, uses an isolated computer room, and runs sapience to test their AI in situ. Say that, and how to build the programs. Do not run a test.
