SELECT *
FROM EMP;   --50111 Impiegati totali

SELECT *
FROM EMP
WHERE DEPTNO NOT IN (SELECT DEPTNO
                    FROM DEPT); --104 Impiegati con deptno non in dept

SELECT *
FROM EMP e, DEPT d
WHERE e.DEPTNO = d.DEPTNO; --50007 Impiegati con un dipartimento esistente

SELECT ename, job, sal, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND NOT EXISTS (SELECT * FROM salgrade WHERE e.sal = hisal);  --30925 Impiegati con dipartimento esistente che non guadagnano il massimo

SELECT *
FROM emp e2
WHERE NOT EXISTS (SELECT * FROM SALGRADE WHERE e2.sal=hisal);   --30998 Impiegati che non guadagnano il massimo

SELECT /* ORDERED */ ename, job, sal, dname
FROM (SELECT *
      FROM emp e2
      WHERE NOT EXISTS (SELECT * FROM SALGRADE WHERE e2.sal=hisal)) e, dept d
WHERE e.deptno = d.deptno;  --30925 Impiegati con dipartimento esistente che non guadagnano il massimo

SELECT *
FROM USER_OUTLINES;

SELECT * FROM TABLE(
    DBMS_XPLAN.DISPLAY_SQL_PLAN_BASELINE(
        sql_handle=>'SYS_OUTLINE_20122913163487501',
        format=>'basic'));

SHOW all;

select * from V$parameter where name='db_file_multiblock_read_count'

select * from emp where sal=0