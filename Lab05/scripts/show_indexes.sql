--Per visualizzare le statistiche relative agli indici:
select USER_INDEXES.INDEX_NAME as INDEX_NAME, INDEX_TYPE, USER_INDEXES.TABLE_NAME,
       COLUMN_NAME||'('||COLUMN_POSITION||')' as COLUMN_NAME,
       BLEVEL, LEAF_BLOCKS, DISTINCT_KEYS, CLUSTERING_FACTOR
from user_indexes, user_ind_columns
where user_indexes.index_name=user_ind_columns.index_name and
      user_indexes.table_name=user_ind_columns.table_name and
      (user_indexes.table_name='DEPT' or user_indexes.table_name='SALGRADE' or user_indexes.table_name='EMP');

--Per visualizzare le statistiche relative alle tabelle:
SELECT TABLE_NAME, NUM_ROWS, BLOCKS, EMPTY_BLOCKS, AVG_SPACE, CHAIN_CNT,
AVG_ROW_LEN
FROM USER_TABLES
WHERE (table_name='DEPT' or table_name='SALGRADE' or table_name='EMP');

--Per visualizzare le statistiche sugli attributi delle tabelle:
SELECT table_name, COLUMN_NAME, NUM_DISTINCT, NUM_NULLS, NUM_BUCKETS, DENSITY, HISTOGRAM
FROM USER_TAB_COL_STATISTICS
WHERE (table_name='DEPT' or table_name='SALGRADE' or table_name='EMP')
ORDER BY TABLE_NAME;

--Per visualizzare gli istogrammi (distribuzione valori degli attributi):
SELECT *
FROM USER_HISTOGRAMS
WHERE (table_name='DEPT' or table_name='SALGRADE' or table_name='EMP');

/*
SELECT table_name, COLUMN_NAME, NUM_DISTINCT, NUM_NULLS, NUM_BUCKETS, DENSITY, HISTOGRAM
FROM USER_TAB_COL_STATISTICS
WHERE table_name='EMP' and column_name='JOB';

SELECT *
FROM USER_HISTOGRAMS
WHERE table_name='EMP' and column_name='JOB'
ORDER BY ENDPOINT_NUMBER;*/
