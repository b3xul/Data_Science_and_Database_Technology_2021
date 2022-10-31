select dname
from dept
where deptno in (select deptno
                 from emp
                 where job = 'PHILOSOPHER');

/* Indice su job (b-tree, hash, bitmap) */
CREATE INDEX emp_job ON EMP(JOB);
ANALYZE INDEX emp_job COMPUTE STATISTICS;
DROP INDEX emp_job;

CREATE BITMAP INDEX emp_job_bitmap ON EMP(JOB);
ANALYZE INDEX emp_job_bitmap COMPUTE STATISTICS;
DROP INDEX emp_job_bitmap;

CREATE INDEX emp_job_hash ON EMP(JOB)
GLOBAL PARTITION BY HASH (JOB);
ANALYZE INDEX emp_job_hash COMPUTE STATISTICS;
DROP INDEX emp_job_hash;

/* Indice composito su deptno,job */
CREATE INDEX emp_deptno_job_hash ON EMP(DEPTNO,JOB)
GLOBAL PARTITION BY HASH (DEPTNO,JOB);
ANALYZE INDEX emp_deptno_job_hash COMPUTE STATISTICS;
DROP INDEX emp_deptno_job_hash;

/* Miglior combo: prossimi 2 (anche non hash) */
/* Indice composito su job,deptno */
CREATE INDEX emp_job_deptno_hash ON EMP(JOB,DEPTNO)
GLOBAL PARTITION BY HASH (JOB,DEPTNO);
ANALYZE INDEX emp_job_deptno_hash COMPUTE STATISTICS;
DROP INDEX emp_job_deptno_hash;

/* Indice su deptno,dname */
CREATE INDEX dept_deptno_dname_hash ON DEPT(deptno,dname)
GLOBAL PARTITION BY HASH (deptno,dname);
ANALYZE INDEX dept_deptno_dname_hash COMPUTE STATISTICS;
DROP INDEX dept_deptno_dname_hash;
