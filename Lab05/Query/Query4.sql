select avg(e.sal)
from emp e
where e.deptno < 10 and e.sal > 100 and e.sal < 200;

CREATE INDEX emp_deptno ON EMP(DEPTNO);
ANALYZE INDEX emp_deptno COMPUTE STATISTICS;
DROP INDEX emp_deptno;

CREATE INDEX emp_sal ON EMP(SAL);
ANALYZE INDEX emp_sal COMPUTE STATISTICS;
DROP INDEX emp_sal;

CREATE INDEX emp_sal_deptno ON EMP(SAL,DEPTNO);
ANALYZE INDEX emp_sal_deptno COMPUTE STATISTICS;
DROP INDEX emp_sal_deptno;

CREATE INDEX emp_deptno_sal ON EMP(DEPTNO,SAL);
ANALYZE INDEX emp_deptno_sal COMPUTE STATISTICS;
DROP INDEX emp_deptno_sal;

CREATE BITMAP INDEX emp_deptno_sal ON EMP(DEPTNO,SAL);
ANALYZE INDEX emp_deptno_sal COMPUTE STATISTICS;