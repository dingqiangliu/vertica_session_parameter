/*****************************
 *
 * User Defined Scalar Functions for user defined session parameters
 *
 * Copyright DingQiang Liu(dingqiangliu@gmail.com), 2012 - 2017
 */

-- Step 1: Create LIBRARY 
\set libfile '\''`pwd`'/.libs/sessionparameter.so\'';
CREATE LIBRARY sessionparameter AS :libfile;

-- Step 2: Create cube/rollup Factory
\set tmpfile '/tmp/sessionparameterinstall.sql'
\! cat /dev/null > :tmpfile

\t
\o :tmpfile
select 'CREATE FUNCTION IF NOT EXISTS '||replace(obj_name, 'Factory', '')||' AS LANGUAGE ''C++'' NAME '''||obj_name||''' LIBRARY sessionparameter not fenced;' from user_library_manifest where lib_name='sessionparameter' and obj_type='Scalar Function';
select 'GRANT EXECUTE ON FUNCTION '||replace(obj_name, 'Factory', '')||' ('||arg_types||') to PUBLIC;' from user_library_manifest where lib_name='sessionparameter' and obj_type='Scalar Function';

\o
\t

\i :tmpfile
\! rm -f :tmpfile
