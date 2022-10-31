SELECT ename, job, sal, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND NOT EXISTS (SELECT * FROM salgrade WHERE e.sal = hisal);